
//Routes are prepended with '/homepage'   type what comes after '/homepage'
const express = require("express");
const passport = require("passport");
let router = express.Router();




//Does whatever type of request for the root directory ("/homepage")
router.route("/")
    .get( (req, res) => {
        console.log("\n****** LOADING HOMEPAGE ******\n");
        res.render('/Users/gabe/Desktop/AthleteApp/views/homepage.ejs');
    });



module.exports = router;