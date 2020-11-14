

//Routes are prepended with '/dashboard/my-workouts'
const express = require("express");
let router = express.Router();

const { pool } = require('../lib/dbConfig.js');


//==== LOADING THE MY-WORKOUTS PAGE ====
//Loads the workouts page 
/*
    displayes all the workouts the user has and
    will also display the selected workout
*/
router.route("/")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n\n******* LOADING MY-WORKOUTS PAGE FROM MY-WORKOUTS.JS *******");

        //get all of a user's workouts
        // console.log("\tGetting all of a user's workouts");
        let workoutList = await query_user_workouts(req.user.athlete_id)
            .then(queryResults => {
                return queryResults;
            })
            .catch(err => console.log(err))
        // console.log(workoutList);
        
        //if there is a workout within the workoutList, get the most recent workout and display it
        if(workoutList.length != 0) {
            //gets the id and name of the last completed workout
            // console.log("\tGetting all of a user's workout sessions");
            let mostRecentWorkoutSession = await query_all_workout_sessions(req.user.athlete_id);
            let selectedWorkoutID = mostRecentWorkoutSession.workout_id;
            let selectedWorkoutSessionID = mostRecentWorkoutSession.workout_session_id;
            let selectedWorkoutName = mostRecentWorkoutSession.workout_name;

            //queries the latest workout and returns an array of the exercises for it
            // console.log("\tGetting all exercises for the most recent workout session");
            var selectedWorkoutExercises = await query_workout_stats(req.user.athlete_id, selectedWorkoutID, selectedWorkoutSessionID);
            
            console.log("******* Finished loading the my-workouts page *******");
            res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard-my-workouts.ejs', {user: req.user,
                workoutList: workoutList, selectedWorkoutExercises : selectedWorkoutExercises, 
                selectedWorkoutID : selectedWorkoutID, selectedWorkoutName : selectedWorkoutName});
        } 
        //else the user has never created a workout
        else {
            console.log("******* Finished loading the my-workouts page *******");
            res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard-my-workouts.ejs', {user: req.user,
                workoutList: workoutList});
        }
    });







//==== gets the workout id ====
//returns a workout id given a workout name and athlete_id
/*
    returns the workout_id when only a wokrout name and user id is given
    used to change the add exercise in the html (to add an exercise to the right workout)
*/
router.route("/get-workoutid/:workout_name")
    .get(ensureAuthentication, async (req, res) => {

        //gets the workout_id for this workout
        let clickedWorkoutId = await pool.query(
            `SELECT workout.workout_id
            FROM workout
            WHERE 
                workout_name = $1 AND
                workout.workout_owner_id = $2`, 
                [req.params.workout_name, req.user.athlete_id]
        )
            .then((results) => {
                return results.rows[0].workout_id;
            })
            .catch(err => console.log(err));

        return res.json(clickedWorkoutId);
    })







