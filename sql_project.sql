-- Active: 1746348621633@@pg-57b975c-test-98a4.i.aivencloud.com@10933@course_management

--Queries

--Students who enrolled in at least one course
SELECT DISTINCT s.student_id, first_name, last_name, COUNT(e.course_id) AS courses_taken
FROM public.students s
JOIN public.enrollments e on s.student_id = e.student_id
GROUP BY s.student_id, first_name, last_name
HAVING COUNT(e.course_id) >= 1
ORDER BY courses_taken DESC;

--Students enrolled in more than two courses
SELECT s.student_id, first_name, last_name,  COUNT(e.course_id) AS courses_taken
FROM public.students s
JOIN public.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 2
ORDER BY courses_taken DESC;

--Courses with total enrolled students
SELECT c.course_id, course_name,
COUNT(e.student_id) AS total_enrolled_students
FROM public.courses c
LEFT JOIN public.enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, course_name
ORDER BY total_enrolled_students DESC;

-- Average grade per course 
WITH grade_values AS (
    SELECT course_id,
    CASE 
        WHEN grade = 'A' THEN 4 
        WHEN grade = 'B' THEN 3
        WHEN grade = 'C' THEN 2
        WHEN grade = 'D' THEN 1 
        WHEN grade = 'E' THEN 0
        ELSE NULL
    END AS numeric_grade
    FROM public.enrollments
    WHERE grade IS NOT NULL
)
SELECT c.course_id, c.course_name, AVG(grade_values.numeric_grade) AS average_grade
FROM public.courses c
LEFT JOIN grade_values ON c.course_id = grade_values.course_id
GROUP BY c.course_id, c.course_name
ORDER BY average_grade DESC;


--Students who haven’t enrolled in any course
SELECT s.student_id, first_name, last_name,COUNT(e.course_id) AS courses_taken
FROM public.students s
LEFT JOIN public.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) = 0;

--Students with their average grade across courses
WITH student_grades AS (
    SELECT student_id,
    CASE 
        WHEN grade = 'A' THEN 4 
        WHEN grade = 'B' THEN 3
        WHEN grade = 'C' THEN 2
        WHEN grade = 'D' THEN 1
        WHEN grade = 'E' THEN 0
        ELSE  NULL
    END AS numeric_grade
    FROM public.enrollments
)
SELECT s.student_id, first_name, last_name, AVG(student_grades.numeric_grade) AS average_grade
FROM public.students s
LEFT JOIN student_grades ON s.student_id = student_grades.student_id
GROUP BY s.student_id, first_name, last_name
ORDER BY average_grade DESC;

--Instructors with the number of courses they teach.
SELECT i.instructor_id, first_name, last_name, COUNT(c.course_id) AS courses_taught
FROM public.instructors i
LEFT JOIN public.courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id, first_name, last_name;

--Students enrolled in a course taught by specific instructor
SELECT DISTINCT s.student_id, s.first_name, s.last_name, course_name
FROM public.students s
JOIN public.enrollments e ON s.student_id = e.student_id
JOIN public.courses c ON e.course_id = c.course_id
FULL OUTER JOIN public.instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Barasa' AND i.last_name = 'Makokha';

--Top 3 students by average grade
SELECT s.student_id, first_name, last_name, round(avg(
    CASE 
        WHEN grade = 'A' THEN 4
        WHEN grade = 'B' THEN 3
        WHEN grade = 'C' THEN 2
        WHEN grade = 'D' THEN 1
        WHEN grade = 'E' THEN 0
        ELSE NULL
    END),2) AS average_grade
FROM public.students s
JOIN public.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, first_name, last_name
ORDER BY average_grade DESC
LIMIT 3;

--Students failing (grade = ‘F’) in more than one course
SELECT s.student_id, first_name, last_name, COUNT(grade) AS no_of_failed_courses
FROM public.students s
JOIN public.enrollments e on s.student_id = e.student_id
WHERE grade = 'E'
GROUP BY s.student_id, first_name, last_name
HAVING COUNT(grade) > 1
ORDER BY no_of_failed_courses DESC;


--Advanced SQL
-- Creating a view
CREATE VIEW student_course_summary AS
SELECT first_name, last_name, course_name, grade
FROM public.enrollments e
JOIN public.students s ON e.student_id = s.student_id
JOIN public.courses c ON e.course_id = c.course_id;
SELECT * FROM student_course_summary

-- Creating an Index
CREATE INDEX student_id_enrollment ON public.enrollments(student_id);
SELECT *
FROM pg_indexes WHERE tablename = 'student_id_enrollment';

-- Create a trigger that logs new enrollments
--First, create a log table
CREATE TABLE Enrollment_Log (
    log_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Then create the trigger function
CREATE OR REPLACE FUNCTION log_new_enrollment()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Enrollment_Log(student_id, course_id)
    VALUES (NEW.student_id, NEW.course_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Finally, create the trigger itself
CREATE TRIGGER trigger_log_enrollment
AFTER INSERT ON Enrollments
FOR EACH ROW
EXECUTE FUNCTION log_new_enrollment();
--Test to check if trigger works
--Add new row to Enrollments table
INSERT INTO public.enrollments 
VALUES (1021, 5, 110, '2024-10-17', 'B');
--Check to confirm new row is added automatically
SELECT * FROM public.enrollment_log ORDER BY enrollment_date DESC;


