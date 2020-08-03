


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
   athlete_id int  NOT NULL,
   exercise_id int  NOT NULL,
   tracking_start_date date  NOT NULL,
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
















