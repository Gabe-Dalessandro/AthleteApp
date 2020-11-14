

//Displaying the most recent workout data from the clicked workout
/*
    - Populates the workout info in the center with the most recently completed workout session exercise
    - also lists all the workout sessions done for this workout inside the box to the left
        - this box will be scrollable
*/
var workoutListBox = document.getElementById("all-workouts-from-workout-list");
workoutListBox.addEventListener("click", displayWorkoutInfo);

async function displayWorkoutInfo(event) {
    let clickedWorkoutName = event.srcElement.innerText;
    console.log("\n\n======= Clicked on a workout: getting its data =======");
    console.log("\tWorkout Clicked: " + event.srcElement.innerText);

    //gets the last workout session's exercises for the workout to populate the table
    var response = await fetch("/dashboard/my-workouts/get-workout-data/" + clickedWorkoutName);
    var data = await response.json()
    .catch(error => {
        console.log(error);
    });


    console.log("\tRecieved the workout data from server");

    //change the workout title   
    let workoutTitleHTML = document.getElementsByClassName('main-dash-dynamic-workout-stats-title')[0];
    workoutTitleHTML.innerText = clickedWorkoutName;
    
    //Change the date in the table
    let table = document.getElementById('workout-table');
    
    //delete the old exercises from table
    var tableRows = table.rows;
    var numOldRows = tableRows.length;
    for(var j = 0; j < numOldRows-1; j++) {
        table.deleteRow(1);
    }

    let workoutSessionID;
    console.log(data);
    //to determine if a workout session exists yet
    if (data.length > 0) {
        workoutSessionID = data[0].workout_session_id;
    }

    //add the exercises from the most recent workout session
        //if a session has been completed before, data will have exercises in it
    if(typeof workoutSessionID != 'undefined') {
        var date = data[0].date_completed;
        workoutTitleHTML.innerText = clickedWorkoutName + "\n Last Completed: " + date;
        
        //populate the table with the exercises from the most recent session
        let numNewRows = data.length;
        for(var i = 0; i < numNewRows; i++) {
            var newRow = table.insertRow(1);
            nameCell = newRow.insertCell(0).innerText = data[i].exercise_name;
            
            setsCell = newRow.insertCell(1);
            setsCell.innerText = data[i].sets;
            setsCell.contentEditable = "true";

            weightCell = newRow.insertCell(2);
            weightCell.innerText = data[i].weight;
            weightCell.contentEditable = "true";

            repsCell = newRow.insertCell(3);
            repsCell.innerText = data[i].reps;
            repsCell.contentEditable = 'true';

            newRow.insertCell(4).innerHTML = "<input class=\"done\" type=\"checkbox\"></input>";
        }
    }
    //else: no workout_session exists yet: fill in with just exercies
    else if (data.length > 0){
        workoutTitleHTML.innerText = workoutTitleHTML.innerText + "\n" + "Complete this workout for the 1st time!";
            //populate the table with the exercises from the most recent session
            let numNewRows = data.length;
            for(var i = 0; i < numNewRows; i++) {
                var newRow = table.insertRow(1);
                nameCell = newRow.insertCell(0).innerText = data[i].exercise_name;
                
                setsCell = newRow.insertCell(1);
                setsCell.innerText = 0;
                setsCell.contentEditable = "true";
    
                weightCell = newRow.insertCell(2);
                weightCell.innerText = 0;
                weightCell.contentEditable = "true";
    
                repsCell = newRow.insertCell(3);
                repsCell.innerText = 0;
                repsCell.contentEditable = 'true';
    
                newRow.insertCell(4).innerHTML = "<input class=\"done\" type=\"checkbox\"></input>";
            }
    }
    //else no exercises exists for the workout yet
    else {
        workoutTitleHTML.innerText = workoutTitleHTML.innerText + "\n" + "Add some new exercises to this workout!";
    }
   

    //change the workout_id within the add_exercise form
    var workoutID_response = await fetch("/dashboard/my-workouts/get-workoutid/"+ clickedWorkoutName);
    var workoutID = await workoutID_response.json()
    .catch(error => {
        console.log(error);
    });

    var addExerciseForm = document.getElementById('add-exercise-form');
    addExerciseForm.action = "/dashboard/my-workouts/add-new-exercise/" + workoutID;
    console.log("======= Ended function: displayWorkoutInfo(event) =======");
}
//End of displayWorkoutInfo(event)










//Creating and adding a new Workout
//Adding new workoutto form
/*
    Pulls up a new form on the page to add a workout
    will push new workout to DB and add it to the workout without any other stats
*/
var addWorkoutButton = document.getElementById("add-new-workout-button");
addWorkoutButton.addEventListener("click", addWorkout);

function addWorkout() {
    console.log("\n\n======= Clicked Add New Workout Button =======");
    var workoutFormCon = document.getElementById("add-workout-form-container");
    
    //make everything but the form transparent
    document.getElementsByClassName("grid-container")[0].style.opacity = .5;
    
    workoutFormCon.style.display = "flex";
    workoutFormCon.style.opacity = 1;
    workoutFormCon.style.zIndex = 5;
}










