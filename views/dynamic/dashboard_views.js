




//Completed Exercise for Workout
/*
    Used to listen for the checkboxes being checked
    will push exercise data to DB when the workout is complete
*/
var exerciseComplete = [];

var numRows = 0;
if(document.getElementById("workout-table") != null) {
    numRows = document.getElementById("workout-table").rows.length;
    //console.log(numRows);
}

if(numRows > 0) {
    for(i = 0; i < numRows-1; i++){
        exerciseComplete.push(0);
    }
    console.log(exerciseComplete);

    document.addEventListener('click', function(event){
        if(event.target.matches('.done')) {
            if(event.target.checked) {
                console.log("checked");
                exerciseComplete[event.path[2].rowIndex-1] = 1;
                console.log(exerciseComplete);
            } else {
                console.log("checked");
                exerciseComplete[event.path[2].rowIndex-1] = 0;
                console.log(exerciseComplete);
            }
        }
    });
}







//Creating and adding a new Workout
//Adding new workoutto form
/*
    Pulls up a new form on the page to add a workout
    will push new workout to DB and add it to the workout without any other stats
*/
// $(".grid-container").mouseup(function (e) { 
//     if ($(e.target).closest("#add-workout-form-container").length 
//                 === 0) { 
//         $("#add-workout-form-container").hide(); 
//         document.getElementsByClassName("grid-container")[0].style.opacity = 1;
//     } 
// });


var addWorkoutButton = document.getElementById("add-new-workout-button");
addWorkoutButton.addEventListener("click", addWorkout);

function addWorkout() {
    console.log("Clicked Add New Workout Button");
    var workoutFormCon = document.getElementById("add-workout-form-container");
    
    //make everything but the form transparent
    document.getElementsByClassName("grid-container")[0].style.opacity = .5;
    
    workoutFormCon.style.display = "flex";
    workoutFormCon.style.opacity = 1;
    workoutFormCon.style.zIndex = 5;
}









//Adding new exercise to form
/*
    Pulls up a new form on the page to add an exercise
    will push exercise data to DB and add it to the workout without any other stats
*/
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

function addExercise() {
    var exerciseFormCon = document.getElementById("add-exercise-form-container");
    
    //make everything but the form transparent
    document.getElementsByClassName("grid-container")[0].style.opacity = .5;
    
    exerciseFormCon.style.display = "flex";
    exerciseFormCon.style.opacity = 1;
    exerciseFormCon.style.zIndex = 5;
}

//Gets all the Exercises stored in the database and returns them to the autocomplete
async function getExerciseNames(){
    console.log("Inside the getExerciseNames Function");
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


//Autocomplete for adding a new exercise to the form
$(function() {
    var names = getExerciseNames();
    names.then(results => {
        // console.log(results);
        $("#add-exercise-form-exercise-name").autocomplete({
            source: results
        });
    });
});




