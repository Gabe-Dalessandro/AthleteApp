
-- *****************************************************************************
-- ******************* FILE TO HOLD ALL QUERIES VIEWS FOR DB *******************
-- *****************************************************************************


/*list of queries needed
-- 1. list of all of a users workouts
-- 2. list of all of the sessions completed for a user's workout
-- 3. list every workout session and exercise for a specific workout
-- 4. list every workout session and exercise for a specific workout and workout_session
-- 5. 
-- 6.
-- 7. 	
*/




-- 1. list of all of a users workouts
SELECT workout.workout_owner_id, athlete.athlete_first_name, workout.workout_id, workout.workout_name
FROM athlete
	INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
WHERE 
	workout.workout_owner_id = 1;



-- 1. list of all of a users workouts and the workout sessions.
SELECT workout.workout_owner_id, athlete.athlete_first_name, workout.workout_id, workout.workout_name
FROM athlete
	INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
WHERE 
	workout.workout_owner_id = 1;



-- 2. Gets a workout id when given an athlete and a workout name
SELECT athlete.athlete_first_name, 
workout.workout_id, workout.workout_name
FROM athlete
	INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
WHERE 
	workout.workout_owner_id = 1 AND
	workout.workout_name = 'Leg Day';



-- 2. (If the there are no workout sessions for a workout): Displays the exercises for that workout
SELECT workout.workout_owner_id, athlete.athlete_first_name, 
workout.workout_id, workout.workout_name, workout_exercises.exercise_name
FROM athlete
	INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
	INNER JOIN workout_exercises ON workout.workout_id = workout_exercises.workout_id
WHERE 
	workout.workout_owner_id = 1 AND
	workout_exercises.workout_id = 1;



-- 2. list of all of the sessions completed for a user's workout (most recent first)
SELECT workout.workout_owner_id, athlete.athlete_first_name, workout.workout_id, workout.workout_name,
	workout_session.workout_session_id, workout_session.date_completed
FROM athlete
	INNER JOIN workout ON workout.workout_owner_id = athlete.athlete_id
	INNER JOIN workout_session ON workout_session.athlete_id = athlete.athlete_id
		AND workout_session.workout_id = workout.workout_id
WHERE 
	workout.workout_owner_id = 1 AND
	workout.workout_id = 1
ORDER BY 
	workout_session.date_completed DESC;


	




-- 3. list every workout session and exercise for a specific workout
SELECT tracked_exercises.workout_session_id, workout.workout_name, athlete.athlete_first_name, 
	workout_session.workout_id, exercise.exercise_name, workout_session.date_completed
FROM tracked_exercises
	INNER JOIN exercise ON exercise.exercise_id = tracked_exercises.exercise_id
	INNER JOIN workout_session ON workout_session.workout_session_id = tracked_exercises.workout_session_id
	INNER JOIN workout ON workout.workout_id = workout_session.workout_id
	INNER JOIN athlete ON athlete.athlete_id = workout_session.athlete_id
WHERE 
	athlete.athlete_id = 1 AND
	workout.workout_id = 1
ORDER BY 
	workout_session.date_completed DESC;



-- 4. list of the exercises that were completed in a workout session
SELECT tracked_exercises.workout_session_id, workout.workout_name, athlete.athlete_first_name, 
	workout_session.workout_id, exercise.exercise_name, workout_session.date_completed, 
	tracked_exercises.sets, tracked_exercises.weight, tracked_exercises.reps
FROM tracked_exercises
	INNER JOIN exercise ON exercise.exercise_id = tracked_exercises.exercise_id
	INNER JOIN workout_session ON workout_session.workout_session_id = tracked_exercises.workout_session_id
	INNER JOIN workout ON workout.workout_id = workout_session.workout_id
	INNER JOIN athlete ON athlete.athlete_id = workout_session.athlete_id
WHERE 
	athlete.athlete_id = 1 AND
	workout.workout_id = 1 AND 
	workout_session.workout_session_id = 1;