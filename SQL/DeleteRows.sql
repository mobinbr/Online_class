USE [Project]

-- حذف یک درس دانشجو

DELETE
FROM	Enrollment
WHERE	s_username = 'Riley11575' 
AND		course_id = '1102';
 
-- حذف ادمین با عملکرد نامناسب

DELETE 
FROM	[Admin]
WHERE	rating < 2
AND		review_count > 10;