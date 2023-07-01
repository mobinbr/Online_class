USE	[Project]

GO

CREATE	TRIGGER	Hand_In_Validation
ON		Project.dbo.Hand_In_Homework
INSTEAD	OF INSERT
AS
BEGIN
	DECLARE
		@InS VARCHAR(50),
		@InC INT
	SELECT	@InS = s_username, @InC = course_id
	FROM	inserted
	IF	EXISTS (SELECT	* FROM Enrollment 
				WHERE	s_username = @InS
				  AND	course_id = @InC)
		INSERT INTO	Hand_In_Homework
		SELECT * FROM inserted
	ELSE
		PRINT(FORMATMESSAGE('INVALID HAND-IN: Student %s does not have course %d', @InS, @InC))
END