
const LocalStrategy = require("passport-local").Strategy;
const { pool } = require("./dbConfig.js");
const bcrypt = require("bcrypt"); //used to unhash the password



module.exports = function(passport) {
    //Local Strategy
    passport.use(new LocalStrategy({
        usernameField: 'user_email',
        passwordField: 'user_password'  
    }, (email, password, done)=> {
        //Match the email
        pool.query(`SELECT * FROM athlete WHERE athlete_email = $1`, [email], (err, results) => {
            if(err) {
                throw err;
            }
            else {
                console.log("Beginning Login Process!");
                //if email exists
                if(results.rows.length > 0) {
                    //store the user info
                    const user = results.rows[0];

                    //decrypt the password
                    bcrypt.compare(password, user.athlete_password, (err, isMatch) => {
                        if(err) throw err;
                        
                        if (isMatch){
                            console.log("Successful Login!")
                            // return done(null, user, {message: "Successful Login!"});
                            return done(null, user); //pass the user object when using authenticate function outside of passportConfig
                        }
                        else {
                            console.log("\tERROR: Password was incorrect!");
                            return done(null, false, {message: "Password is incorrect!"});
                        }
                    });
                }
                //if email did not exist
                else {
                    console.log("\tERROR: Email does not exist!");
                    return done(null, false, {message: "Email does not exist!"});
                }
            }
        });

    }));

    //stores the athlete_id in the session cookie
    passport.serializeUser(function(user, done) {
        done(null, user.athlete_id);
    });
      
    //NOT SURE WHAT THIS DOES
    passport.deserializeUser(function(athlete_id, done) {
        pool.query(`SELECT * FROM athlete WHERE athlete_id = $1`, [athlete_id], (err, results) => {
            if(err) throw err;
            return done(null, results.rows[0]);
        });
    });

} //module.exports = function(passport)