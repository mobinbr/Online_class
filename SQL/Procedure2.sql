USE		Project

GO  
CREATE	PROCEDURE AttendanceTableOfCourse
		@course_id INT
AS   
		SET NOCOUNT ON;  

DROP	TABLE IF EXISTS #AttendanceTable
DROP	TABLE IF EXISTS #AttendanceActivtyIDs

DECLARE @i int = 0

DECLARE @SessionCount int
SELECT  @SessionCount = COUNT(*) 
FROM	Activity 
WHERE	course_id = @course_id AND [type] = 'A'

CREATE	TABLE #AttendanceActivtyIDs
		(
		 idx			SMALLINT	 NOT NULL	IDENTITY(1,1)	PRIMARY KEY,
		 activity_id	VARCHAR(50)
		);

INSERT	INTO #AttendanceActivtyIDs(activity_id)
SELECT	A.activity_id
FROM	Activity A
WHERE	course_id = @course_id AND [type] = 'A'
ORDER BY start_time

CREATE	TABLE #AttendanceTable
		(
		 username VARCHAR(50)
		);

WHILE	@i < @SessionCount
		BEGIN
			SET @i = @i + 1
			DECLARE @SQL1 NVARCHAR(100)
			SET @SQL1 = 'ALTER TABLE #AttendanceTable ADD session_' + CONVERT(NVARCHAR(2), @i) + ' BIT DEFAULT 0;'
			EXEC sp_executesql @SQL1
		END

INSERT	INTO #AttendanceTable(username)
SELECT	s_username
FROM	Enrollment
WHERE	course_id = @course_id

SET		@i = 0
WHILE	@i < @SessionCount
		BEGIN
			SET		@i = @i + 1
			DECLARE @AtivityId VARCHAR(50)
			SELECT  @AtivityId = A.activity_id 
			FROM	#AttendanceActivtyIDs A
			WHERE	A.idx = @i
			DECLARE @SQL2 NVARCHAR(MAX)
			SET @SQL2 = 'UPDATE	#AttendanceTable SET #AttendanceTable.session_'
			+ CONVERT(NVARCHAR(3), @i)
			+ ' = 1 FROM Hand_In_Homework WHERE	activity_id = '
			+ CONVERT(NVARCHAR(50), @AtivityId)
			+ ' AND course_id = ' 
			+ CONVERT(NVARCHAR(4), @course_id) 
			+ ' AND s_username = username'
			EXEC sp_executesql @SQL2
		END

SELECT	*
FROM	#AttendanceTable

DROP	TABLE IF EXISTS #TestTable
DROP	TABLE IF EXISTS #AttendanceActivtyIDs

GO  
