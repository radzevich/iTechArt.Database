USE [Company]
GO

/**1) Получить все содержимое таблицы Employee*/
SELECT * FROM Employee
GO


/*2) Получить коды и названия должностей, чья минимальная зарплата не превышает 500*/
SELECT Id, Position FROM Job 
WHERE MinimalSalaryPerMonth <= 500
GO


/*3) Получить среднюю заработную плату начисленную в январе 2015 года*/
SELECT AVG (Amount) FROM Salary 
WHERE Year = 2015 and Month = 1
GO


/*4) Получить имя самого старого работника, а также его возраст*/
SELECT Name FROM Employee WHERE Birthday = (
	SELECT MIN(Birthday) FROM Employee
	);
GO


/*5) Найти фамилии работников, которым была начислена зарплата в январе 2015 года*/
SELECT Name From Employee
JOIN Salary as s ON Employee.Id = s.EmployeeId
WHERE s.Year = 2015 and s.Month = 1;
GO
SELECT NAME FROM Employee
WHERE Id = (
	SELECT EmployeeId FROM Salary 
	WHERE Year = 2015 and Month = 1
)


/*TODO*/
/*6) Найти коды работников, зарплата которых в мае 2015 года снизилась по сравнению с 
каким-либо предыдущим месяцем этого же года*/
SELECT EmployeeId FROM Salary 
WHERE YEAR = 2015 and Month = 5 and Amount < (
	SELECT MAX(AMOUNT) 
	FROM Salary WHERE YEAR = 2015 and Month < 5
)
GROUP BY EmployeeId
GO


/*7) Получить информацию о кодах, названиях отделов и количестве работающих в этих 
	отделах в настоящее время сотрудников*/
SELECT Id, Name, Count(d.Id) FROM Career as c
JOIN Department as d
	ON c.DepartmentId = d.Id
WHERE DismissalDate IS NOT NULL
GROUP BY Id, Name
GO


/*8) Найти среднюю начисленную зарплату за 2015 год в разрезе работников*/
SELECT AVG(innerAverages)
FROM
(
	SELECT AVG(AMOUNT) as innerAverages
	FROM Salary AS s
	WHERE Year = 2015 
	GROUP BY EmployeeId
) inner_query
GO


/*9) Найти среднюю зарплату за 2015 год в разрезе работников. Включать в результат только тех работников, 
	начисления которым проводились не менее двух раз*/
SELECT AVG(innerAverages)
FROM
(
	SELECT AVG(AMOUNT) as innerAverages
	FROM Salary AS s
	WHERE Year = 2015 
	GROUP BY EmployeeId
	HAVING COUNT(Id) > 2
) inner_query
GO


/*10) Найти имена тех работников, начисленная зарплата которых за январь 2015 превысила 1000*/
SELECT Name FROM Employee AS e
JOIN Salary as s ON e.Id = s.EmployeeId
WHERE s.Year = 2015 and s.Month = 1 and s.Amount > 1000
GO


/*11) Найти имена работников и стаж их непрерывной работы (на одной должности и в одном отделе).*/
SELECT Name, CASE
	WHEN DismissalDate IS NOT NULL  THEN
		DATEDIFF(DAY, RecruitmentDate , DismissalDate) 
	ELSE 
		DATEDIFF(DAY, RecruitmentDate , CURRENT_TIMESTAMP) 
	END 
FROM Employee AS e
JOIN  Career AS c ON e.Id = c.EmployeeId
GO


/*12) Увеличить минимальную зарплату для всех должностей в 1.5 раза*/
UPDATE Job
SET MinimalSalaryPerMonth = MinimalSalaryPerMonth / 2
GO


/*13) Удалить из таблицы salary все записи за 2014 и более ранние годы*/
DELETE FROM Salary
WHERE YEAR <= 2014
GO