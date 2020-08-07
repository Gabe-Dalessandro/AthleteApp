


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
DROP TABLE IF EXISTS session CASCADE;








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






-- Table: session,  able to store user data within this database for a set amount of time
CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
	"sess" json NOT NULL,
	"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);

ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE INDEX "IDX_session_expire" ON "session" ("expire");


