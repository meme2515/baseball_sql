DROP VIEW IF EXISTS q0, q1i, q1ii, q1iii, q1iv, q2i, q2ii, q2iii, q3i, q3ii, q3iii, q4i, q4ii, q4iii, q4iv, q4v;

-- Question 0
CREATE VIEW q0(era) 
AS
 SELECT MAX(era)
 FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE '% %'
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count
  FROM people
  GROUP BY birthyear
  HAVING AVG(height) > 70
  ORDER BY birthyear
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT namefirst, namelast, p.playerid, yearid
  FROM people AS p, halloffame AS h
  WHERE p.playerid = h.playerid
  AND inducted = 'Y'
  ORDER BY yearid DESC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT namefirst, namelast, h.playerid, s.schoolid, h.yearid
  FROM people AS p, halloffame AS h, collegeplaying AS c, schools AS s
  WHERE p.playerid = h.playerid
  AND p.playerid = c.playerid
  AND c.schoolid = s.schoolid
  AND s.schoolstate = 'CA'
  AND inducted = 'Y'
  ORDER BY yearid DESC, schoolid, playerid
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT p.playerid, namefirst, namelast, schoolid
  FROM people AS p
  INNER JOIN halloffame AS h ON p.playerid = h.playerid
  LEFT JOIN collegeplaying AS c ON p.playerid = c.playerid
  WHERE inducted = 'Y'
  ORDER BY playerid DESC, schoolid
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
	SELECT p.playerid, namefirst, namelast, yearid, 
	CAST((1 * (h - h2b - h3b - hr) + 2 * h2b + 3 * h3b + 4 * hr) AS float) 
		/ CAST(ab AS float) AS slg
	FROM people AS p, batting AS b
	WHERE p.playerid = b.playerid
	AND ab > 50
	ORDER BY slg DESC, yearid, playerid
	LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
	SELECT p.playerid, namefirst, namelast, 
	CAST((1 * SUM(h - h2b - h3b - hr) + 2 * SUM(h2b) 
		+ 3 * SUM(h3b) + 4 * SUM(hr)) AS float) 
		/ CAST(SUM(ab) AS float) AS lslg
	FROM people AS p, batting AS b
	WHERE p.playerid = b.playerid
	GROUP BY p.playerid, namefirst, namelast
	HAVING SUM(ab) > 50
	ORDER BY lslg DESC, playerid
	LIMIT 10;
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
	SELECT namefirst, namelast, 
	CAST((1 * SUM(h - h2b - h3b - hr) + 2 * SUM(h2b) 
	  + 3 * SUM(h3b) + 4 * SUM(hr)) AS float) 
	  / CAST(SUM(ab) AS float) AS lslg
	FROM people AS p, batting AS b
	WHERE p.playerid = b.playerid
	GROUP BY p.playerid, namefirst, namelast
	HAVING SUM(ab) > 50
	AND
	(CAST((1 * SUM(h - h2b - h3b - hr) + 2 * SUM(h2b) 
	  + 3 * SUM(h3b) + 4 * SUM(hr)) AS float) 
	  / CAST(SUM(ab) AS float)) >
	  (SELECT
	  CAST((1 * SUM(h - h2b - h3b - hr) + 2 * SUM(h2b) 
	    + 3 * SUM(h3b) + 4 * SUM(hr)) AS float) 
	    / CAST(SUM(ab) AS float) AS lslg
	  FROM people AS p, batting AS b
	  WHERE p.playerid = b.playerid
	  AND p.playerid = 'mayswi01'
	  GROUP BY p.playerid)
	ORDER BY lslg DESC
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg, stddev)
AS
	SELECT yearid, MIN(salary) AS min, MAX(salary) AS max, 
	AVG(salary) AS average, STDDEV(salary) AS sd
	FROM salaries
	GROUP BY yearid
	ORDER BY yearid
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
	SELECT binid - 1 AS binid, 
	(SELECT MIN(salary) FROM salaries WHERE yearid = 2016)
	+ (binid - 1)
	* (SELECT CAST(MAX(salary) - MIN(salary) as float) / CAST(10 as float) FROM salaries WHERE yearid = 2016) 
	AS low, 
	(SELECT MIN(salary) FROM salaries WHERE yearid = 2016)
	+ binid
	* (SELECT CAST(MAX(salary) - MIN(salary) as float) / CAST(10 as float) FROM salaries WHERE yearid = 2016) 
	AS high,
	COUNT(*) 
	FROM
	  (SELECT width_bucket(salary, 
	    (SELECT MIN(salary) FROM salaries WHERE yearid = 2016), 
	    (SELECT MAX(salary) FROM salaries WHERE yearid = 2016) + 0.001, 10) AS binid,
	    salary
	  FROM salaries
	  WHERE yearid = 2016) AS bucket
	GROUP BY binid
	ORDER BY binid
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
	WITH yearinfo AS
	  (SELECT row_number()
	  OVER (ORDER BY yearid) AS row, 
	  yearid, MIN(salary), MAX(salary), AVG(salary)
	  FROM salaries
	  GROUP BY yearid)
	SELECT a.yearid, 
	a.min - b.min AS mindiff,
	a.max - b.max AS maxdiff,
	a.avg - b.avg AS avgdiff
	FROM yearinfo AS a
	LEFT JOIN yearinfo AS b
	ON a.row = (b.row + 1)
	WHERE a.yearid != (SELECT MIN(yearid) FROM salaries)
	ORDER BY yearid
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
	SELECT p.playerid, namefirst, namelast, salary, yearid
	FROM people AS p
	JOIN salaries AS s ON p.playerid = s.playerid
	WHERE yearid = 2000 
	AND salary = (SELECT MAX(salary) FROM salaries WHERE yearid = 2000)
	OR yearid = 2001 
	AND salary = (SELECT MAX(salary) FROM salaries WHERE yearid = 2001)
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) 
AS
	SELECT a.teamid, MAX(salary) - MIN(salary) AS diffAvg
	FROM allstarfull AS a, salaries AS s
	WHERE a.playerid = s.playerid
	AND a.yearid = s.yearid
	AND a.yearid = 2016
	GROUP BY a.teamid
	ORDER BY a.teamid
;

