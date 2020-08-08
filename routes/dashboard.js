
//Routes are prepended with '/dashboard'
const express = require("express");
let router = express.Router();

const { pool } = require('../lib/dbConfig.js');

//Does whatever type of request for the root directory ("/dashboard")
router.route("/")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n****** LOADING DASHBOARD PAGE ******\n")
        console.log(req.user);
        console.log(req.isAuthenticated());

        //get all of the users tracked exercises
        var trackedExercises = await queryWorkoutStats(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', { user: req.user,
                                                                            trackedExercises: trackedExercises});
    });
    

router.route("/my-rewards")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n****** LOADING MY-REWARDS PAGE ******\n");
        // console.log(req.user);
        // console.log(req.user.athlete_id);
        var earnedRewards = await queryAthleteRewards(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', {user: req.user,
                                                                         earnedRewards: earnedRewards});
    })


router.route("/my-stats")
    .get(ensureAuthentication, async (req, res) => {
        console.log("\n****** LOADING MY-STATS PAGE ******\n");
        // console.log(req.user);
        // console.log(req.isAuthenticated());
        // console.log(req.user.athlete_first_name);

        var trackedExercises = await queryWorkoutStats(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', {user: req.user,
            trackedExercises: trackedExercises});
    })


router.route("/logout")
    .get(ensureAuthentication, (req, res) => {
        req.logout(); //logs out of the webapp
        req.session.destroy(); //clears the cookies and session from DB
        
        //send success message
        console.log("Logging out user...");
        //req.flash("success", "You Successfully Logged Out!"); //not working right now
        res.redirect('/homepage');
    });


router.route('/dashboard/track-new-exercise')
    .post(ensureAuthentication, (req, res)=> {

    });














function ensureAuthentication(req, res, next) {
    if(req.isAuthenticated()) {
        return next();
    }
    else {
        req.flash('error', "Please login before continuing!");
        res.redirect('/login');
    }
}


//https://stackoverflow.com/questions/58254717/returning-the-result-of-a-node-postgres-query
    //helpful link to understand how to use async functions to get the query to run
async function queryWorkoutStats(athlete_id) {
    try { 
        const results = await pool.query(`SELECT athlete.athlete_first_name, exercise.exercise_name, (CURRENT_DATE - tracked_exercises.tracking_start_date) AS total_time_tracked
                    FROM tracked_exercises INNER JOIN exercise ON exercise.exercise_id = tracked_exercises.exercise_id INNER JOIN athlete ON athlete.athlete_id = tracked_exercises.athlete_id 
                    WHERE athlete.athlete_id = $1`, [athlete_id]
        );
        return results.rows;
    } catch(error) {
        return error;
    }
}


async function queryAthleteRewards(athlete_id) {
    try { 
        const results = await pool.query(`SELECT CONCAT(rewards.reward_company_name, ' Reward: ') as company_name, rewards.reward_name 
                        FROM earned_rewards 
                            INNER JOIN rewards ON rewards.reward_id = earned_rewards.reward_id
                            INNER JOIN athlete ON athlete.athlete_id = earned_rewards.athlete_id
                        WHERE athlete.athlete_id = $1`, [athlete_id]
        );
        return results.rows;
    } catch(error) {
        return error;
    }
}









module.exports = router;