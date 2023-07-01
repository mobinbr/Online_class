USE [Project]

ALTER TABLE [Admin] 
ADD last_login DateTime NULL;

ALTER TABLE Professor 
ADD last_login DateTime NULL;

ALTER TABLE Student 
ADD last_login DateTime NULL;

ALTER TABLE Activity 
ADD [description] NVARCHAR(256) DEFAULT ' ';

ALTER TABLE Hand_In_Homework 
ADD is_final BIT DEFAULT 1;