//Adding new exercise to a workout
//adds a new exercise to the users workout
/*
    Pulls up a new form on the page to add an exercise
    will push exercise data to DB and add it only to workout_exercises (this is not a session)
*/
// 1) Exercise Form 
//Hides the "add exercise form" when clicking off of it
$(".grid-container").mouseup(function (e) { 
    if ( ($(e.target).closest("#add-exercise-form-container").length  === 0) || 
    $(e.target).closest("#add-workout-form-container").length  === 0) { 
        $("#add-exercise-form-container").hide();
        $("#add-workout-form-container").hide(); 
        document.getElementsByClassName("grid-container")[0].style.opacity = 1;
    } 
});
//Brings up the add exercise form
if(document.getElementById("add-new-exercise") != null) {
    var addExerciseButton = document.getElementById("add-new-exercise");
    addExerciseButton.addEventListener("click", addExercise);
}


// 2) Autocomplete inside the form 
//Gets all the Exercises stored in the database and returns them to the autocomplete
async function getExerciseNames(){
    console.log("Autopopulating all exercises for the autocomplete for the add exercise form");
    var exerciseNames = [];
  
    //Retrieves the data from the DB
    var response = await fetch("/dashboard/my-workouts/search-exercises");
    var data = await response.json()
    .catch(error => {
        console.log(error);
    });

    data.forEach(exercise => {
        exerciseNames.push(exercise.exercise_name);
    })
    // console.log(exerciseNames);
    return exerciseNames;
}

//Auto populates the exercises that are available into the form
$(function() {
    var names = getExerciseNames();
    names.then(results => {
        // console.log(results);
        $("#add-exercise-form-exercise-name").autocomplete({
            source: results
        });
    });
});


// 3) Add_exercise function
//this will pull up the add exercise form 
function addExercise() {
    console.log("\n\n======= Clicked Add New Exercise Button =======");
    var exerciseFormCon = document.getElementById("add-exercise-form-container");
    
    //make everything but the form transparent
    document.getElementsByClassName("grid-container")[0].style.opacity = .5;
    
    exerciseFormCon.style.display = "flex";
    exerciseFormCon.style.opacity = 1;
    exerciseFormCon.style.zIndex = 5;
}










//Complete 1 Exercise for Workout
/*
    Used to listen for the checkboxes being checked
    will push exercise data to DB when the workout is complete
*/
class exerciseStatLine {
    constructor(exerName, sets, weight, reps_or_time){
        this.exerciseName = exerName;
        this.sets = sets;
        this.weight = weight;
        this.reps_or_time = reps_or_time;
    }
}

let exerciseMap = new Map();
var exerciseComplete = [];
var numRows = 0;

//Gets the number of exercises in the table
if(document.getElementById("workout-table") != null) {
    numRows = document.getElementById("workout-table").rows.length;
    //console.log(numRows);
}

//puts an event listener on every exercise
if(numRows > 0) {
    for(i = 0; i < numRows; i++){
        exerciseComplete.push(0);
    }
    // console.log(exerciseComplete);

    document.addEventListener('click', function(event){
        if(event.target.matches('.done')) {
            if(event.target.checked) {
                console.log("checked");

                //retrieve the values within the row
                var exerciseName = event.path[2].cells[0].innerText;
                var sets = event.path[2].cells[1].innerText;
                var weight = event.path[2].cells[2].innerText;
                var reps_or_time = event.path[2].cells[3].innerText;
                
                //put the entire row into the map
                var newStatLine = new exerciseStatLine(exerciseName, sets, weight, reps_or_time);
                exerciseMap.set(exerciseName, newStatLine);
                console.log(exerciseMap.size);
                console.log(exerciseMap);


                exerciseComplete[event.path[2].rowIndex] = 1;
                // console.log(exerciseComplete);
            } else {
                console.log("checked");
                exerciseComplete[event.path[2].rowIndex] = 0;

                //remove the row from the map wen unchecked
                var exerciseName = event.path[2].cells[0].innerText;
                exerciseMap.delete(exerciseName);

                // console.log(exerciseComplete);
            }
        }
    });
}







//Completing an entire workout session
//pushing all the session data into the database
/*
    Gets all the exercise data from the entire workout
    creates a new session, pushes all the exercise data into that session and into the database
*/
var completeSessionButton = document.getElementById("complete-session");
completeSessionButton.addEventListener("click", CompleteSession);

function CompleteSession() {
    console.log("\n\n======= Completed a workout session! =======");
    const Url = "/dashboard/my-workouts/add-session";
    var parameters = {
        headers: {
            'Content-Type': 'application/json',
        },
        method: 'post',
        body: JSON.stringify(exerciseMap)
    }
    
    
    fetch(Url, parameters)
    .then(response => response.json())
    .then(data => {
        console.log("post has completed: " + data);
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}













