# 👨‍💻 SQL Projects

This repository currently contains two separate SQL projects where I have studied and practiced SQL DDL and DML structures. The first project is based on the major league baseball database. The second project is a simple beginning-to-end project where I have built an Instagram database clone.

## Major League Baseball Project

### Understanding the Schema

In this homework we will be working with the commonly-used [Lahman baseball statistics database](http://www.seanlahman.com/baseball-archive/statistics/). (Our friends at the San Francisco Giants tell us they use it!) The database contains pitching, hitting, and fielding statistics for Major League Baseball from 1871 through 2017.  It includes data from the two current leagues (American and National), four other "major" leagues (American Association, Union Association, Players League, and Federal League), and the National Association of 1871-1875.

The database is comprised of the following main tables:

	People - Player names, date of birth (DOB), and biographical info
	Batting - batting statistics
	Pitching - pitching statistics
	Fielding - fielding statistics

It is supplemented by these tables:

	AllStarFull - All-Star appearance
	HallofFame - Hall of Fame voting data
	Managers - managerial statistics
	Teams - yearly stats and standings
	BattingPost - post-season batting statistics
	PitchingPost - post-season pitching statistics
	TeamFranchises - franchise information
	FieldingOF - outfield position data
	FieldingPost- post-season fielding data
	ManagersHalf - split season data for managers
	TeamsHalf - split season data for teams
	Salaries - player salary data
	SeriesPost - post-season series information
	AwardsManagers - awards won by managers
	AwardsPlayers - awards won by players
	AwardsShareManagers - award voting for manager awards
	AwardsSharePlayers - award voting for player awards
	Appearances - details on the positions a player appeared at
	Schools - list of colleges that players attended
	CollegePlaying - list of players and the colleges they attended

For more detailed information, see the [docs online](http://www.seanlahman.com/files/database/readme2017.txt).

1. **Basics**
    1. In the `people` table, find the `namefirst`, `namelast` and `birthyear` for all players with weight greater than 300 pounds.
    2. Find the `namefirst`, `namelast` and `birthyear` of all players whose `namefirst` field contains a space.
    3. From the `people` table, group together players with the same `birthyear`, and report the `birthyear`, average `height`, and number of players for each `birthyear`. Order the results by `birthyear` in *ascending* order.

       Note: some birthyears have no players; your answer can simply skip those years. In some other years, you may find that all the players have a `NULL` height value in the dataset (i.e. `height IS NULL`); your query should return `NULL` for the height in those years.

    4. Following the results of Part iii, now only include groups with an average height > `70`. Again order the results by `birthyear` in *ascending* order.


2. **Hall of Fame Schools**
    1. Find the `namefirst`, `namelast`, `playerid` and `yearid` of all people who were successfully inducted into the Hall of Fame in *descending* order of `yearid`.

        Note: a player with id `drewj.01` is listed as having failed to be
        inducted into the Hall of Fame, but does not show up in the `people`
        table. Your query may assume that all players inducted into the Hall of Fame
        appear in the `people` table.

    2. Find the people who were successfully inducted into the Hall of Fame and played in college at a school located in the state of California. For each person, return their `namefirst`, `namelast`, `playerid`, `schoolid`, and `yearid` in *descending* order of `yearid`. Break ties on `yearid` by `schoolid, playerid` (ascending). (For this question, `yearid` refers to the year of induction into the Hall of Fame).

        Note: a player may appear in the results multiple times (once per year
        in a college in California).

    3. Find the `playerid`, `namefirst`, `namelast` and `schoolid` of all people who were successfully inducted into the Hall of Fame -- whether or not they played in college. Return people in *descending* order of `playerid`. Break ties on `playerid` by `schoolid` (ascending). (Note: `schoolid` will be `NULL` if they did not play in college.)

3. **[SaberMetrics](https://en.wikipedia.org/wiki/Sabermetrics)**
    1. Find the `playerid`, `namefirst`, `namelast`, `yearid` and single-year `slg` (Slugging Percentage) of the players with the 10 best annual Slugging Percentage recorded over all time. For statistical significance, only include players with more than 50 at-bats in the season. Order the results by `slg` descending, and break ties by `yearid, playerid` (ascending).

       *Baseball note*: Slugging Percentage is not provided in the database; it is computed according to a [simple formula](https://en.wikipedia.org/wiki/Slugging_percentage) you can calculate from the data in the database.

       *SQL note*: You should compute `slg` properly as a floating point number---you'll need to figure out how to convince SQL to do this!

    2. Following the results from Part i, find the `playerid`, `namefirst`, `namelast` and `lslg` (Lifetime Slugging Percentage) for the players with the top 10 Lifetime Slugging Percentage. Note that the database only gives batting information broken down by year; you will need to convert to total information across all time (from the earliest date recorded up to the last date recorded) to compute `lslg`.

       Order the results by `lslg` descending, and break ties by `playerid` (ascending order).

		*NOTE*: Make sure that you only include players with more than 50 at-bats across their lifetime.

    3. Find the `namefirst`, `namelast` and Lifetime Slugging Percentage (`lslg`) of batters whose lifetime slugging percentage is higher than that of San Francisco favorite Willie Mays. You may include Willie Mays' playerid in your query (`mayswi01`), but you *may not* include his slugging percentage -- you should calculate that as part of the query. (Test your query by replacing `mayswi01` with the playerid of another player -- it should work for that player as well! We may do the same in the autograder.)

		*NOTE*: Make sure that you still only include players with more than 50 at-bats across their lifetime.

    *Just for fun*: For those of you who are baseball buffs, variants of the above queries can be used to find other more detailed SaberMetrics, like [Runs Created](https://en.wikipedia.org/wiki/Runs_created) or [Value Over Replacement Player](https://en.wikipedia.org/wiki/Value_over_replacement_player). Wikipedia has a nice page on [baseball statistics](https://en.wikipedia.org/wiki/Baseball_statistics); most of these can be computed fairly directly in SQL.

    *Also just for fun*: SF Giants VP of Baseball Operations, [Yeshayah Goldfarb](https://www.mlb.com/giants/team/front-office/yeshayah-goldfarb), suggested the following:
    > Using the Lahman database as your guide, make an argument for when MLBs “Steriod Era” started and ended. There are a number of different ways to explore this question using the data.

    (Please do not include your "just for fun" answers in your solution file! They will break the autograder.)

4. **Salaries**
    1. Find the `yearid`, min, max, average and standard deviation of all player salaries for each year recorded, ordered by `yearid` in *ascending* order.

    2. For salaries in 2016, compute a [histogram](https://en.wikipedia.org/wiki/Histogram). Divide the salary range into 10 equal bins from min to max, with `binid`s 0 through 9, and count the salaries in each bin. Return the `binid`, `low` and `high` values for each bin, as well as the number of salaries in each bin, with results sorted from smallest bin to largest.

       *Note*: `binid` 0 corresponds to the lowest salaries, and `binid` 9 corresponds to the highest. The ranges are left-inclusive (i.e. `[low, high)`) -- so the `high` value is excluded. For example, if bin 2 has a `high` value of 100000, salaries of 100000 belong in bin 3, and bin 3 should have a `low` value of 100000.

       *Note*: The `high` value for bin 9 may be inclusive).

    3. Now let's compute the Year-over-Year change in min, max and average player salary. For each year with recorded salaries after the first, return the `yearid`, `mindiff`, `maxdiff`, and `avgdiff` with respect to the previous year. Order the output by `yearid` in *ascending* order. (You should omit the very first year of recorded salaries from the result.)

    4. In 2001, the max salary went up by over $6 million. Write a query to find the players that had the max salary in 2000 and 2001. Return the `playerid`, `namefirst`, `namelast`, `salary` and `yearid` for those two years. If multiple players tied for the max salary in a year, return all of them.

        *Note on notation:* you are computing a relational variant of the [argmax](https://en.wikipedia.org/wiki/Arg_max) for each of those two years.

    5. Each team has at least 1 All Star and may have multiple. For each team in the year 2016, give the `teamid` and `diffAvg` (the difference between the team's highest paid all-star's salary and the team's lowest paid all-star's salary). Order your final solution by `teamid`. NOTE: Due to some discrepancies in the database, please draw your team names from the All-Star table (so use allstarfull.teamid in the SELECT statement for this).
