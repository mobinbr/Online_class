CREATE	VIEW	Srudents_Without_Course
AS		SELECT	username, first_name, last_name, school_id
		FROM	Student
		WHERE	NOT EXISTS 
				(
				SELECT * 
				From Enrollment
				Where username = s_username
				)