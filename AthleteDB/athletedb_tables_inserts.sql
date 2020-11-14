
-- ********************** CODE TO CREATE THE ATHLETEDB FROM SCRATCH EACH TIME **********************
   -- this code will delete every table beforehand to ensure there are no lingering tables
   -- make sure there are no table dependencies between tables when deleting
   -- then it will build the entire database
   -- if you don't specify a schema, the table is automatically created in the PUBLIC schema



-- ******** Data Model is found at: https://my.vertabelo.com/drive



-- *********** DELETING DB IN SPECIFIC ORDER (Outside - in) ***********
DROP TABLE IF EXISTS session CASCADE;
DROP TABLE IF EXISTS athlete CASCADE;

DROP TABLE IF EXISTS rewards CASCADE; 
DROP TABLE IF EXISTS earned_rewards CASCADE;

DROP TABLE IF EXISTS friendship CASCADE; 

DROP TABLE IF EXISTS team CASCADE;
DROP TABLE IF EXISTS team_members CASCADE;

DROP TABLE IF EXISTS exercise_type CASCADE;
DROP TABLE IF EXISTS exercise CASCADE;

DROP TABLE IF EXISTS workout_access CASCADE;
DROP TABLE IF EXISTS workout CASCADE;
DROP TABLE IF EXISTS workout_exercises CASCADE;
DROP TABLE IF EXISTS shared_workouts CASCADE;
DROP TABLE IF EXISTS workout_session CASCADE;
DROP TABLE IF EXISTS tracked_exercises CASCADE;


-- ========================= Session Table ========================= --
-- Table: session,  able to store user data within this database for a set amount of time
CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
	"sess" json NOT NULL,
	"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;
CREATE INDEX "IDX_session_expire" ON "session" ("expire");




-- ========================= Athlete Table ========================= --
-- Creates the athlete table
CREATE TABLE athlete (
   athlete_id SERIAL NOT NULL,
   athlete_first_name varchar(15)  NULL,
   athlete_last_name varchar(25)  NULL,
   athlete_email varchar(25)  NULL,
   athlete_password varchar(1000) NULL,
   PRIMARY KEY (athlete_id)
);

-- inserts fot athlete table
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Gabe', 'Dalessandro', 'gdalessa@usc.edu', 'fitness123'); -- 1
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Carolyn', 'Kraft', 'ckraft@gmail.com', 'fitness123'); -- 2
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Daniel', 'Paoloni', 'dpaoloni@gmail.com', 'fitness123'); -- 3
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Tom', 'Brady', 'tbrady@gmail.com', 'fitness123'); -- 4
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Klay', 'Puppy', 'kpuppy@gmail.com', 'fitness123'); -- 5
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Jason', 'Gomez', 'jgomez@gmail.com', 'fitness123'); -- 6
INSERT INTO athlete(athlete_first_name, athlete_last_name, athlete_email, athlete_password)
    VALUES('Steven', 'Barret', 'sbarret@gmail.com', 'fitness123'); -- 7


-- ========================= Rewards Table ========================= --
-- Create the rewards table
CREATE TABLE rewards
(
    reward_id SERIAL NOT NULL,
    reward_name varchar(200) NOT NULL,
    reward_company_id integer NOT NULL,
    reward_company_name varchar(100) NOT NULL,
    PRIMARY KEY (reward_id)
);

-- inserts into the rewards table
INSERT INTO rewards (reward_name, reward_company_id, reward_company_name)
	VALUES ('10% OFF NEXT ONLINE ORDER!', 1, 'Nike');
INSERT INTO rewards (reward_name, reward_company_id, reward_company_name)
	VALUES ('$20 TOWARDS NEXT FOOTWEAR PURCHASE!', 2, 'Adidas');




