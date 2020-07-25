// Express to run server and routes
const express = require("express");
//const bodyParser = require('body-parser');
const homepage = require("./routes/homepage"); //this is a Router object because it is imported in the file
const dashboard = require("./routes/dashboard"); //this is a Router object because it is imported in the file
const app = express();

//Libraries/packages:
    //the server will use these packages to accomplish different tasks
//app.use(bodyParser.urlencoded({extended:false}));
//app.use(bodyParser.json()); //able to parse JSON files
app.use(express.static('views')); //folder that we want to point the server to that holds the html webpages
//app.use(express.json({ limit: '1mb'}));//make sure the server is able to use JSON files
app.set("view-engine", "ejs");
app.use(express.urlencoded({extended: false})); //allows use to send private info (ie passwords) from the front end to our database

//ROUTING: 
    //tells the server which files to use for certain routes
app.use("/homepage", homepage); //ROUTING: anything that uses the /homepage url, go to "./routes/homepage"
    //use the homepage.js file to handle endpoints that start with "/homepage"
app.use("/dashboard", dashboard);

//Connecting PostgreSQL
const { pool } = require('./lib/dbConfig.js');





//Running Server
const port = 8000;
app.listen(port, (err) => {
    if(err){
        return console.log(`ERROR Running Server: ${err}`);
    }
    else {
        console.log("\n***************** Server running on Port:" + port + " *****************"); 
    }
});


//Serving the signup page the start
app.get('/', function(req, res){
    res.redirect("/homepage");
    //res.render('homepage.ejs', { root: __dirname + "/views" } );
});



// app.get("/dashboard", (req, res) => {
//     res.render('/Users/gabe/Desktop/AthleteApp/website/dashboard.ejs', { user: "Gabe"});
// });
