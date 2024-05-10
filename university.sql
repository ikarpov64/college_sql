-- Удаляем дефолтную схему
DROP SCHEMA IF EXISTS public CASCADE;

-- Создаем новую схему
CREATE SCHEMA IF NOT EXISTS college;

-- Создаем таблицу с факультетами
CREATE TABLE college.faculty 
(
	faculty_id integer NOT NULL PRIMARY KEY,
	faculty_name varchar(125) NOT NULL,
	cost_of_education integer NOT NULL
);

-- Создаем таблицу с курсами
CREATE TABLE college.course
(
	course_id integer NOT NULL PRIMARY KEY,
	course_number integer NOT NULL,
	faculty_id integer REFERENCES college.faculty(faculty_id) ON DELETE CASCADE
);

-- Создаем дополнительную таблицу с типами финансирования обучения.
CREATE TABLE college.financing_type
(
    financing_id integer PRIMARY KEY,
    financing_type varchar(20)	
);

-- Создаем таблицу с учениками
CREATE TABLE college.students 
(
	student_id integer NOT NULL PRIMARY KEY,
	last_name varchar(125),
	first_name varchar(125),
	patronymic varchar(125) DEFAULT ('отсутствует'),
	financing_type int REFERENCES college.financing_type(financing_id) ON DELETE CASCADE,
	course_id integer REFERENCES college.course(course_id) ON DELETE CASCADE
);

-- Заполняем данные:
-- Таблица с факультетами
INSERT INTO college.faculty VALUES (1, 'Инженерный', 30000);
INSERT INTO college.faculty VALUES (2, 'Экономический', 49000);

-- Таблица с курсами
INSERT INTO college.course VALUES (1, 1, 1);
INSERT INTO college.course VALUES (2, 1, 2);
INSERT INTO college.course VALUES (3, 4, 2);

-- Таблица с типами финансирования
INSERT INTO college.financing_type VALUES (1, 'бюджет');
INSERT INTO college.financing_type VALUES (2, 'платное');

-- Таблица со студентами
INSERT INTO college.students VALUES (1, 'Петров', 'Петр', 'Петрович', 1, 1);
INSERT INTO college.students VALUES (2, 'Иванов', 'Иван', 'Иванович', 2, 1);
INSERT INTO college.students VALUES (3, 'Михно', 'Сергей', 'Иванович', 1, 3);
INSERT INTO college.students VALUES (4, 'Стоцкая', 'Ирина', 'Юрьевна', 2, 3);
INSERT INTO college.students(
	student_id, first_name, last_name, financing_type, course_id) 
	VALUES (5, 'Младич', 'Настасья', 2, 1);
	
-- Выборка данных
-- Вывести всех студентов, кто платит больше 30_000.
SELECT st.last_name, st.first_name, st.patronymic, fa.faculty_name, ft.financing_type, fa.cost_of_education
FROM college.students st
JOIN college.course co on st.course_id = co.course_id
JOIN college.financing_type ft on st.financing_type = ft.financing_id
JOIN college.faculty fa on co.faculty_id = fa.faculty_id
WHERE fa.cost_of_education > 30000 AND ft.financing_type = 'платное';

-- Перевести всех студентов Петровых на 1 курс экономического факультета.
UPDATE college.students st
	SET course_id = 2
	WHERE st.last_name LIKE 'Петров%';
	
-- Вывести всех студентов без отчества или фамилии.
SELECT *
FROM college.students st
WHERE st.patronymic = 'отсутствует' or st.last_name ISNULL;

-- Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван".
SELECT *
FROM college.students st
WHERE st.first_name LIKE '%ван%' or st.last_name LIKE '%ван%' or st.patronymic LIKE '%ван%';

-- Удалить все записи из всех таблиц.
DELETE FROM college.faculty;
DELETE FROM college.course;
DELETE FROM college.financing_type;
DELETE FROM college.students;

-- Проверяем что таблица пуста
SELECT *
FROM college.students st