-- ========================= Earned_rewards Table ========================= --
-- Table: earned_rewards: stores the rewards a user has
CREATE TABLE earned_rewards
(
    earned_reward_id SERIAL NOT NULL,
    athlete_id integer NOT NULL,
    reward_id integer NOT NULL,
    PRIMARY KEY (earned_reward_id),
    FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (reward_id) 
      REFERENCES rewards(reward_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE  
);

-- inserts into the earned_rewards table
INSERT INTO earned_rewards (athlete_id, reward_id)
	VALUES (1, 1);
INSERT INTO earned_rewards (athlete_id, reward_id)
	VALUES (1, 2);




-- ========================= Friendship Table ========================= --
-- Table: friendship: creates a link between which users are friends
CREATE TABLE friendship
(
    friendship_id SERIAL NOT NULL,
    athlete_id integer NOT NULL,
    athlete_friend_id integer NOT NULL,
    friend_request_accepted boolean NOT NULL,
    accepted_date date,
    PRIMARY KEY (friendship_id),
    FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (athlete_friend_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);

-- inserts into friendship table
INSERT INTO friendship(athlete_id, athlete_friend_id, friend_request_accepted, accepted_date)
    VALUES (1, 2, TRUE, TO_DATE('04/25/2017', 'MM/DD/YYYY'));
INSERT INTO friendship(athlete_id, athlete_friend_id, friend_request_accepted, accepted_date)
    VALUES (1, 3, TRUE, TO_DATE('04/25/2017', 'MM/DD/YYYY'));
INSERT INTO friendship(athlete_id, athlete_friend_id, friend_request_accepted, accepted_date)
    VALUES (1, 4, TRUE, TO_DATE('09/23/2001', 'MM/DD/YYYY'));
INSERT INTO friendship(athlete_id, athlete_friend_id, friend_request_accepted, accepted_date)
    VALUES (1, 6, TRUE, TO_DATE('08/28/2019', 'MM/DD/YYYY'));

INSERT INTO friendship(athlete_id, athlete_friend_id, friend_request_accepted)
    VALUES (2, 5, FALSE);




-- ========================= Team Table ========================= --
-- Table: team: users can be part of many teams where every users stats are counted
CREATE TABLE team
(
    team_id SERIAL NOT NULL,
    team_name varchar(30) NOT NULL,
    date_started date,
    PRIMARY KEY (team_id)
);

-- inserts into the team table
INSERT INTO team(team_name, date_started)
    VALUES ('104 BABY!', TO_DATE('06/12/2011', 'MM/DD/YYYY'));





-- ========================= Team_Members Table ========================= --
-- Table: team_members: who belongs to what teams
CREATE TABLE team_members
(
    team_member_id SERIAL NOT NULL,
    athlete_id integer NOT NULL,
    team_id integer NOT NULL,
    member_date date,
    PRIMARY KEY (team_member_id),
    FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (team_id) 
      REFERENCES team(team_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);

-- inserts into team_members
INSERT INTO team_members(athlete_id, team_id, member_date)
    VALUES (1, 1, TO_DATE('01/25/2019', 'MM/DD/YYYY'));
INSERT INTO team_members(athlete_id, team_id, member_date)
    VALUES (6, 1, TO_DATE('01/25/2019', 'MM/DD/YYYY'));
INSERT INTO team_members(athlete_id, team_id, member_date)
    VALUES (7, 1, TO_DATE('01/25/2019', 'MM/DD/YYYY'));





-- ========================= Exercise_Type Table ========================= --
-- Table: exercise_type
CREATE TABLE exercise_type
(
    exercise_type_id SERIAL NOT NULL,
    exercise_type_name varchar(30) NOT NULL,
    PRIMARY KEY (exercise_type_id)
);

-- inserts into exercise_type
INSERT INTO exercise_type(exercise_type_name)
    VALUES('strength');
INSERT INTO exercise_type(exercise_type_name)
    VALUES('explosion');
INSERT INTO exercise_type(exercise_type_name)
    VALUES('bodyweight/calisthenics');
INSERT INTO exercise_type(exercise_type_name)
    VALUES('cardio');
INSERT INTO exercise_type(exercise_type_name)
    VALUES('flexibility');
INSERT INTO exercise_type(exercise_type_name)
    VALUES('sports');








-- ========================= Exercise Table ========================= --
-- Table: exercise
CREATE TABLE exercise
(
    exercise_id SERIAL NOT NULL,
    exercise_name varchar(50) NOT NULL,
    exercise_type_id integer NOT NULL,
    PRIMARY KEY (exercise_id),
    FOREIGN KEY (exercise_type_id) 
      REFERENCES exercise_type(exercise_type_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);

-- inserts into exercise_type
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Incline Barbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Inclide Dumbbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Decline Barbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Decline Dumbbell Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Flat Chest Press Machine' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Incline Chest Press Machine' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Decline Chest Press Machine' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dips' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Push-Ups' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Flat Dumbbell Flyes' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Incline Dumbbell Flyes' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Decline Dumbbell Flyes' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Pec Deck Machine' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Crossovers/Cable Flyes' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Pull-Ups' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Chin-Ups' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Lat Pull-Downs' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Bent Over Dumbbell Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Bent Over Barbell Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('T-Bar Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Seated Cable Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Chest Supported Barbel Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Chest Supported Dumbbells Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Chest Supported Machine Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Inverted Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Shrugs' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Shrugs' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Seated Overhead Barbell Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Seated Overhead Dumbbell Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Standing Overhead Barbell Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Standing Overhead Dumbbell Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Upright Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Upright Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Machine Upright Rows' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Lateral Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Lateral Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Machine Lateral Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Front Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Front Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Machine Front Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Overhead Machine Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Arnold Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Rear Delt Raises ' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Rear Delt Raises ' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Machine Rear Delt Raises ' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Front Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Front Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Split Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Split Squats' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Lunges' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Lunges' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Leg Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Single Leg Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Machine Squat' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Leg Extensions' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Romanian Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Romanian Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Straight Leg Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Straight Leg Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Sumo Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Sumo Deadlifts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Glute-Ham Raises' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Hyperextensions' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Pull-Throughs' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Good-Mornings' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Hip Thrusts' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Leg Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Standing Dumbbell Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Standing Barbell Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Barbell Preacher Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Preacher Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Seated Dumbbell Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Incline Dumbbell Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Hammer Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Concentration Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Curls' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Biceps Curl Machine' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Flat Close Grip Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Decline Close Grip Bench Press' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Close Grip Push-Ups' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Dumbbell Triceps Extensions' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Skull Crushers' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Overhead Dumbbell Triceps Extensions' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Cable Press-Downs' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Bench Dips' , 1);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Running' , 4);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Boxing' , 6);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Box Jumps' , 2);
INSERT INTO exercise(exercise_name, exercise_type_id) VALUES('Jump Rope' , 4);






-- ========================= Workout_Access Table ========================= --
-- Table: workout_access: determines wheter a workout is able to be shared or not
-- CREATE TABLE workout_access
-- (
--     workout_access_id SERIAL NOT NULL,
--     description varchar(50) NOT NULL,
--     PRIMARY KEY (exercise_id)
-- );

-- INSERT INTO workout_access(description) VALUES('public');
-- INSERT INTO workout_access(description) VALUES('private');



-- ========================= Workout Table ========================= --
-- Table: workout
CREATE TABLE workout
(
    workout_id SERIAL NOT NULL,
    workout_owner_id integer NOT NULL,
    workout_name varchar(50) NOT NULL,
    -- times_completed integer NOT NULL,
    -- workout_access_id integer NOT NULL,
    PRIMARY KEY (workout_id),
    FOREIGN KEY (workout_owner_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);

-- insert workouts for Gabe
INSERT INTO workout(workout_owner_id, workout_name) VALUES(1, 'Leg Day'); -- 1 
INSERT INTO workout(workout_owner_id, workout_name) VALUES(1, 'Back Day (High Reps)'); -- 2
INSERT INTO workout(workout_owner_id, workout_name) VALUES(1, 'Chest Day'); -- 3
INSERT INTO workout(workout_owner_id, workout_name) VALUES(1, 'Cardio and Jump Rope'); -- 4

-- insert workouts for Jason
INSERT INTO workout(workout_owner_id, workout_name) VALUES(6, 'Getting in shape(running)'); -- 5
INSERT INTO workout(workout_owner_id, workout_name) VALUES(6, 'Leg Day'); -- 6
INSERT INTO workout(workout_owner_id, workout_name) VALUES(6, 'Upper Body'); -- 7

-- insert workouts for Steven
INSERT INTO workout(workout_owner_id, workout_name) VALUES(7, 'Starting up again'); -- 8
INSERT INTO workout(workout_owner_id, workout_name) VALUES(7, 'Legs boutta be sore'); -- 9
INSERT INTO workout(workout_owner_id, workout_name) VALUES(7, 'Lets do some arms'); -- 10





-- ========================= Workout_Exercises Table ========================= --
-- Table: workout_exercises: holds all the exercises that are part pf a workout
CREATE TABLE workout_exercises
(
    workout_exercise_id SERIAL NOT NULL,
    workout_id integer NOT NULL,
    exercise_id integer NOT NULL,
    exercise_name varchar(50) NOT NULL,
    order_in_workout integer,
    -- times_completed integer NOT NULL,
    -- workout_access_id integer NOT NULL,
    PRIMARY KEY (workout_exercise_id),
    FOREIGN KEY (workout_id) 
      REFERENCES workout(workout_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);


--insert exercises into Gabe's workout
-- 1 (Leg Day)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name)
    VALUES(1, 49, 'Barbell Squats');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name)
    VALUES(1, 61, 'Dumbbell Romanian Deadlifts');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name)
    VALUES(1, 54, 'Dumbbell Lunges');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name)
    VALUES(1, 70, 'Dumbbell Hip Thrusts');

