
//Routes are prepended with '/login'
const express = require("express");
const passport = require("passport");

let router = express.Router();


//Does whatever type of request for the root directory ("/dashboard")
router.route("/")
    .get((req, res) => {
        console.log("\n****** LOADING LOGIN PAGE ******\n")
        res.render('/Users/gabe/Desktop/AthleteApp/views/login.ejs');
    });


//When a user logins to profile
router.post('/', (req, res, next) => {
    console.log("Login submit button was pressed");
    passport.authenticate('local', { 
        successRedirect: '/dashboard',
        failureRedirect: '/login',
        failureFlash: true,
        successFlash: true
    })(req, res, next);
});
    

module.exports = router;