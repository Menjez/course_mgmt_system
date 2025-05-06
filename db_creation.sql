--Creating Database and Tables
CREATE DATABASE course_management;

CREATE TABLE Students(
    student_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    date_of_birth DATE
);

CREATE TABLE Instructors(
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR
);

CREATE TABLE Courses(
    course_id INT PRIMARY KEY,
    course_name VARCHAR,
    course_description TEXT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

CREATE TABLE Enrollments(
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(1),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

--Populating tables with sample data
INSERT INTO public.students(student_id, first_name, last_name, email, date_of_birth)
VALUES
(1, 'Wanjiku', 'Kamau', 'wanjiku.kamau@email.com', '2000-05-15'),
(2, 'Odhiambo', 'Otieno', 'odhiambo.otieno@email.com', '2001-07-22'),
(3, 'Njeri', 'Mwangi', 'njeri.mwangi@email.com', '1999-11-08'),
(4, 'Kiprono', 'Kipchoge', 'kiprono.kipchoge@email.com', '2002-03-30'),
(5, 'Akinyi', 'Ochieng', 'akinyi.ochieng@email.com', '2000-09-12'),
(6, 'Muthoni', 'Ngugi', 'muthoni.ngugi@email.com', '2001-01-25'),
(7, 'Wekesa', 'Wafula', 'wekesa.wafula@email.com', '1999-04-18'),
(8, 'Nafula', 'Simiyu', 'nafula.simiyu@email.com', '2002-12-05'),
(9, 'Kimani', 'Githuku', 'kimani.githuku@email.com', '2000-08-27'),
(10, 'Atieno', 'Adhiambo', 'atieno.adhiambo@email.com', '2001-06-14'),
(11, 'Gathoni', 'Kariuki', 'gathoni.kariuki@email.com', '2003-02-19'),
(12, 'Kipkorir', 'Rotich', 'kipkorir.rotich@email.com', '2000-10-05'),
(13, 'Waithera', 'Githinji', 'waithera.githinji@email.com', '2001-12-28'),
(14, 'Onyango', 'Owino', 'onyango.owino@email.com', '2002-07-11'),
(15, 'Chepkoech', 'Kemboi', 'chepkoech.kemboi@email.com', '1999-08-30');

INSERT INTO public.instructors(instructor_id, first_name, last_name, email)
VALUES
(1, 'Muthoni', 'Wanjau', 'muthoni.wanjau@faculty.ac.ke'),
(2, 'Kiprop', 'Tanui', 'kiprop.tanui@faculty.ac.ke'),
(3, 'Auma', 'Ojwang', 'auma.ojwang@faculty.ac.ke'),
(4, 'Barasa', 'Makokha', 'barasa.makokha@faculty.ac.ke'),
(5, 'Nyambura', 'Gichuru', 'nyambura.gichuru@faculty.ac.ke');

INSERT INTO Courses (course_id, course_name, course_description, instructor_id) VALUES
(101, 'Medicine', 'Study of diagnosis, treatment, and prevention of disease.', 1),
(102, 'Economics', 'Analysis of production, distribution, and consumption of goods and services.', 2),
(103, 'Civil Engineering', 'Design and construction of the physical and built environment.', 3),
(104, 'Computer Science', 'Study of computers and computational systems.', 4),
(105, 'Law', 'Study of rules, regulations and legal systems.', 5),
(106, 'Mathematics', 'Study of numbers, quantities, shapes and patterns.', 1),
(107, 'Physics', 'Study of matter, energy, and the interactions between them.', 2),
(108, 'Psychology', 'Study of behavior and mental processes.', 3),
(109, 'Business', 'Study of commercial activities, markets and management.', 4),
(110, 'Literature', 'Study of written works that have artistic or intellectual value.', 5);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1001, 1, 101, '2022-09-05', 'A'),
(1002, 2, 103, '2023-01-12', 'B'),
(1003, 3, 103, '2024-09-08', 'A'),
(1004, 3, 107, '2022-09-10', 'D'),
(1005, 7, 109, '2023-01-20', 'B'),
(1006, 6, 102, '2024-09-04', 'A'),
(1007, 7, 104, '2022-09-06', 'C'),
(1008, 8, 106, '2023-01-19', 'B'),
(1009, 9, 108, '2024-09-11', 'E'),
(1010, 9, 110, '2022-09-13', 'B'),
(1011, 11, 101, '2023-01-17', 'C'),
(1012, 12, 103, '2024-09-15', 'B'),
(1013, 13, 105, '2022-09-12', 'A'),
(1014, 14, 103, '2023-01-14', 'D'),
(1015, 15, 109, '2024-09-18', 'A'),
(1016, 1, 102, '2023-01-20', 'B'),
(1017, 3, 104, '2024-09-05', 'A'),
(1018, 7, 107, '2022-09-12', 'E'),
(1019, 7, 109, '2023-01-19', 'B'),
(1020, 9, 110, '2024-09-16', 'E');