-- 2 (Back Day (High Reps))
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) 
    VALUES(2 , 21, 'Bent Over Barbell Rows');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) 
    VALUES(2 , 17, '17');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) 
    VALUES(2 , 29, 'Barbell Shrugs');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) 
    VALUES(2 , 46, 'Dumbbell Rear Delt Raises ');

-- 3 (Chest Day)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(3 , 3, 'Incline Barbell Bench Press');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(3 , 11, 'Push-Ups');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(3 , 2, 'Dumbbell Bench Press');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(3 , 10, 'Dips');

-- 4 (Cardio and Jump Rope)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(4 , 90, 'Running');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(4 , 93, 'Jump Rope');



--insert exercises into Jason's workouts
-- 5 (Getting in shape(running))
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(5 , 90, 'Running');

-- 6 (Leg Day)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(6 , 48, 'Dumbbell Squats');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(6 , 54, 'Dumbbell Lunges');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(6 , 93, 'Jump Rope');

-- 7 (Upper Body)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(7 , 1, 'Barbell Bench Press');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(7 , 11, 'Push-Ups');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(7 , 20, 'Bent Over Dumbbell Rows');



--insert exercises into Steven's workouts
-- 8 (Starting up again)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(8 , 90, 'Running');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(8 , 93, 'Jump Rope');

