use Project

GO
CREATE	FUNCTION StudentGradeInCourse (@username VARCHAR(50), @course_id INT)
RETURNS TABLE
AS
RETURN
(
		SELECT	(SUM(score * [weight]) / SUM([weight])) AS RESULT
		FROM	(
					SELECT	*
					FROM	Hand_In_Homework
					WHERE	s_username = @username
					AND		course_id = @course_id
					AND		is_final = 1
				) H
				INNER JOIN 
				Activity A
				ON H.course_id = A.course_id
				AND H.activity_id = A.activity_id
);
GO
