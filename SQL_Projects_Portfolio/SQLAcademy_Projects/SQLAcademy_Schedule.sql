/*
Solving SQL challenges from SQL Academy, related to SCHEDULE topic
Выполнение заданий об авиаперелетах из тренажера SQL Academy 
------
Skills used / Навыки: Data Definition Language (DDL), Data Manipulation Language (DML), Aggregate Queries, 
JOIN queries, Sub Queries, Numeric Functions, Date and Time Functions
*/

-- #35.Сколько различных кабинетов школы использовались 2 сентября 2019 года для проведения занятий?
SELECT COUNT(classroom) AS count
FROM Schedule
WHERE date = "2019-09-02"

-- #37. Сколько лет самому молодому обучающемуся ?
SELECT MIN(
		DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), birthday)), '%Y') + 0
	) AS year
FROM Student

-- #40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.). Обратите внимание, 
-- что в базе данных есть несколько учителей с такими фамилией и инициалами.
SELECT DISTINCT name AS subjects
FROM Subject
	JOIN Schedule ON Subject.id = Schedule.subject
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE last_name = "Romashkin"
	AND first_name LIKE "P%"
	AND middle_name LIKE "P%"

-- #42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?
SELECT DISTINCT TIMEDIFF(
		(
			SELECT end_pair
			FROM Timepair
			WHERE id = 4
		),
		(
			SELECT start_pair
			FROM Timepair
			WHERE id = 2
		)
	) AS time
FROM Timepair

-- #43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). 
-- Отсортируйте преподавателей по фамилии в алфавитном порядке.
SELECT last_name
FROM Teacher
	JOIN Schedule ON Teacher.id = Schedule.teacher
WHERE subject = (
		SELECT id
		FROM Subject
		WHERE name = "Physical Culture"
	)
ORDER BY last_name

-- #46. В каких классах введет занятия преподаватель "Krauze" ?
SELECT Class.name AS name
From Class
	JOIN Schedule ON Class.id = Schedule.class
WHERE teacher = (
		SELECT Teacher.id
		FROM Teacher
		WHERE last_name = "Krauze"
	)
GROUP BY name

-- #47. Сколько занятий провел Krauze 30 августа 2019 г.?
SELECT COUNT(*) AS count
FROM Schedule
	JOIN Teacher ON Schedule.Teacher = Teacher.id
WHERE last_name = "Krauze"
	AND date = "2019-08-30"

-- #48. Выведите заполненность классов в порядке убывания
SELECT Class.name AS name,
	COUNT(student) AS count
FROM Class
	JOIN Student_in_class ON Class.id = Student_in_class.class
GROUP BY name
ORDER BY count DESC

-- #49. Какой процент обучающихся учится в "10 A" классе? Выведите ответ в диапазоне от 0 до 100 с 
-- округлением до четырёх знаков после запятой, например, 96.0201.
SELECT COUNT(student) * 100 /(
		SELECT COUNT(student)
		FROM Student_in_class
	) AS percent
FROM Student_in_class
	JOIN Class ON Student_in_class.class = Class.id
WHERE name = "10 A"

-- #50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.
SELECT FLOOR(
		(
			COUNT(birthday) * 100 / (
				SELECT COUNT(id)
				FROM Student
			)
		)
	) AS percent
FROM Student
WHERE YEAR(birthday) = 2000

-- #57. Перенести расписание всех занятий на 30 мин. вперед.
UPDATE Timepair
SET start_pair = start_pair + INTERVAL 30 MINUTE,
	end_pair = end_pair + INTERVAL 30 MINUTE

-- #44. Найдите максимальный возраст (количество лет) среди обучающихся 10 классов на сегодняшний день. 
-- Для получения текущих даты и времени используйте функцию NOW().
SELECT MAX(
		DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), birthday)), "%Y") + 0
	) AS max_year
FROM Student
	JOIN Student_in_class ON Student.id = Student_in_class.student
	JOIN Class ON Student_in_class.class = Class.id
WHERE Class.name LIKE "10%"

--#45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались
-- максимальное количество раз.
SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(*) = (
		SELECT COUNT(classroom) AS count
		FROM Schedule
		GROUP BY classroom
		ORDER BY count DESC
		LIMIT 1
	)
