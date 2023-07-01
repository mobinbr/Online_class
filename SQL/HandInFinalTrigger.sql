USE	[Project]

GO

CREATE	TRIGGER	Hand_In_Final
ON		Project.dbo.Hand_In_Homework
AFTER	INSERT
AS
BEGIN
	UPDATE	Hand_In_Homework
	SET		is_final = 0
	FROM	inserted
	WHERE	Hand_In_Homework.course_id = inserted.course_id
	  AND	Hand_In_Homework.activity_id = inserted.activity_id
	  AND	Hand_In_Homework.s_username = inserted.s_username
	  AND	Hand_In_Homework.[time] != inserted.[time]
END