CREATE	VIEW	HomeWork_Result
AS		SELECT	s_username, [time], score 
		FROM	Hand_In_Homework
		WHERE	course_id = '1101' AND activity_id = '17'