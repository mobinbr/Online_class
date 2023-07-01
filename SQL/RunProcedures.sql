USE		[Project]

GO  
EXEC	dbo.SetAttendanceWeight @course_id = '1101', @new_weight = '2';
GO

GO  
EXEC	dbo.AttendanceTableOfCourse @course_id = '1101';
GO