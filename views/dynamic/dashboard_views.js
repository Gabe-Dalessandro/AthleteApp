

var numRows = document.getElementById("workout-table").rows.length;
console.log(numRows);


// Used to listen for the checkboxes being checked
    //will be used when the workout is completed
var exerciseComplete = [];

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






async function getExerciseNames(){
    console.log("Inside the getExerciseNames Function");
    var exerciseNames = [];
  
    var response = await fetch("/dashboard/my-workouts/search-exercises");
    var data = await response.json()
    .catch(error => {
        console.log(error);
    });

    data.forEach(exercise => {
        exerciseNames.push(exercise.exercise_name);
    })
    console.log(exerciseNames);
    return exerciseNames;

    
}



// Adding new exercise
var addExerciseButton = document.getElementById("add-new-exercise");
addExerciseButton.addEventListener("click", addExercise);

function addExercise() {
    console.log("Add Exercise Button was clicked");
    

    var exerciseFormCon = document.getElementById("add-exercise-form-container");
    
    //make everything but the form transparent
    document.getElementsByClassName("grid-container")[0].style.opacity = .5;
    
    
    exerciseFormCon.style.display = "flex";
    exerciseFormCon.style.opacity = 1;
    exerciseFormCon.style.zIndex = 5;


}


//Hides the add exercise form when clicking off of it
$(".grid-container").mouseup(function (e) { 
    if ($(e.target).closest("#add-exercise-form-container").length 
                === 0) { 
        $("#add-exercise-form-container").hide(); 
        document.getElementsByClassName("grid-container")[0].style.opacity = 1;
    } 
});






//Autocomplete for adding a new exercise
$(function() {

    console.log("Inside autocomplete function");
    var names = getExerciseNames();
    names.then(results => {
        console.log(results);

        $("#add-exercise-form-exercise-name").autocomplete({
            source: results
        });
    });

    console.log("Finished saving the exercise names"); 
});




