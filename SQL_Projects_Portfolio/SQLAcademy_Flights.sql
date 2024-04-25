/*
Solving SQL challenges from SQL Academy, related to flights topic
Выполнение заданий об авиаперелетах из тренажера SQL Academy 
------
Skills used / Навыки: Data Definition Language (DDL), Data Manipulation Language (DML), Aggregate Queries, JOIN queries, Sub Queries, Date and Time Functions
*/

/* #8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?*/
/* #8. What cities can you fly to from Paris and how long will it take? */
SELECT town_to, TIMEDIFF(time_in, time_out) AS flight_time
FROM Trip
WHERE town_from = "Paris"

/* #10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.*/
/* #10. Display departures made from 10 a.m. to 2 p.m. on January 1, 1900. */
SELECT *
FROM TRIP
WHERE time_out BETWEEN "1900:01:01 10:00:00" AND "1900:01:01 14:00:00"

/* #11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.*/
/* #11. Output passengers with the longest full names. Spaces, hyphens, and periods are considered part of the name. */
SELECT name as name
FROM Passenger
WHERE LENGTH(name) = (
		SELECT MAX(LENGTH(name)) 
    FROM Passenger
	)

/* #16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.*/
/* #16. Output a sorted list of passengers, sorted by the number of flights (in descending order) and by name (in ascending order), who have made at least 1 flight. */
SELECT name, COUNT(trip) AS count
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY passenger
HAVING COUNT(trip) >= 1
ORDER BY COUNT(trip) DESC, name

/* #29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134*/
/* #29. Output the names of passengers who flew to Moscow on a TU-134 aircraft. */
SELECT DISTINCT Passenger.name AS name
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE plane = "TU-134" AND town_to = "Moscow"

/* #30. Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности. */
/* #30. Output the occupancy (number of passengers) of each trip. Display the result in sorted order by decreasing occupancy. */
SELECT trip, COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC

/* #55. Удалить компании, совершившие наименьшее количество рейсов. */
/* #55. Delete companies that have made the fewest flights. */
DELETE FROM Company
WHERE id IN (
		SELECT company
		FROM Trip
		GROUP BY company
		HAVING COUNT(id) = (
				SELECT MIN(count)
				FROM (
						SELECT COUNT(id) AS count
						FROM Trip
						GROUP BY company
					) AS min_count ))

/* # Как это может решить бизнес-проблемы или помочь бизнесу?

Исходя из данных, полученных из каждого задания, авиакомпании могут принимать более обоснованные решения и оптимизировать свои операции, что в конечном итоге может помочь решить ряд бизнес-проблем и улучшить общее положение компании.

Анализ данных о доступных направлениях из Парижа и времени в пути позволяет пассажирам принимать более информированные решения о своих путешествиях, что может повысить удовлетворенность клиентов и повторные продажи. Изучение спроса на авиаперевозки и анализ вылетов в определенное время помогают авиакомпаниям оптимизировать расписание и ресурсы для удовлетворения спроса в пиковые периоды. При этом, идентификация предпочтений пассажиров и выявление наиболее активных клиентов позволяют компаниям разрабатывать персонализированные маркетинговые кампании и программы лояльности, что способствует удержанию клиентов и повышению доходов.

Кроме того, анализ загруженности рейсов и оптимизация распределения ресурсов позволяют авиакомпаниям сокращать издержки и повышать эффективность операций. Это также может помочь в адаптации сервиса под потребности пассажиров и улучшении качества обслуживания. В конечном итоге, использование этих данных позволяет авиакомпаниям лучше понимать своих клиентов, улучшать качество предоставляемых услуг и укреплять свою конкурентоспособность на рынке авиаперевозок.

    # How this can answer business problems or help a business out?

Based on the data obtained from each task, airlines can make more informed decisions and optimize their operations, which ultimately can help solve a range of business problems and improve the overall position of the company.

Analyzing data on available destinations from Paris and travel times allows passengers to make more informed decisions about their travels, which can increase customer satisfaction and repeat sales. Studying demand for air travel and analyzing departures at specific times helps airlines optimize schedules and resources to meet demand during peak periods. Additionally, identifying passenger preferences and identifying the most active customers enables companies to develop personalized marketing campaigns and loyalty programs, which contributes to customer retention and revenue growth.

Furthermore, analyzing flight loads and optimizing resource allocation allows airlines to reduce costs and increase operational efficiency. This can also help adapt services to passenger needs and improve service quality. Ultimately, using this data allows airlines to better understand their customers, improve the quality of services provided, and strengthen their competitiveness in the air travel market.
*/