-- 9 (Legs boutta be sore)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(9 , 61, 'Dumbbell Romanian Deadlifts');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(9 , 52, 'Barbell Split Squats');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(9 , 63, 'Dumbbell Straight Leg Deadlifts');

-- 10 (Lets do some arms)
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(10 , 33, 'Standing Overhead Dumbbell Press');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(10 , 73, 'Standing Barbell Curls');
INSERT INTO workout_exercises(workout_id, exercise_id, exercise_name) VALUES(10 , 86, 'Skull Crushers');








-- ========================= Workout_Session Table ========================= --
-- Table: workout_session: holds the data for the workout you are currently about to do or have done
CREATE TABLE workout_session
(
    workout_session_id SERIAL NOT NULL,
    athlete_id integer NOT NULL,
    workout_id integer NOT NULL,
    date_completed date,
    PRIMARY KEY (workout_session_id),
    FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (workout_id) 
      REFERENCES workout(workout_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- inserts into the workout_session table
-- Gabe's (id 1) workout 1: completed workout means data_completed would not be null
    -- 3 inserts means that workout 1 was completed 3 different times
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 1, TO_DATE('10/25/2020', 'MM/DD/YYYY'));
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 1, TO_DATE('11/01/2020', 'MM/DD/YYYY'));
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 1, TO_DATE('11/09/2020', 'MM/DD/YYYY'));

-- Gabe's (id 1) workout 2:
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 2, TO_DATE('10/26/2020', 'MM/DD/YYYY'));
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 2, TO_DATE('11/02/2020', 'MM/DD/YYYY'));

-- Gabe's (id 1) workout 3:
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(1, 3, TO_DATE('10/27/2020', 'MM/DD/YYYY'));


-- Jason (id 6) workout 5
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(6, 5, TO_DATE('10/27/2020', 'MM/DD/YYYY'));
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(6, 5, TO_DATE('10/28/2020', 'MM/DD/YYYY'));

-- Jason (id 6) workout 6
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(6, 6, TO_DATE('11/01/2020', 'MM/DD/YYYY'));


-- Steven (id 7) workout 8
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(7, 8, TO_DATE('11/01/2020', 'MM/DD/YYYY'));
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(7, 8, TO_DATE('11/05/2020', 'MM/DD/YYYY'));


-- Steven (id 7) workout 9
INSERT INTO workout_session(athlete_id, workout_id, date_completed) VALUES(7, 9, TO_DATE('11/02/2020', 'MM/DD/YYYY'));








