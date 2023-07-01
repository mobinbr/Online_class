USE		[Project]; 

GO  
CREATE	PROCEDURE SetAttendanceWeight
		@course_id INT,
		@new_weight FLOAT
AS   
		SET		NOCOUNT ON;
		UPDATE	Activity
		SET		[weight] = @new_weight
		WHERE	[type] = 'A'
		AND		course_id = @course_id
GO  