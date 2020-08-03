
//Routes are prepended with '/homepage'   type what comes after '/homepage'
const express = require("express");
let router = express.Router();




//Does whatever type of request for the root directory ("/homepage")
router.route("/")
    .get( (req, res) => {
        console.log("Loading homepage");
        res.render('/Users/gabe/Desktop/AthleteApp/views/homepage.ejs');
    });



module.exports = router;