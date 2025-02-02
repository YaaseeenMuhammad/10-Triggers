-- 10-Triggers

CREATE DATABASE COLLEGE;
USE COLLEGE;

-- 1. Create a table named teachers with fields id, name, subject, experience and salary and insert 8 rows.

CREATE TABLE teachers (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Subject VARCHAR(100),
    Experience INT,
    Salary DECIMAL(10, 2)
);

-- 2. Create a before insert trigger named before_insert_teacher that will raise an error “salary cannot be negative” if the salary inserted to the table is less than zero.

DELIMITER $$
	CREATE TRIGGER before_insert_teacher
	BEFORE INSERT ON teachers
	FOR EACH ROW
	BEGIN
		IF NEW.salary < 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Salary cannot be negative';
		END IF;
	END
$$ DELIMITER ;

-- Valid INSERT
INSERT INTO teachers (ID,Name, Subject, Experience, Salary) VALUES
(1,'John Honayi', 'Math', 5, 50000);

-- Invalid INSERT

INSERT INTO teachers (ID,Name, Subject, Experience, Salary) VALUES
(2,'John David', 'Science', 11, -100000);

-- View of Teachers Table

SELECT * FROM teachers;

-- 3. Create an after insert trigger named after_insert_teacher that inserts a row with teacher_id,action, timestamp to a table called teacher_log.

CREATE TABLE teacher_log (
    Log_id INT AUTO_INCREMENT PRIMARY KEY,
    Teacher_ID INT,
    Action VARCHAR(50),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- When a new entry gets inserted to the teacher table. Tecaher_id -> column of teacher table, action -> the trigger action, timestamp -> time at which the new row has got inserted. 

DELIMITER $$
	CREATE TRIGGER after_insert_teacher
	AFTER INSERT ON teachers
	FOR EACH ROW
	BEGIN
		INSERT INTO teacher_log (Teacher_ID, Action)
		VALUES (NEW.ID, concat('Inserted the Teacher_ID: ',NEW.ID));
	END
$$ DELIMITER ;

-- View of tables

SELECT * FROM teachers;
SELECT * FROM teacher_log;

-- Valid INSERT

INSERT INTO teachers (ID, Name, Subject, Experience, Salary) VALUES
(2,'John David', 'Science', 11, 100000),
(3,'Justin David', 'Economics', 15, 150000);

-- 4. Create a before delete trigger that will raise an error when you try to delete a row that has experience greater than 10 years.

DELIMITER $$
	CREATE TRIGGER before_delete_teacher
	BEFORE DELETE ON teachers
	FOR EACH ROW
	BEGIN
		IF OLD.Experience > 10 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Cannot delete teacher with more than 10 years of experience';
		END IF;
	END
$$ DELIMITER ;

-- Invalid DELETE

DELETE FROM teachers WHERE id=3;

-- Valid DELETE

DELETE FROM teachers WHERE id=1;

-- View of tables

SELECT * FROM teachers;
SELECT * FROM teacher_log;

-- 5. Create an after delete trigger that will insert a row to teacher_log table when that row is deleted from teacher table.

DELIMITER $$
	CREATE TRIGGER after_delete_teacher
	AFTER DELETE ON teachers
	FOR EACH ROW
	BEGIN
		INSERT INTO teacher_log (Teacher_ID, Action)
		VALUES (OLD.ID, Concat('Deleted the Teacher_ID: ',OLD.ID));
	END
$$ DELIMITER ;

INSERT INTO teachers (ID, Name, Subject, Experience, Salary) VALUES
(4,'John Dev', 'Math', 9, 100000);

-- View of tables

SELECT * FROM teachers;
SELECT * FROM teacher_log;

-- Valid DELETE

DELETE FROM teachers WHERE ID = 1;
