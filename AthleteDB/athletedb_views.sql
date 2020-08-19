
-- *********************************************************************
-- ******************* FILE TO HOLD ALL VIEWS FOR DB *******************
-- *********************************************************************




CREATE OR REPLACE VIEW athletes_tracked_exercises AS
SELECT athlete.athlete_first_name,
	exercise.exercise_name,
	(CURRENT_DATE - tracked_exercises.tracking_start_date) AS total_time_tracked
FROM 
	tracked_exercises INNER JOIN exercise ON exercise.exercise_id = tracked_exercises.exercise_id
	INNER JOIN athlete ON athlete.athlete_id = tracked_exercises.athlete_id
WHERE 
	athlete.athlete_first_name = 'Gabe'
	
	
	
	
-- gets all the rewards for am athlete	
CREATE OR REPLACE VIEW athletes_earned_rewards AS
SELECT CONCAT(rewards.reward_company_name, ' Reward: ') as company_name, rewards.reward_name 
FROM 
	earned_rewards INNER JOIN rewards ON rewards.reward_id = earned_rewards.reward_id
	INNER JOIN athlete ON athlete.athlete_id = earned_rewards.athlete_id
WHERE athlete.athlete_id = 27



-- gets the workouts and the exercises in the workouts for a single user
SELECT athlete.athlete_first_name, workout.workout_id, workout.workout_name,
exercise.exercise_name, tracked_exercises.weight, tracked_exercises.sets, tracked_exercises.reps,
TO_CHAR(tracked_workouts.date_completed :: DATE, 'Mon dd, yyyy')
FROM 
	tracked_workouts 
	INNER JOIN athlete ON athlete.athlete_id = tracked_workouts.athlete_id
	INNER JOIN workout ON tracked_workouts.workout_id = workout.workout_id
	INNER JOIN workout_exercises ON workout.workout_id = workout_exercises.workout_id
	INNER JOIN exercise ON workout_exercises.exercise_id = exercise.exercise_id
	INNER JOIN tracked_exercises ON athlete.athlete_id = tracked_exercises.athlete_id
		AND exercise.exercise_id = tracked_exercises.exercise_id
WHERE 
	athlete.athlete_id = 27