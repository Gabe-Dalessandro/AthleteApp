
const express = require("express");
const bcrypt = require("bcrypt");
// const session = require("express-session");
// const flash = require("express-flash");
let router = express.Router();

//Connecting PostgreSQL
const { pool } = require('../lib/dbConfig.js');



router.route("/")
    .get(ensureAuthentication, (req, res) => {
        console.log("\n****** LOADING TRACK NEW EXERCISE PAGE ******\n")
        console.log(req.user);
        console.log(req.isAuthenticated());

        //get all of the users tracked exercises
        // var trackedExercises = await queryWorkoutStats(req.user.athlete_id);
        res.render('/Users/gabe/Desktop/AthleteApp/views/track-new-exercise.ejs', { user: req.user });
    });


router.route("/submit")
    .post(ensureAuthentication, (req, res) => {
        console.log("\t----- Submitting New Exercise -----\n")
        res.redirect("/dashboard");
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




module.exports = router;