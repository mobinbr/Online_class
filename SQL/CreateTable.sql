USE [Project]

DROP	TABLE IF EXISTS Hand_In_Homework_URL;
DROP	TABLE IF EXISTS Activity_URL;
DROP	TABLE IF EXISTS Hand_In_Homework;
DROP	TABLE IF EXISTS Activity;
DROP	TABLE IF EXISTS Resources;
DROP	TABLE IF EXISTS Course_TA;
DROP	TABLE IF EXISTS Enrollment;
DROP	TABLE IF EXISTS Course_Time;
DROP	TABLE IF EXISTS Course;
DROP	TABLE IF EXISTS Professor_Degrees;
DROP	TABLE IF EXISTS Professor_Work_Hours;
DROP	TABLE IF EXISTS Time_Span;
DROP	TABLE IF EXISTS Professor;
DROP	TABLE IF EXISTS [Admin];
DROP	TABLE IF EXISTS Student;
DROP	TABLE IF EXISTS School;


-- School

CREATE TABLE School
	   (
		school_id	SMALLINT	  NOT NULL	PRIMARY KEY,
	    [name]		NVARCHAR(50)  NOT NULL
       );


-- Student

CREATE TABLE Student
	   (
		username	  VARCHAR(50)	NOT NULL	PRIMARY KEY,
	    first_name	  NVARCHAR(50),
		last_name	  NVARCHAR(50),
		gender		  BIT,
		email		  VARCHAR(400),
		[password]	  VARCHAR(50)	NOT NULL,
		about		  NVARCHAR(256),
		major		  NVARCHAR(50)	NOT NULL,
		degree		  NVARCHAR(20),
		grade		  FLOAT,
		entry_year	  SMALLINT,
		school_id	  SMALLINT,
		FOREIGN KEY(school_id) REFERENCES School(school_id)
				ON DELETE NO ACTION		ON UPDATE NO ACTION
	   );


-- Admin

CREATE TABLE [Admin]
	   (
		username	  VARCHAR(50)	NOT NULL	PRIMARY KEY,
	    first_name	  NVARCHAR(50),
		last_name	  NVARCHAR(50),
		gender		  BIT,
		email		  VARCHAR(400),
		[password]	  VARCHAR(50)	NOT NULL,
		about		  NVARCHAR(256),
		rating		  FLOAT CHECK(rating BETWEEN 0 AND 10) DEFAULT 0,
		review_count  INT			DEFAULT 0
	   );


--Professor

CREATE TABLE Professor
	   (
	    username	VARCHAR(50)		NOT NULL	PRIMARY KEY,
	    first_name	NVARCHAR(50),
	    last_name	NVARCHAR(50),
	    gender		BIT,
	    email		VARCHAR(400),
	    [password]	VARCHAR(50)		NOT NULL,
	    about		NVARCHAR(256),
	    school_id	SMALLINT,
	    FOREIGN KEY(school_id) REFERENCES School(school_id)
				ON DELETE SET NULL		ON UPDATE SET NULL
	   );


-- Time_Span

CREATE TABLE Time_Span
	   (
		ts_id		SMALLINT	 NOT NULL	IDENTITY(1,1)	PRIMARY KEY,
		[weekday]	NVARCHAR(20),
		week_idx	SMALLINT,
		start_time	TIME,
		end_time	TIME
	   );


-- Professor_Work_Hours

CREATE TABLE Professor_Work_Hours
	   (
		p_username	VARCHAR(50)	 NOT NULL,
		ts_id		SMALLINT	 NOT NULL,
		PRIMARY KEY(p_username, ts_id),
		FOREIGN KEY(p_username) REFERENCES Professor(username)
				ON DELETE CASCADE	  ON UPDATE CASCADE,
		FOREIGN KEY(ts_id) REFERENCES Time_Span(ts_id)
				ON DELETE NO ACTION	  ON UPDATE CASCADE
	   );


-- Professor_Degrees

CREATE TABLE Professor_Degrees
	   (
		p_username	VARCHAR(50)		NOT NULL,
		degree		NVARCHAR(100)	NOT NULL,
		PRIMARY KEY(p_username, degree),
		FOREIGN KEY(p_username) REFERENCES Professor(username)
				ON DELETE CASCADE	ON UPDATE CASCADE
	   );


-- Course

CREATE	TABLE Course
		(
		 course_id		INT				NOT NULL	PRIMARY KEY,
		 title			NVARCHAR(50)	NOT NULL,
		 [URL]			VARCHAR(256),
		 semester		VARCHAR(20)		NOT NULL,
		 p_username		VARCHAR(50),
		 school_id		SMALLINT		NOT NULL,
		 FOREIGN KEY(p_username) REFERENCES Professor(username)
				 ON DELETE SET NULL		ON UPDATE CASCADE,
		 FOREIGN KEY(school_id)  REFERENCES School(school_id)
				 ON DELETE NO ACTION	ON UPDATE NO ACTION
		);


