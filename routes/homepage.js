
//Routes are prepended with '/homepage'   type what comes after '/homepage'
const express = require("express");
const bcrypt = require("bcrypt");
const session = require("express-session");
const flash = require("express-flash");
let router = express.Router();

//Connecting PostgreSQL
const { pool } = require('../lib/dbConfig.js');


//Does whatever type of request for the root directory ("/homepage")
router.route("/")
    .get( (req, res) => {
        //console.log("Loading homepage");
        res.render('/Users/gabe/Desktop/AthleteApp/views/homepage.ejs');
    });



router.route("/signup")
    //When user is signing up
    .post( async (req, res) => {
        // var firstName = req.body.user_fname;
        // var lastName = req.body.user_lname;

        //save the data from the signup form into a json object with the same field names
        let {user_fname, user_lname, user_email, password, password2} = req.body;
        // console.log({user_fname, 
        //     user_lname, 
        //     user_email, 
        //     password, 
        //     password2
        // });

        //collecting the errors that may have occurred when the form was submitted
        let errorMessages = [];

        //make sure all forms were entered
        if (!user_fname || !user_lname || !user_email || !password || !password2) {
            errorMessages.push({ message: "Please enter all fields" });
        }

        //check the password length
        if (password.length < 6 ) {
            errorMessages.push({ message: "Password should be at least 6 characters"});
        }

        //check the 1st and 2nd passwords match
        if (password != password2) {
            errorMessages.push({ message: "Passwords do not match"});
        }

        //if there were any errors in the form submission
        if (errorMessages.length > 0) {
            console.log("Reached an error");
            res.redirect("/homepage");
            //res.render('/Users/gabe/Desktop/AthleteApp/views/homepage.ejs');

        } 
        // else {

        // }

        //hash the password to make it secure
        let hashedPW = await bcrypt.hash(password, 10);

        //push the data into the database
        pool.query(
            `SELECT * FROM athlete 
            WHERE athlete_email = $1`, [user_email], (error, results) => {
                if (error) {
                    console.log("User already exists in the database");
                    throw error;
                }
                
                if(results.rows.length > 0) {
                    errorMessages.push({ message: "Email is already registered"});
                    res.redirect("/homepage");
                } else {
                    pool.query(`INSERT INTO athlete 
                                (athlete_first_name, athlete_last_name, athlete_email, athlete_password)
                                VALUES ($1, $2, $3, $4)
                                RETURNING athlete_id, athlete_password`, 
                                [user_fname, user_lname, user_email, hashedPW], (err, results) => {
                                    if (err) {
                                        console.log("invalid query");
                                        throw err;
                                    }
                                    else {
                                        console.log("Entered new user");
                                        console.log(results.rows);
                                        res.redirect("/homepage");
                                    }
                                });
                }
            }
        )

        
    });



module.exports = router;