-- 1. INSERT
--	1. Без указания списка полей
		INSERT INTO about_employee 
		VALUES ('1', 'senior programmer', '42000', '25-07-2015', '13-11-1989'),
		 ('5', 'project manager', '92000', '15-01-2012', '13-01-1982'),
		 ('10', 'middle programmer', '39000', '12-12-2017', '15-03-1991'),
		 ('12', 'junior programmer', '12000', '09-12-2019', '30-12-2000'),
		 ('20', 'junior programmer', '15000', '05-06-2020', '31-01-1996'),
		 ('18', 'junior programmer', '18000', '15-03-2018', '17-10-1999');
--	2. С указанием списка полей
		INSERT INTO about_employee (id_about_employee, salary, date_of_birth, position, beginning_of_work) 
		VALUES ('2', '118000', '21-11-1970', 'company director', '18-08-2005');
--	3. С чтением значения из другой таблицы
		INSERT INTO completed_project_second 
		VALUES ('1', '12-02-1932', '31-07-2000', 'lab1');

		INSERT INTO completed_project(id_completed_project, completion_day, deadline, title) 
		SELECT * 
		FROM completed_project_second;

-- 2. DELETE
--	1. Всех записей
		DELETE project;
		DELETE completed_project;
		DELETE participation_in_project;
		DELETE employee;
		DELETE about_employee;
--	2. По условию
		DELETE FROM about_employee 
		WHERE id_about_employee = 1;
--	3. Очистить таблицу
		TRUNCATE TABLE completed_project_second;


-- 3. UPDATE
--	1. Всех записей
		UPDATE about_employee 
		SET salary = 15000;
--	2. По условию обновляя один атрибут
		UPDATE about_employee 
		SET position = 'senior programmer' 
		WHERE beginning_of_work >= '2015-01-01';
--	3. По условию обновляя несколько атрибутов
		UPDATE about_employee 
		SET salary = 90000, date_of_birth = '1970-01-01'
		WHERE position = 'senior programmer';

-- 4. SELECT
--	1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
		SELECT position, salary	
		FROM about_employee;
--	2. Со всеми атрибутами (SELECT * FROM...)
		SELECT * 
		FROM about_employee;
--	3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
		SELECT * 
		FROM about_employee 
		WHERE id_about_employee = 20;

-- 5. SELECT ORDER BY + TOP (LIMIT)
--	1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
		SELECT TOP 4 salary, beginning_of_work
		FROM about_employee
		ORDER BY salary ASC;
--	2. С сортировкой по убыванию DESC
		SELECT TOP 3 salary, beginning_of_work
		FROM about_employee
		ORDER BY salary DESC;
--	3. С сортировкой по двум атрибутам + ограничение вывода количества записей
		SELECT TOP 5 * 
		FROM about_employee
		ORDER BY date_of_birth, beginning_of_work;
--	4. С сортировкой по первому атрибуту, из списка извлекаемых
		SELECT *
		FROM about_employee
		ORDER BY 1;

-- 6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
--		Например, таблица авторов может содержать дату рождения автора.
--	1. WHERE по дате
		SELECT * 
		FROM about_employee 
		WHERE date_of_birth = '01-01-1970 00:00:00';
--	2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
--		Для этого используется функция YEAR 
		SELECT YEAR(date_of_birth) AS year
		FROM about_employee;

-- 7. SELECT GROUP BY с функциями агрегации
--	1. MIN
		SELECT position, MIN(salary) AS beggar
		FROM about_employee
		GROUP BY position;
--	2. MAX
		SELECT position, MAX(salary) AS rich 
		FROM about_employee 
		GROUP BY position;
--	3. AVG
		SELECT position, AVG(salary) AS avg_salary 
		FROM about_employee 
		GROUP BY position;
--	4. SUM
		SELECT position, SUM(salary) AS sum_salary
		FROM about_employee 
		GROUP BY position;
--	5. COUNT
		SELECT position, COUNT(id_about_employee) AS all_employees
		FROM about_employee
		GROUP BY position;

--	8. SELECT GROUP BY + HAVING
--	1. Написать 3 разных запроса с использованием GROUP BY + HAVING
		SELECT position, SUM(salary) AS rich 
		FROM about_employee
		GROUP BY position
		HAVING SUM(salary) > 44000;

		SELECT position, SUM(salary) AS rich 
		FROM about_employee
		GROUP BY position
		HAVING position = 'project manager'

		SELECT date_of_birth, MIN(salary) AS newschool 
		FROM about_employee
		GROUP BY date_of_birth
		HAVING date_of_birth > '01-01-1998'

--	9. SELECT JOIN
		INSERT INTO employee
		VALUES ('1', 'sergey','vladimirovich', 'orazaev', '89377165964', '1');

		INSERT INTO project
		VALUES ('1', 'LAB3', 'completed 3 lab', '23-11-2020', '1', '1-12-2020')

		INSERT INTO participation_in_project
		VALUES ('1', '1', '1');
--	1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
		SELECT * 
		FROM about_employee ae
		LEFT JOIN employee e
			ON e.id_about_employee = ae.id_about_employee
		WHERE salary > 30000
--	2. RIGHT JOIN. Получить такую же выборку, как и в 9.1
		SELECT * 
		FROM employee e
		RIGHT JOIN about_employee ae
			ON ae.id_about_employee = e.id_about_employee
		WHERE salary > 30000
--	3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
		SELECT * 
		FROM employee e
		LEFT JOIN about_employee ae
			ON ae.id_about_employee = e.id_about_employee
		LEFT JOIN participation_in_project pip
			ON pip.id_employee = e.id_about_employee
		WHERE ae.salary > 30000 
			AND e.first_name = 'sergey'
			AND pip.id_employee = 1
--	4. FULL OUTER JOIN двух таблиц
		SELECT *
		FROM about_employee ae
		FULL OUTER JOIN employee e
		ON e.id_about_employee = ae.id_about_employee

--	10. Подзапросы
--	1. Написать запрос с WHERE IN (подзапрос)
		SELECT * 
		FROM about_employee 
		WHERE id_about_employee IN (SELECT id_employee FROM employee);

--	2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
		SELECT salary, position, (SELECT second_name FROM employee)
		FROM about_employee 
		WHERE salary > 50000;
