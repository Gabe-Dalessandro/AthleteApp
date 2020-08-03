
//These two are the same
//const Client = require('pg').Client
// const {Client} = require('pg')
// const client = new Client({
//     user: "gabe",
//     password: "Ilove3ski1123",
//     host: "localhost",
//     port: 5432,
//     database: "athletedb_dev"
// })


// client.connect()
// .then(() => console.log("\t*********** Connected to AthleteDB! ***********"))
//     .then(() => client.query("INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email) VALUES ($1, $2, $3)", ['Test', 'Last', 'test@gmail.com']))
//         .then(() => client.query("SELECT * FROM athlete WHERE athlete_first_name = $1", ["Test"]))
//             .then((results) => console.table(results.rows))
// .catch((e) => console.log(`ERROR Connecting: ${e}`))
// .finally(() => client.end())



//CLI COMMANDS HANDLING PORTS
//CLI cmd to hear what is on ports = sudo lsof -i :5432
//CLI cmd that kills the processes running on those ports = kill -QUIT 969





//ASYNC FUNCTION METHOD
    //used to test the connection to our database
    //connects to it and then runs test queries
async function connectToPSQL(){
    const {Client, Pool} = require('pg')
    
    const client = new Client({
        user: "gabe",
        password: "Ilove3ski1123",
        host: "localhost",
        port: 5432,
        database: "athletedb_dev"
    })

    const pool = new Pool({
        user: "gabe",
        password: "Ilove3ski1123",
        host: "localhost",
        port: 5432,
        database: "athletedb_dev"
    })
    
    
    try {
        await client.connect() //await says: not allowed to move on until the client connects
        console.log("\t*********** Connected to AthleteDB! ***********")
        const results = await client.query("SELECT * FROM athlete WHERE athlete_first_name = $1", ["Test"])
        console.table(results.rows)
        
    }
    catch(e) {
        console.log(`ERROR Connecting: ${e}`)
    }
    finally{ //always calls finally no matter what
        //await client.end()
        //console.log("\nDatabase Disconnected Susscessfully!\n\n")
    }
}


require("dotenv").config(); //gets the variables set in the .env file
//POOL : used to make much faster connections to the database
const {Pool} = require('pg')
const pool = new Pool({
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: "athletedb_dev",
})

module.exports = {
    connectToDB: connectToPSQL,
    pool: pool,
};