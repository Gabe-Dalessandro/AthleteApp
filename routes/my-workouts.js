

//Routes are prepended with '/dashboard/my-workouts'
const express = require("express");
let router = express.Router();

const { pool } = require('../lib/dbConfig.js');


router.route("/")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n****** LOADING MY-WORKOUTS PAGE FROM MY-WORKOUTS.JS ******\n");
        // console.log(req.user);
        // console.log(req.isAuthenticated());
        // console.log(req.user.athlete_first_name);

        var trackedWorkouts = await queryWorkoutStats(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', {user: req.user,
            trackedWorkouts: trackedWorkouts});
    });

router.route("/add-new-exercise")
    .get(ensureAuthentication, (req, res) => {
        console.log("Adding new exercise to workout");
    });


router.route("/search-exercises")
    .get(ensureAuthentication, async (req, res) => {
        console.log("Searching through exercises");

        var exercises = await queryGetExerciseNames();
        console.log(exercises);
        return res.json(exercises);
    });







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