-- Course_Time

CREATE	TABLE Course_Time
	    (
	     ts_id		SMALLINT	NOT NULL,
	     course_id	INT			NOT NULL,
		 PRIMARY KEY(ts_id, course_id),
		 FOREIGN KEY(ts_id) REFERENCES Time_Span(ts_id)
				ON DELETE NO ACTION		ON UPDATE CASCADE,
		 FOREIGN KEY(course_id) REFERENCES Course(course_id)
				ON DELETE CASCADE		ON UPDATE CASCADE
	    );


-- Enrollment

CREATE	TABLE Enrollment
	    (
		 s_username	VARCHAR(50)		NOT NULL,
		 course_id	INT				NOT NULL,
		 PRIMARY KEY(s_username, course_id),
		 FOREIGN KEY(s_username) REFERENCES Student(username)
		 		ON DELETE CASCADE	  ON UPDATE CASCADE,
		 FOREIGN KEY(course_id) REFERENCES Course(course_id)
		 		ON DELETE NO ACTION	  ON UPDATE CASCADE
	    );


-- Course_TA

CREATE	TABLE Course_TA	
		(
		 s_username		VARCHAR(50)		NOT NULL,
		 course_id		INT				NOT NULL,
		 FOREIGN KEY(s_username) REFERENCES Student(username)
				 ON DELETE CASCADE		ON UPDATE CASCADE,
		 FOREIGN KEY(course_id) REFERENCES Course(course_id)
				 ON DELETE CASCADE		ON UPDATE CASCADE
		);


-- Resources

CREATE	TABLE Resources
		(
		 course_id		INT				NOT NULL,
		 resource_id	VARCHAR(50)		NOT NULL,
		 title			NVARCHAR(50),
		 [type]			VARCHAR(10),
		 file_URL		VARCHAR(256),
		 [description]	NVARCHAR(256),
		 PRIMARY KEY(course_id, resource_id),
		 FOREIGN KEY(course_id) REFERENCES Course(course_id)
				 ON DELETE CASCADE		ON UPDATE CASCADE
		);


-- Activity

CREATE	TABLE Activity
		(
		 course_id		INT				NOT NULL,
		 activity_id	VARCHAR(50)		NOT NULL,
		 title			NVARCHAR(50),
		 start_time		DATETIME,
		 deadline		DATETIME,
		 [weight]		FLOAT,
		 [type]			CHAR,
		 PRIMARY KEY(course_id, activity_id),
		 FOREIGN KEY(course_id) REFERENCES Course(course_id)
				 ON DELETE CASCADE		ON UPDATE CASCADE
		);


-- Hand_In_Homework

CREATE	TABLE Hand_In_Homework
		(
		 s_username		VARCHAR(50)		NOT NULL,
		 activity_id	VARCHAR(50)		NOT NULL,
		 course_id		INT				NOT NULL,
		 [time]			DATETIME		NOT NULL,
		 score			FLOAT,
		 PRIMARY KEY(s_username, activity_id, course_id, [time]),
		 FOREIGN KEY(s_username) REFERENCES Student(username)
				 ON DELETE CASCADE		ON UPDATE CASCADE,
		 FOREIGN KEY(course_id, activity_id) REFERENCES Activity(course_id, activity_id)
				ON DELETE CASCADE		ON UPDATE CASCADE
		);


-- Activity_URL

CREATE	TABLE Activity_URL
		(
		 course_id		INT				NOT NULL,
		 activity_id	VARCHAR(50)		NOT NULL,
		 [URL]			VARCHAR(256)	NOT NULL,
		 PRIMARY KEY(course_id, activity_id, [URL]),
		 FOREIGN KEY(course_id, activity_id) REFERENCES Activity(course_id, activity_id)
				 ON DELETE CASCADE		ON UPDATE CASCADE
		);


-- Hand_In_Homework_URL

CREATE	TABLE Hand_In_Homework_URL
		(
		 s_username		VARCHAR(50)		NOT NULL,
		 activity_id	VARCHAR(50)		NOT NULL,
		 course_id		INT				NOT NULL,
		 [time]			DATETIME		NOT NULL,
		 [URL]			VARCHAR(250)	NOT NULL,
		 PRIMARY KEY(activity_id, s_username, course_id, [time], [URL]),
		 FOREIGN KEY(s_username, activity_id, course_id, [time]) REFERENCES Hand_In_Homework(s_username, activity_id, course_id, [time])
				 ON DELETE CASCADE		ON UPDATE CASCADE
		);