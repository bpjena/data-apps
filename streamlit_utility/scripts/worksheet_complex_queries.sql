--ref: https://thinketl.com/advanced-sql-interview-questions/
--step4: 4.1 create sequence table
CREATE TABLE st_loader.cricket.ELEMENTS(
ELEMENT VARCHAR2(10),
SEQUENCE NUMBER
);

INSERT INTO ELEMENTS VALUES('A','1');
INSERT INTO ELEMENTS VALUES('A','2');
INSERT INTO ELEMENTS VALUES('A','3');
INSERT INTO ELEMENTS VALUES('A','5');
INSERT INTO ELEMENTS VALUES('A','6');
INSERT INTO ELEMENTS VALUES('A','8');
INSERT INTO ELEMENTS VALUES('A','9');
INSERT INTO ELEMENTS VALUES('B','11');
INSERT INTO ELEMENTS VALUES('C','13');
INSERT INTO ELEMENTS VALUES('C','14');
INSERT INTO ELEMENTS VALUES('C','15');

--step4: 4.2 QUERY#3 find Min and Max values of continuous sequence in a group of elements
WITH TEMP AS(
SELECT
ELEMENT,
SEQUENCE,
ROW_NUMBER() OVER(PARTITION BY ELEMENT ORDER BY SEQUENCE) AS ELEMENT_SEQ
FROM ELEMENTS
),
--Add a continuous sequence for each element using ROW_NUMBER analytic function as a separate field

TEMP2 AS(
SELECT
ELEMENT,
SEQUENCE,
ELEMENT_SEQ,
(SEQUENCE - ELEMENT_SEQ) AS DIFF
FROM TEMP
)
--Subtract the sequence of each element from the generated continuous sequence. This difference value from the subtraction will be equal for the continuous sequence values

SELECT
ELEMENT,
MIN(SEQUENCE) AS MIN_SEQ,
MAX(SEQUENCE) AS MAX_SEQ
FROM TEMP2
GROUP BY ELEMENT,DIFF;
--In the final step, select the min and max of Sequence values of an element by grouping them on Element and the Difference value

--step5: 5.1 create sequence table.
--The problem is similar to the one discussed in previous question. The difference is that the element is provided with a start and end sequence in the same row. The difference between the start and end sequence fields in a row is always one.

CREATE TABLE ELEMENT(
ELEMENT VARCHAR2(10),
START_SEQ NUMBER,
END_SEQ NUMBER
);

INSERT INTO ELEMENT VALUES('A','1','2');
INSERT INTO ELEMENT VALUES('A','2','3');
INSERT INTO ELEMENT VALUES('A','4','5');
INSERT INTO ELEMENT VALUES('A','5','6');
INSERT INTO ELEMENT VALUES('A','6','7');
INSERT INTO ELEMENT VALUES('B','8','9');
INSERT INTO ELEMENT VALUES('B','9','10');
INSERT INTO ELEMENT VALUES('C','11','12');

--step5: 5.2 QUERY#4 find start and end values of a continuous sequence
WITH TEMP AS(
SELECT
ELEMENT, START_SEQ, END_SEQ,
ROW_NUMBER() OVER(PARTITION BY ELEMENT ORDER BY START_SEQ,END_SEQ) AS ELEMENT_SEQ
FROM ELEMENT
),
--add a continuous sequence for each element using ROW_NUMBER analytic function as a separate field

TEMP2 AS(
SELECT
ELEMENT, START_SEQ, END_SEQ,
(START_SEQ - ELEMENT_SEQ) AS START_DIFF
FROM TEMP)
--find the difference between start_seq and the generated continuous sequence field. This difference value will be equal for the rows with continuous start_seq values

SELECT
ELEMENT,
MIN(START_SEQ) AS MIN_SEQ,
MAX(END_SEQ) AS MAX_SEQ
FROM TEMP2
GROUP BY ELEMENT,START_DIFF
ORDER BY ELEMENT;
--In the final step, select the min of start_seq and max of end_seq fields of an element by grouping them on Element and the Difference value