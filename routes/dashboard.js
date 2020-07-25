
//Routes are prepended with '/dashboard'
const express = require("express");
let router = express.Router();

//router.set("view engine", "ejs");

//Does whatever type of request for the root directory ("/dashboard")
router.route("/")
    .get((req, res) => {
        res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs', { user: "Gabe" });
    });
    

module.exports = router;