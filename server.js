// 
//     The Athlete App     //
//

//***** DECLARE EXPRESS WEB APP *****
const express = require("express");
const path = require("path");
const flash = require("connect-flash"); //allows us to send messages between webpages
const session = require("express-session"); //allows us to send messages between webpages
const passport = require("passport");
const bodyParser = require('body-parser');
var pgSession = require('connect-pg-simple')(session);

const app = express();


//***** USING .ejs FILES *****
app.set('view-engine', 'ejs'); //Allows us to use .ejs files
app.set('views', path.join(__dirname, 'views')); //Reads webpages
app.use(express.static(__dirname + '/views'));

//***** CONNECTING TO PSQL DB *****
const { pool } = require('./lib/dbConfig.js');

//***** MIDDLEWARE *****
    //the server will use this middleware to accomplish different tasks
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.urlencoded({extended: false})); //allows use to send private info (ie passwords) from the front end to our database
app.use(flash());
app.use(session({ //stores user data even after they logout
    store: new pgSession({
        pool : pool,         
        tableName : 'session'   
      }),
    secret: 'keyboard cat',
    resave: true,
    saveUninitialized: true,
    cookie: { maxAge: 30 * 24 * 60 * 60 * 1000 } // 30 days
}));
app.use(require('connect-flash')());
app.use(function (req, res, next) {
  res.locals.messages = require('express-messages')(req, res); //sets a global variable called messages
  next();
});
    // Passport Config
require('./lib/passportConfig.js')(passport);
app.use(passport.initialize());
app.use(passport.session());



//***** ROUTING: ***** 
    //tells the server which files to use for certain routes
const homepage = require("./routes/homepage"); 
const register = require("./routes/register");
const login = require("./routes/login");
const dashboard = require("./routes/dashboard"); 
const track_new_exercise = require("./routes/track-new-exercise");
const my_workouts = require("./routes/my-workouts");
app.use("/homepage", homepage); //ROUTING: anything that uses the /homepage url, go to "./routes/homepage"
app.use("/dashboard/my-workouts", my_workouts);
app.use("/dashboard", dashboard);
app.use("/register", register);
app.use("/login", login);
app.use("/track-new-exercise", track_new_exercise);





//***** RUNNING SERVER *****
const port = 8000;
app.listen(port, (err) => {
    if(err){
        return console.log(`ERROR Running Server: ${err}`);
    }
    else {
        console.log("\n***************** Server running on Port:" + port + " *****************"); 
    }
});



//Set a global variable "user" that gets the user who is logged in
app.get('*', (req, res, next) => {
    res.locals.user = req.user || null;
    next();
});


// app.get('/dashboard', (req, res)=> {
//     res.render('/Users/gabe/Desktop/AthleteApp/views/dashboard.ejs');
// });


//Serving the Homepage at the start
app.get('/', function(req, res){
    res.redirect("/homepage");
});