-- ========================= Tracked_Exercises Table ========================= --
-- Table: tracked_exercises: 
CREATE TABLE tracked_exercises
(
    tracked_exercise_id SERIAL NOT NULL,
    workout_session_id integer NOT NULL,
    athlete_id integer NOT NULL,
    exercise_id integer NOT NULL,
    date_completed date,
    sets integer,
    weight integer,
    reps integer,
    time_duration float,
    PRIMARY KEY (tracked_exercise_id),
    FOREIGN KEY (workout_session_id) 
      REFERENCES workout_session(workout_session_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


-- insert into tracked_exercises table
-- Gabe's (id 1) workout 1:
-- workout_session id = 1, TO_DATE('10/25/2020', 'MM/DD/YYYY')

-- workout_session id = 2, TO_DATE('11/01/2020', 'MM/DD/YYYY')

-- workout_session id = 3, TO_DATE('11/09/2020', 'MM/DD/YYYY')


-- Gabe's (id 1) workout 2:
-- workout_session id = 4
-- workout_session id = 5


-- Gabe's (id 1) workout 3:
-- workout_session id = 6


-- Jason (id 6) workout 5
-- workout_session id = 7
-- workout_session id = 8


-- Jason (id 6) workout 6
-- workout_session id = 9



-- Steven (id 7) workout 8
-- workout_session id = 10
-- workout_session id = 11



-- Steven (id 7) workout 9
-- workout_session id = 12

INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(1, 1, 49, TO_DATE('10/25/2020', 'MM/DD/YYYY'), 3, 185, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(1, 1, 61, TO_DATE('10/25/2020', 'MM/DD/YYYY'), 3, 35, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(1, 1, 54, TO_DATE('10/25/2020', 'MM/DD/YYYY'), 3, 40, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(1, 1, 70, TO_DATE('10/25/2020', 'MM/DD/YYYY'), 3, 20, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(2, 1, 49, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 4, 225, 8);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(2, 1, 61, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 4, 40, 8);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(2, 1, 54, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 4, 45, 8);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(2, 1, 70, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 4, 25, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(3, 1, 49, TO_DATE('11/09/2020', 'MM/DD/YYYY'), 3, 250, 5);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(3, 1, 61, TO_DATE('11/09/2020', 'MM/DD/YYYY'), 3, 45, 5);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(3, 1, 54, TO_DATE('11/09/2020', 'MM/DD/YYYY'), 3, 50, 5);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(3, 1, 70, TO_DATE('11/09/2020', 'MM/DD/YYYY'), 3, 30, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(4, 1, 21, TO_DATE('10/26/2020', 'MM/DD/YYYY'), 3, 115, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(4, 1, 17, TO_DATE('10/26/2020', 'MM/DD/YYYY'), 3, 0, 15);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(4, 1, 29, TO_DATE('10/26/2020', 'MM/DD/YYYY'), 3, 175, 20);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(4, 1, 46, TO_DATE('10/26/2020', 'MM/DD/YYYY'), 3, 10, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(5, 1, 21, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 155, 6);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(5, 1, 17, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 25, 8);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(5, 1, 29, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 225, 15);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(5, 1, 46, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 15, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(6, 1, 3, TO_DATE('10/27/2020', 'MM/DD/YYYY'), 3, 175, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(6, 1, 11, TO_DATE('10/27/2020', 'MM/DD/YYYY'), 3, 0, 40);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(6, 1, 2, TO_DATE('10/27/2020', 'MM/DD/YYYY'), 3, 60, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(6, 1, 10, TO_DATE('10/27/2020', 'MM/DD/YYYY'), 4, 0, 20);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(7, 6, 90, TO_DATE('10/27/2020', 'MM/DD/YYYY'), 1, 0, 4.5);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(8, 6, 90, TO_DATE('10/28/2020', 'MM/DD/YYYY'), 1, 0, 6);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(9, 6, 48, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 5, 40, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(9, 6, 54, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 5, 25, 12);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(9, 6, 93, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 5, 0, 2);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(10, 7, 90, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 1, 0, 3);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(10, 7, 93, TO_DATE('11/01/2020', 'MM/DD/YYYY'), 3, 0, 2.5);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(11, 7, 90, TO_DATE('11/05/2020', 'MM/DD/YYYY'), 1, 0, 3.2);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(11, 7, 93, TO_DATE('11/05/2020', 'MM/DD/YYYY'), 3, 0, 2);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(12, 7, 61, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 30, 15);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(12, 7, 52, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 95, 10);
INSERT INTO tracked_exercises(workout_session_id, athlete_id, exercise_id, date_completed, sets, weight, reps) VALUES(12, 7, 63, TO_DATE('11/02/2020', 'MM/DD/YYYY'), 5, 25, 15);