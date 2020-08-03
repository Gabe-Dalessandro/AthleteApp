
//Routes are prepended with '/dashboard'
const express = require("express");
let router = express.Router();

//router.set("view engine", "ejs");

//Does whatever type of request for the root directory ("/dashboard")
router.route("/")
    .get((req, res) => {
        console.log("\n****** LOADING DASHBOARD PAGE ******\n")
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', { user: req.user.athlete_first_name });
    });
    

module.exports = router;