//==== gets the workout data for a single workout ====
//returns the workout data when a workout is clicked on 
/*
    returns the following workout data when a workout is clicked on in the html
    returns: workout session if it exists, exercise data for the most recent workout session,
    and just the exercises if a session hasnt been completed yet
*/
router.route("/get-workout-data/:workout_name")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n\n======= User clicked on a workout: now retrieving data for " + req.params.workout_name + " =======");
        
        //gets the workout_id from the workout_name
        let clickedWorkoutID = await pool.query(
            `SELECT workout.workout_id
            FROM workout
            WHERE 
                workout_name = $1 AND
                workout.workout_owner_id = $2`,
                [req.params.workout_name, req.user.athlete_id]
        )
            .then((results) => {
                return results.rows[0].workout_id;
            })
            .catch(err => console.log(err));
            

        //gets the workout_id and most recent workout session ID for this workout
        let mostRecentSession = await pool.query(
            `SELECT workout_session.workout_id, workout.workout_name,
                workout_session.workout_session_id, 
                to_char(workout_session.date_completed, 'Mon-DD-YYYY') as date_completed
            FROM workout_session
                INNER JOIN workout ON workout.workout_id = workout_session.workout_id
            WHERE
                workout.workout_id = $1 AND
                workout_session.athlete_id = $2
            ORDER BY
                workout_session.date_completed DESC`, 
                [clickedWorkoutID, req.user.athlete_id]
        )
            .then((results) => {
                return results.rows;
            })
            .catch(err => console.log(err));

        //If there has been a workout session completed before: show the last sessions stats
        if(mostRecentSession.length > 0) {
            let clickedWorkoutSessionID = mostRecentSession[0].workout_session_id;
            console.log(mostRecentSession);
            //queries the clicked workout and returns an array of the exercises for it
            var clickedWorkoutExercises = await query_workout_stats(req.user.athlete_id, clickedWorkoutID, clickedWorkoutSessionID);

            console.log("======= Finished /get-workout-data/:workout_name =======");
            return res.json(clickedWorkoutExercises);
        } 
        //Else a session has not been compeleted yet: show just the exercises
        else {
            //only returns the exercies from the workout itself
            let exercises = await pool.query(
                `SELECT workout.workout_owner_id, athlete.athlete_first_name, 
                workout.workout_id, workout.workout_name, workout_exercises.exercise_name
                FROM athlete
                    INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
                    INNER JOIN workout_exercises ON workout.workout_id = workout_exercises.workout_id
                WHERE 
                    workout.workout_owner_id = $1 AND
                    workout_exercises.workout_id = $2;`,
                [req.user.athlete_id, clickedWorkoutID]
            )
                .then((results) => {
                    return results.rows;
                })
                .catch(err => console.log(err));

            console.log("======= Finished /get-workout-data/:workout_name =======");
            return res.json(exercises);
        }
    });





//==== /add-new-workout ====
//adds a new workout for a user and then displays it
/*
    will add the workout
    then display the page again with this workout at the top
*/
router.route("/add-new-workout")
    .post(ensureAuthentication, async function(req, res){
        console.log("\n\n======= Adding a new workout for user =======");
        var workoutName = req.body.workout_name;
        var athleteID = req.user.athlete_id;
        console.log("\tAdding new Workout: " + workoutName);

        // Checks to see if the workout name has already been used by the user
        var workoutNameExists = await pool.query(
            `SELECT * FROM workout WHERE workout_owner_id = $1 AND workout_name = $2`,
            [athleteID, workoutName]
        )
            .then(results => {
                // console.log(results.rows);
                if(results.rows.length > 0) {
                    return true;
                } else {
                    return false;
                }
            })
            .catch(err => console.log(err));
        
        //If the workout name already exists
        if(workoutNameExists) {
            console.log("Workout name already exists for this user!");
            var errorMessages = [];
            errorMessages.push({ message: "Workout name already exists!"});
            res.redirect("/dashboard/my-workouts"); 
            // res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard-my-workouts.ejs', { user: req.user, errorMessages });       
        }
        else {
            console.log("workout name doesn't exist: Adding workout to database");

            //insert workout into workout table
            let insertNewWorkout = await pool.query(
                `INSERT INTO workout(workout_name, workout_owner_id) VALUES($1, $2)`, 
                [workoutName, athleteID]
            )
                .then(results => results.rows)
                .catch(err => console.log(err));

            //get new workout id
            var workoutID = await pool.query(
                `SELECT workout_id FROM workout WHERE workout_name = $1 AND workout_owner_id = $2`,
                [workoutName, athleteID]
            )
                .then(results => results.rows[0])
                .catch(err => console.log(err));
            console.log("New workout_id: " + workoutID);
            res.redirect("/dashboard/my-workouts");
        }
    });











//==== Adding new exercise to a workout ====
//radds a specified exercise to a workout
/*
    will add an exercise to a workout when the user fills out the form
    it will then display all of the exercises for that workout including the new one
*/
router.route("/add-new-exercise/:workout_id")
    .post(ensureAuthentication, async (req, res) => {
        console.log("\n\n======= Adding new exercise to workout =======");
        
        var athleteID = req.user.athlete_id;
        var workoutID = req.params.workout_id;
        var exerciseName = req.body.exercise_name;
        var exerciseID = await query_get_exercise_id(exerciseName);
        console.log(`Athlete ID: ${athleteID}`);
        console.log(`Exercise ID: ${exerciseID}`);
        console.log(`Workout ID: ${workoutID}`);

        //Insert the exercise into the workout_exercises table
        let insert_results1 = await pool.query(
            `INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES($1, $2, $3)`, 
            [workoutID, exerciseID, exerciseName]
        )
            .then(results => results.rows)
            .catch(err => console.log(err));
            
        res.redirect("/dashboard/my-workouts");
    });





    
    

