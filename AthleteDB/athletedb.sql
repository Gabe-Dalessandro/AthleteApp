


-- ********************** CODE TO CREATE THE ATHLETEDB FROM SCRATCH EACH TIME **********************
   -- this code will delete every table beforehand to ensure there are no lingering tables
   -- make sure there are no table dependencies between tables when deleting
   -- then it will build the entire database
   -- if you don't specify a schema, the table is automatically created in the PUBLIC schema



-- ******** Data Model is found at: https://my.vertabelo.com/drive



-- *********** DELETING DB IN SPECIFIC ORDER ***********

-- Athlete Table
DROP TABLE IF EXISTS athlete CASCADE;
DROP TABLE IF EXISTS exercise_type CASCADE;
DROP TABLE IF EXISTS exercise CASCADE;
DROP TABLE IF EXISTS tracked_exercises CASCADE;
DROP TABLE IF EXISTS rewards CASCADE;
DROP TABLE IF EXISTS earned_rewards;
DROP TABLE IF EXISTS session CASCADE;

DROP TABLE public.workout;
DROP TABLE public.workout_exercises;







-- Table: athlete
CREATE TABLE athlete (
   athlete_id SERIAL NOT NULL,
   athlete_first_name varchar(15)  NULL,
   athlete_last_name varchar(25)  NULL,
   athlete_email varchar(25)  NULL,
   athlete_password varchar(1000) NULL,
   CONSTRAINT athlete_pk PRIMARY KEY (athlete_id)
);

-- TABLESPACE pg_default;

-- ALTER TABLE athlete.athlete
--     OWNER to postgres;






-- Table: exercise_type
CREATE TABLE exercise_type (
   exercise_type_id int  NOT NULL,
   exercise_type_name varchar(30)  NULL,
   CONSTRAINT exercise_type_pk PRIMARY KEY (exercise_type_id)
);



-- Table: exercise
CREATE TABLE exercise (
   exercise_id int  NOT NULL,
   exercise_name varchar(30) NOT NULL,
   exercise_type_id int  NOT NULL,
   CONSTRAINT exercise_pk PRIMARY KEY (exercise_id),
   FOREIGN KEY (exercise_type_id) 
      REFERENCES exercise_type(exercise_type_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);



-- Table: tracked_exercises
CREATE TABLE tracked_exercises (
   tracked_exercises_id int NOT NULL,
   athlete_id int  NOT NULL,
   exercise_id int  NOT NULL,
   tracking_start_date date  NOT NULL,
   tracked_date date NOT NULL,
   sets int NOT NULL,
   reps int NOT NULL,
   --total_time_tracked int GENERATED ALWAYS AS (CURRENT_DATE - tracking_date_start) STORED NULL,
   CONSTRAINT tracked_exercises_pk PRIMARY KEY (athlete_id,exercise_id),
   FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);




-- Table: tracked_exercises
CREATE TABLE public.tracked_exercises
(
   tracked_exercise_id serial NOT NULL,
   athlete_id integer NOT NULL,
   exercise_id integer NOT NULL,
   date_completed date,
   weight integer,
   sets integer,
   reps integer,
   time_duration integer,
   PRIMARY KEY (tracked_exercise_id),
   FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

ALTER TABLE public.tracked_exercises
    OWNER to postgres;



INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 12, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 35, 3, 20);

INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 13, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 25, 4, 16);

INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 14, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 0, 3, 20);

INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 15, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 0, 3, 8);

INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 16, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 0, 1, 5);

INSERT INTO tracked_exercises(athlete_id, exercise_id, date_completed, weight, sets, reps) 
VALUES (27, 17, TO_DATE('17/07/2020', 'DD/MM/YYYY'), 225, 3, 8);




-- Table: rewards
CREATE TABLE public.rewards
(
    reward_id integer NOT NULL,
    reward_name varchar(200) NOT NULL,
    reward_company_id integer NOT NULL,
    reward_company_name varchar(100) NOT NULL,
    PRIMARY KEY (reward_id)
);

ALTER TABLE public.rewards
    OWNER to postgres;



INSERT INTO rewards (reward_id, reward_name, reward_company_id, reward_company_name)
	VALUES (1, '10% OFF NEXT ONLINE ORDER!', 1, 'Nike');

INSERT INTO rewards (reward_id, reward_name, reward_company_id, reward_company_name)
	VALUES (2, '$20 TOWARDS NEXT FOOTWEAR PURCHASE!', 2, 'Adidas');






-- Table: earned_rewards
CREATE TABLE public.earned_rewards
(
    earned_reward_id integer NOT NULL,
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

ALTER TABLE public.earned_rewards
    OWNER to postgres;


INSERT INTO earned_rewards (earned_reward_id, athlete_id, reward_id)
	VALUES (1, 27, 1);
	
INSERT INTO earned_rewards (earned_reward_id, athlete_id, reward_id)
	VALUES (2, 27, 2);







-- Table: workout
CREATE TABLE public.workout
(
   workout_id serial NOT NULL,
   workout_name character varying(50) NOT NULL,
   times_completed int,
   PRIMARY KEY (workout_id)
);

ALTER TABLE public.workout
    OWNER to postgres;


INSERT INTO workout(workout_name) VALUES ('Typical Leg Day')






-- Table: workout_exercises
CREATE TABLE public.workout_exercises
(
   workout_exercises_id serial NOT NULL,
   workout_id integer NOT NULL,
   exercise_id integer NOT NULL,
   order_in_workout integer,
   PRIMARY KEY (workout_exercises_id),
   FOREIGN KEY (workout_id) 
      REFERENCES workout(workout_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) 
      REFERENCES exercise(exercise_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE  
);

ALTER TABLE public.workout_exercises
    OWNER to postgres;



INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 12);
INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 13);
INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 14);
INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 15);
INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 16);
INSERT INTO workout_exercises(workout_id, exercise_id) VALUES (1, 17);





-- Table: tracked_workouts
CREATE TABLE public.tracked_workouts
(
   tracked_workouts_id serial NOT NULL,
   athlete_id integer NOT NULL,
   workout_id integer NOT NULL,
   date_completed date NOT NULL,
   PRIMARY KEY (tracked_workouts_id),
   FOREIGN KEY (workout_id) 
      REFERENCES workout(workout_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
   FOREIGN KEY (athlete_id) 
      REFERENCES athlete(athlete_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE 
);

ALTER TABLE public.tracked_workouts
    OWNER to postgres;


INSERT INTO tracked_workouts(athlete_id, workout_id, date_completed) VALUES(27, 1, TO_DATE('17/07/2020', 'DD/MM/YYYY'));










-- Table: session,  able to store user data within this database for a set amount of time
CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
	"sess" json NOT NULL,
	"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);

ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE INDEX "IDX_session_expire" ON "session" ("expire");





