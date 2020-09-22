

//Routes are prepended with '/dashboard/my-workouts'
const express = require("express");
let router = express.Router();

const { pool } = require('../lib/dbConfig.js');


router.route("/")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n****** LOADING MY-WORKOUTS PAGE FROM MY-WORKOUTS.JS ******\n");

        var trackedWorkouts = await queryWorkoutStats(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard-my-workouts.ejs', {user: req.user,
            trackedWorkouts: trackedWorkouts});
    });






// async function queryGetExerciseId(exerciseName) {
//     try {
//         const result = await pool.query(
//             `SELECT exercise_id FROM exercise WHERE exercise_name = $1`, [exerciseName]
//         );
//         return result.rows[0].exercise_id;
//     } catch(error){
//         console.log("Error in query")
//         return error;
//     }
// }


    //else the workout name doesn't exist yet, insert it into the table
    // else {
    //     //Insert new workout into workout table
    //     var insertWorkout = async function() {
    //         await pool.query(
    //             `INSERT INTO workout(workout_name, athlete_id) VALUES($1, $2)`, [workoutName, athleteID]
    //         )
    //     };
    //     insertWorkout;


    //     //Get new workout id
    //     var workoutID =
    //         pool.query(
    //             `SELECT workout_id FROM workout WHERE workout_name = $1 AND athlete_id = $2`, [workoutName, athleteID],
    //             async (results, error) => {
    //                 console.log(`Results from workout table: ${results}`);
    //                 // return results.rows[0];
    //             }
    //         );

    //     console.log(workoutID);
    //     return workoutID;
    // } //else




//Creates a new workout for the user
router.route("/add-new-workout")
    .post(ensureAuthentication, async function(req, res){
        var workoutName = req.body.workout_name;
        var athleteID = req.user.athlete_id;
        console.log("Adding new Workout: " + workoutName);


        const results = await pool.query(
                    `SELECT * FROM workout WHERE athlete_id = $1 AND workout_name = $2`,
                    [athleteID, workoutName],
                    async (error, results) => {
                        //If the workout name already exists
                        if(results.rows == undefined) {
                            console.log("Workout name already exists for this user");
                            var errorMessages = [];
                            errorMessages.push({ message: "Workout name already exists!"});
                            res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard-my-workouts.ejs', { user: req.user, errorMessages });
                        }
                        else {
                            console.log("workout name doesn't exist");

                            //insert workout into workout table
                            pool.query(
                                `INSERT INTO workout(workout_name, athlete_id) VALUES($1, $2)`, [workoutName, athleteID]
                            );

                            //get workout id
                            var workoutID = await queryGetWorkoutID(workoutName, athleteID);

                            console.log(workoutID);

                        } //else
                    } //(results, error)
                ); //end of query `SELECT * FROM workout WHERE athlete_id = $1 AND workout_name = $2`

 
        // console.log(workoutID);

    });
    



//Adds a new exercise to the workout for the user
router.route("/add-new-exercise/:id")
    .post(ensureAuthentication, async (req, res) => {
        console.log("Adding new exercise to workout");
        
        var athleteID = req.user.athlete_id;
        var workoutID = req.params.id;
        var exerciseID = await queryGetExerciseId(req.body.exercise_name);
        console.log(`Exercise ID: ${exerciseID}`);
        console.log(`Workout ID: ${req.params.id}`);

        //Insert the exercise into the workout
        pool.query(
            `INSERT INTO workout_exercises(workout_id, exercise_id) VALUES($1, $2)`, 
            [workoutID, exerciseID], 
            (results, error) => {
                // if(error){
                //     console.log("Error when adding new exercise to workout!");
                //     console.log(error);
                // }
            }
        );

        //insert the exercise into tracked exercises if its not already there
        // pool.query(
        //     `SELECT athlete.athlete_id, tracked_exercises.exercise_id, exercise.exercise_name
        //     FROM 
        //         tracked_exercises
        //         INNER JOIN athlete ON athlete.athlete_id = tracked_exercises.athlete_id
        //         INNER JOIN exercise ON tracked_exercises.exercise_id = exercise.exercise_id
        //     WHERE 
        //         athlete.athlete_id = $1 AND exercise.exercise_id = $2`), [req.user.athlete_id, exerciseID],
        //         (results, error) =>{
        //             if(error){
        //                 console.loglog("Error in query: looking to see if exercise is already tracked");
        //                 console.log(error);
        //             }
        //             else if (results.rows.length < 1) {
        //                 pool.query(
                            
        //                 )
        //             }
        //         };

        pool.query(
            `INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
            VALUES ($1, $2, CURRENT_DATE, 0, 0, 0);`, [athleteID, exerciseID]
        );



        var trackedWorkouts = await queryCurrentWorkout(athleteID, workoutID);
        console.log(trackedWorkouts);
        res.redirect("/dashboard/my-workouts");
        
        // res.render('/dashboard/my-workouts', {user: req.user,
        //     trackedWorkouts: trackedWorkouts});
    });



