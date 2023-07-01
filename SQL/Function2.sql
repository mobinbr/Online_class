USE		[Project]; 

GO  

CREATE	FUNCTION StudentCourses (@username VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
		SELECT C.course_id, C.title  
		FROM Enrollment E INNER JOIN Course C ON C.course_id = E.course_id
		WHERE E.s_username = @username
);

GO  