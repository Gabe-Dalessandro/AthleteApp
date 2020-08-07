


// var USERDATA = "<%= user %>";


//displays the user's tracked excercises when page loads
const userObjID = document.getElementById("athlete-id").innerHTML;
console.log(userObjID);

const athleteObjString = document.getElementById("athlete-object").innerHTML;
const athleteObj = JSON.parse(athleteObjString)
console.log(athleteObj);


// async function fetchLastName(){
//     console.log("Calling fetch function!");
//     const response = await fetch('http://localhost:8000/dashboard/get-last-name', {
//         method: 'POST',
//         body: userObjID
//     });
//     console.log(response);
// }

// fetchLastName().catch(error => {
//     console.log("Error inside of webpage");
//     console.log(error);
// });


// var lastSelectionText = document.getElementById("my-stats").addEventListner("onchange", )



//Event listeners to populate Selection Box Title when clicked
var myStats = document.getElementById("my-stats").addEventListener("click", populateSelectionTitle);
var myWorkouts = document.getElementById("my-workouts").addEventListener("click", populateSelectionTitle);
var myRewards = document.getElementById("my-rewards").addEventListener("click", populateSelectionTitle);
var myTeam = document.getElementById("my-team").addEventListener("click", populateSelectionTitle);


//Populates the Selection Title with whatever field was clicked
function populateSelectionTitle(){
    console.log("Button was Clicked!"+ this.id);
    divText = document.getElementById(this.id+"-text");
    document.getElementById("select-box-title-text").innerHTML = divText.innerHTML;
}


//listens for the "manage Account" to be clicked on
// var manageActHover = document.getElementById("account-info-manage-account").addEventListener("mouseover", dropMenu);
// var manageActOff = document.getElementById("account-info-manage-account").addEventListener("mouseout", pullUpMenu);

// function dropMenu(){
//     console.log("Manage Account was Pressed!");
//     var dropDown = document.getElementById("manage-account-menu");
//     dropDown.style.display = "flex";
//     dropDown.style.flexDirection = "column";
// }



// function pullUpMenu(){
//     console.log("Manage Account was Pressed!");
//     var dropDown = document.getElementById("manage-account-menu");
//     dropDown.style.display = "none";
// }