//==== /add-new-workout ====
//adds a new workout for a user and then displays it
/*
    will add the workout
    then display the page again with this workout at the top
*/
router.route("/add-session")
    .post(ensureAuthentication, async function(req, res){
        console.log("\n\n======= Session Completed: Adding a new session to workout =======");

    });
























//Displays workouts in the autocomplete field when adding an exercise
router.route("/search-exercises")
    .get(ensureAuthentication, async (req, res) => {
        // console.log("Obtaining exercises for auto-complete");
        var exercises = await queryGetExerciseNames();
        // console.log(exercises);
        return res.json(exercises);
    });









//This return all the exercises and stats for a specific workout_id's workout_session. These will also belong to a specificed user
async function query_workout_stats(athlete_id, selected_workout_id, selected_workout_session_id) {
    try { 
        const results = await pool.query(
            `SELECT tracked_exercises.workout_session_id, workout.workout_name, athlete.athlete_first_name, 
                workout_session.workout_id, exercise.exercise_name, workout_session.date_completed,
                tracked_exercises.sets, tracked_exercises.weight, tracked_exercises.reps
            FROM tracked_exercises
                INNER JOIN exercise ON exercise.exercise_id = tracked_exercises.exercise_id
                INNER JOIN workout_session ON workout_session.workout_session_id = tracked_exercises.workout_session_id
                INNER JOIN workout ON workout.workout_id = workout_session.workout_id
                INNER JOIN athlete ON athlete.athlete_id = workout_session.athlete_id
            WHERE 
                athlete.athlete_id = $1 AND
                workout.workout_id = $2 AND 
                workout_session.workout_session_id = $3`, 
                [athlete_id, selected_workout_id, selected_workout_session_id]
        );
        return results.rows;
    } catch(error) {
        return error;
    }
}







//Queries all of a user's workouts and returns them all
function query_user_workouts(athlete_id){
    console.log("\tQUERY: get all of a users workouts (function query_user_workouts)")
    let results = pool.query(
        `SELECT workout.workout_owner_id, athlete.athlete_first_name, workout.workout_id, workout.workout_name
        FROM athlete
            INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
        WHERE 
            workout.workout_owner_id = $1`
            , [athlete_id]
    )
        .then(results => results.rows)
        .catch(err => console.log(err))
    return results;
}


//Will return every workout session a user has completed
function query_all_workout_sessions(workout_owner_id){
    console.log("\tQUERY: get all of a users workout_sessions (query_all_workout_sessions)")
    let results = pool.query(
        `SELECT workout.workout_owner_id, athlete.athlete_first_name, workout.workout_id, workout.workout_name,
            workout_session.workout_session_id, workout_session.date_completed
        FROM athlete
            INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
            INNER JOIN workout_session ON workout_session.athlete_id = athlete.athlete_id
                AND workout_session.workout_id = workout.workout_id
        WHERE 
            workout.workout_owner_id = $1
        ORDER BY 
            workout_session.date_completed DESC`
            , [workout_owner_id]
    )
        .then(results => results.rows[0])
        .catch(err => console.log(err))
    return results;
}







//returns the exercise id given the name
async function query_get_exercise_id(exerciseName) {
    console.log("\tQUERY: gets the exercise_id based on the exercise name (query_get_exercise_id)")
    try {
        const result = await pool.query(
            `SELECT exercise_id FROM exercise WHERE exercise_name = $1`, [exerciseName]
        );
        return result.rows[0].exercise_id;
    } catch(error){
        console.log("Error in query")
        return error;
    }
}



//returns all the exercise names in the database
async function queryGetExerciseNames() {
    try {
        const results = await pool.query(
            `SELECT exercise.exercise_name FROM exercise`, []
        );
        return results.rows;
    } catch(error) {
        return error;
    }
}




//ensures the user is signed in to see certain features
function ensureAuthentication(req, res, next) {
    if(req.isAuthenticated()) {
        return next();
    }
    else {
        req.flash('error', "Please login before continuing!");
        res.redirect('/login');
    }
}




module.exports = router;