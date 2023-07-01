USE [Project]

-- مشاهده لیست شرکت کنندگان یک درس

SELECT	E.s_username AS student_id, (S.first_name + ' ' + S.last_name) AS [name]
FROM	Enrollment E
JOIN	Student S ON E.s_username = S.username
WHERE	E.course_id = 1101;


-- مشاهده لیست دروس یک دانشجو در یک ترم خاص

SELECT	C.title
FROM	Enrollment E
JOIN	Course C ON E.course_id = C.course_id
WHERE	E.s_username = 'Aaron75910'
AND		C.semester = 4012;


-- مشاهده لیست کلاس های پیش روی یک استاد

SELECT	C.course_id, C.title, TS.start_time AS [start time], TS.weekday
FROM	Course C
JOIN	Professor P ON C.p_username = P.username
JOIN	Course_Time CT ON CT.course_id = C.course_id
JOIN	Time_Span TS ON TS.ts_id = CT.ts_id
WHERE	P.username = 'Helen69295'
AND		TS.week_idx > DATEPART(weekday, GETDATE())
AND		TS.start_time < CONVERT(TIME, GETDATE());


-- تعداد دانشجو های هر درس

SELECT	course_id, COUNT(s_username) AS cnt
FROM	Enrollment
GROUP	BY course_id;


-- کل منابع یک درس

SELECT	R.resource_id, R.title, R.[type], R.file_URL
FROM	Resources R
WHERE	R.course_id = 1101;


-- لیست درس ها به همراه استاد مربوطه

SELECT	C.course_id , C.title AS Title, (P.first_name + ' ' + P.last_name) AS Professor
FROM	Course C
LEFT	JOIN Professor P ON C.p_username = P.username;


-- میانگین نمره دانشجو ها در هر درس

DROP	TABLE IF EXISTS #StudentsGrades

SELECT	s_username AS username, A.course_id AS course_id, SUM(score * [weight])/SUM([weight]) AS grade
INTO	#StudentsGrades
FROM	Activity A
JOIN	Hand_In_Homework H ON A.activity_id = H.activity_id
AND		A.course_id = H.course_id
GROUP	BY s_username, A.course_id;

SELECT	course_id AS Course, AVG(grade) AS Average_Grade
FROM	#StudentsGrades
GROUP	BY course_id;

DROP	TABLE #StudentsGrades


-- تی ای های یک درس مشخص

SELECT	s_username AS student
FROM	Course_TA
WHERE	course_id = 1101;


-- وضعیت حضور و غیاب دانشجویان

SELECT	H.s_username AS Student, A.course_id, A.activity_id, A.title, A.start_time, H.time
FROM	Activity A
JOIN	Hand_In_Homework H ON A.activity_id = H.activity_id
		AND A.course_id = H.course_id
WHERE	A.[type] = 'A'
ORDER	BY A.course_id, A.activity_id, H.s_username;


-- تمرین های ارسالی دانشجویان

SELECT	*
FROM	Hand_In_Homework
ORDER	BY course_id, s_username, activity_id;


-- نمرات دانشجویان برای فعالیت های یک درس

SELECT	s_username, activity_id, score
FROM	Hand_In_Homework
WHERE	course_id = 1101
ORDER	BY s_username;


-- نمره دانشجویان برای کل یک درس 

SELECT	s_username, SUM(score * [weight]) / SUM([weight]) AS Total
FROM	Activity AS A
		INNER JOIN
		Hand_In_Homework AS H
		ON A.activity_id = H.activity_id
		AND	A.course_id = H.course_id
WHERE	A.course_id = 1101
		AND is_final = 1
GROUP	BY s_username;


-- مشاهده لیست تمارین و فعالیت های انجام نشده به ترتیب ددلاین برای یک دانشجوی مشخص

DROP	TABLE IF EXISTS #done
DROP	TABLE IF EXISTS #assigned

SELECT	H.course_id, H.activity_id 
INTO	#done
FROM	Hand_In_Homework AS H
WHERE	s_username = 'Sylvia12029';

SELECT	A.course_id, A.activity_id, A.deadline, C.title AS course_name, A.title AS activity_name
INTO	#assigned
FROM	Enrollment AS E
		INNER JOIN
		Course AS C
		ON E.course_id = C.course_id
		INNER JOIN Activity AS A
		ON C.course_id = A.course_id
WHERE	E.s_username = 'Sylvia12029'
		AND deadline > GETDATE()

SELECT	course_name, course_id, activity_name, activity_id, deadline
FROM	#assigned
WHERE	CONCAT(course_id, '-', activity_id) NOT IN	(SELECT CONCAT(course_id, '-', activity_id) FROM #done)
ORDER	BY deadline

DROP	TABLE #assigned
DROP	TABLE #done


-- استاد های یک دانشجو

SELECT	P.*
FROM	Enrollment E
JOIN	Course C ON E.course_id = C.course_id
JOIN	Professor P ON C.p_username = P.username
WHERE	E.s_username = 'Christopher95268';


-- بهترین ادمین ها

SELECT	A.username, A.first_name, A.last_name, A.gender, A.email, A.about, A.rating, A.review_count
FROM	[Admin] AS A
ORDER	BY A.rating


-- درس های یک دانشجو در یک دانشکده خاص

SELECT	E.s_username, E.course_id, C.title, C.URL, C.semester, C.p_username
FROM	Enrollment E
JOIN	Course C ON E.course_id = C.course_id
WHERE	E.s_username = 'Michelle16364'
		AND C.school_id = 1001;


-- دانشجوهای یک استاد خاص

SELECT	E.s_username AS student
FROM	Professor P
JOIN	Course C ON P.username = C.p_username
JOIN	Enrollment E ON E.course_id = C.course_id
WHERE	P.username = 'Helen69295';


-- کلاس های یک استاد مشخص

SELECT	C.course_id, C.title
FROM	Course C
WHERE	C.p_username = 'Allison11136';


-- تعداد غیبت های های یک دانشجو برای یک درس خاص

DROP TABLE IF EXISTS #allA
DROP TABLE IF EXISTS #doneA

SELECT DISTINCT activity_id
INTO #allA
FROM Activity
WHERE course_id = 1
AND [type] = 'A'

SELECT DISTINCT A.activity_id
INTO #doneA
FROM Hand_In_Homework H
INNER JOIN
Activity A
ON H.activity_id = A.activity_id
WHERE A.course_id = 1
AND A.type = 'A'

SELECT COUNT(*) AS absence
FROM #allA
WHERE activity_id NOT IN (SELECT activity_id FROM #doneA)

DROP TABLE #allA
DROP TABLE #doneA

-- کلاس های مشترک دو دانشجو

DROP TABLE IF EXISTS #clsA
DROP TABLE IF EXISTS #clsAB
USE [Project]
SELECT course_id
INTO #clsA
FROM Enrollment
WHERE s_username = 'Aaron75910'

SELECT course_id
INTO #clsAB
FROM Enrollment
WHERE s_username = 'Dirk88134'
AND course_id IN (SELECT * FROM #clsA)

SELECT C.course_id, C.title
FROM #clsAB together
INNER JOIN
Course C
ON together.course_id = C.course_id

DROP TABLE #clsA
DROP TABLE #clsAB