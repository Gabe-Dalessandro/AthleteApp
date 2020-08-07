
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