router.route("/search-exercises")
    .get(ensureAuthentication, async (req, res) => {
        console.log("Searching through exercises");

        var exercises = await queryGetExerciseNames();
        // console.log(exercises);
        return res.json(exercises);
    });








//Returns the current workout that the user is doing
async function queryCurrentWorkout(athleteID, workoutID){
    try {
        var results = await pool.query(
            `SELECT athlete.athlete_first_name, workout.workout_id, workout.workout_name,
            exercise.exercise_name, tracked_exercises.weight, tracked_exercises.sets, tracked_exercises.reps,
            TO_CHAR(tracked_workouts.date_completed :: DATE, 'Mon dd, yyyy')
            FROM 
                tracked_workouts 
                INNER JOIN athlete ON athlete.athlete_id = tracked_workouts.athlete_id
                INNER JOIN workout ON tracked_workouts.workout_id = workout.workout_id
                INNER JOIN workout_exercises ON workout.workout_id = workout_exercises.workout_id
                INNER JOIN exercise ON workout_exercises.exercise_id = exercise.exercise_id
                INNER JOIN tracked_exercises ON athlete.athlete_id = tracked_exercises.athlete_id
                    AND exercise.exercise_id = tracked_exercises.exercise_id
            WHERE 
                athlete.athlete_id = $1 AND workout.workout_id = $2`, [athleteID, workoutID] 
                // (results, error) => {
                //     return results;
                // }
        );
        return results.rows;
    } catch (error) {

    }
}



async function queryGetWorkoutID(workoutName, athleteID){
    try {
        const results = await pool.query(
            `SELECT workout_id FROM workout WHERE workout_name = $1 AND athlete_id = $2`, [workoutName, athleteID]
        );
        return results.rows[0];
    } catch(err) {
        console.log("Error in query")
        return error;
    }

}


async function queryGetExerciseId(exerciseName) {
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


async function queryWorkoutStats(athlete_id) {
    try { 
        const results = await pool.query(
        `SELECT athlete.athlete_first_name, workout.workout_id, workout.workout_name,
        exercise.exercise_name, tracked_exercises.weight, tracked_exercises.sets, tracked_exercises.reps,
        TO_CHAR(tracked_workouts.date_completed :: DATE, 'Mon dd, yyyy') as date_completed
        FROM 
            tracked_workouts 
            INNER JOIN athlete ON athlete.athlete_id = tracked_workouts.athlete_id
            INNER JOIN workout ON tracked_workouts.workout_id = workout.workout_id
            INNER JOIN workout_exercises ON workout.workout_id = workout_exercises.workout_id
            INNER JOIN exercise ON workout_exercises.exercise_id = exercise.exercise_id
            INNER JOIN tracked_exercises ON athlete.athlete_id = tracked_exercises.athlete_id
                AND exercise.exercise_id = tracked_exercises.exercise_id
        WHERE 
            athlete.athlete_id = $1`, [athlete_id]
        );
        return results.rows;
    } catch(error) {
        return error;
    }
}





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