--ref: https://thinketl.com/advanced-sql-interview-questions/

--step0: create schema, table
create schema st_loader.cricket

CREATE TABLE TEAMS(
   COUNTRY VARCHAR(50)
);

--step1: load data
INSERT INTO TEAMS VALUES('India');
INSERT INTO TEAMS VALUES('Srilanka');
INSERT INTO TEAMS VALUES('Bangladesh');
INSERT INTO TEAMS VALUES('Pakistan');

alter table teams rename to asia_cup_teams

--step2: QUERY#1 generate Cricket match fixtures for Asia Cup
with team as (
SELECT
   1 AS DUMMY,
   CASE
      WHEN COUNTRY = 'India' THEN 2
      WHEN COUNTRY = 'Srilanka' THEN 4
      WHEN COUNTRY = 'Bangladesh' THEN 1
      WHEN COUNTRY = 'Pakistan' THEN 3
   ELSE 0 END AS ID,
   COUNTRY
FROM st_loader.cricket.ASIA_CUP_TEAMS
)
SELECT
   t1.COUNTRY as "TEAM_1",
   t2.COUNTRY as "TEAM_2"
FROM TEAM t1 JOIN TEAM t2
ON t1.DUMMY = t2.DUMMY
AND t1.ID < t2.ID;

--^Query Note:
--If we do not include the join condition based on ID, the output will cause duplication of fixtures & also creating matches where a team plays against itself.
--The Dummy field helps in creating a cartesian output and the ID field helps in filtering the duplicates.

--step3: 3.1 Asia Cup matches - create input table
CREATE OR REPLACE TABLE st_loader.cricket.ASIA_CUP_MATCH_RESULTS(
TEAM_1 VARCHAR(10),
TEAM_2 VARCHAR(10),
RESULT VARCHAR(10)
);

INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('India','Bangladesh','India');
INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('India','Pakistan','India');
INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('India','Srilanka','');
INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('Srilanka','Bangladesh','Srilanka');
INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('Srilanka','Pakistan','Pakistan');
INSERT INTO ASIA_CUP_MATCH_RESULTS VALUES('Bangladesh','Pakistan','Bangladesh');

--step3: 3.2 QUERY#2 number of matches played, won, lost and tied by each team
WITH MATCHES AS
(
   SELECT TEAM_1 AS TEAM, RESULT FROM st_loader.cricket.asia_cup_match_results
   UNION ALL
   SELECT TEAM_2 AS TEAM, RESULT FROM st_loader.cricket.asia_cup_match_results
)
SELECT
   TEAM,
   COUNT(TEAM)  MATCHES_PLAYED,
   SUM(CASE WHEN RESULT = TEAM THEN 1 ELSE 0 END)  WINS,
   SUM(CASE WHEN RESULT = '' THEN 1 ELSE 0 END)  TIES,
   SUM(CASE WHEN (RESULT != TEAM AND RESULT != '') THEN 1 ELSE 0 END)  LOSS
FROM MATCHES
GROUP BY TEAM;
