-- HW2
--RENAME FILE TO QUERIES.sql when complete
-- Student names:Ísak, viktor Wardum, Þórður Jónatansson

-- A. 447 different members attended at least one class on January 10th. How many different members attended at least one class on January 15th? select * from audit_logs where created_date = '2018-11-28';
SELECT COUNT(DISTINCT attends.MID) AS unique_members
FROM attends
JOIN class ON attends.CID = class.ID
WHERE class.date = '2023-01-15';
-- Explanation: Count the DISTINCT members (this is needed) then join to get right ID, and check if the date 2023-01-15 is in the table.



-- B. 4 different class types require more than 20 light dumbbells. How many class types require more than 20 yoga mats?
SELECT count(DISTINCT(Type.ID))
FROM Type
JOIN Needs ON Type.ID = Needs.TID
JOIN Equipment ON Needs.EID = Equipment.ID
WHERE LOWER(Equipment.name) ='yoga mat'
AND Needs.quantity > 20;
-- Explanation: 



-- C. Oh no! Some member hacked the database and is still attending classes but has quit according to the database. Write a query to reveal their name!
SELECT DISTINCT Member.ID, Member.name
FROM Member
JOIN Attends ON Member.ID = Attends.MID
JOIN Class ON Attends.CID = Class.ID
WHERE Member.quit_date IS NOT NULL AND Class.date > Member.quit_date;
-- Explanation: We can use the fact that dates can be used with the "< >" to check if dates are after or berfore (bigger or smaller). After joining the members so we have Attending members we check if the date of student x attendence is larger than the quit date wich gives us their name if so is true.

-- D. How many members have a personal trainer with the same first name as themselves, but have never attended a class that their personal trainer led?
SELECT COUNT(DISTINCT Member.ID)
FROM Member
JOIN Instructor ON Member.IID = Instructor.ID
WHERE split_part(Member.name, ' ', 1) = split_part(Instructor.name, ' ', 1)
AND NOT EXISTS (
    SELECT 1
    FROM Attends
    JOIN Class ON Attends.CID = Class.ID
    WHERE Class.IID = Instructor.ID AND Attends.MID = Member.ID
);
-- Explanation: First i count DISTINCT members, then i join them with the instructors to get a table with both instructors and memers to check the names later, then i split the names on ( ' ', 1) wich will give us the first names for both, then we check if anything exists in attends that has a Member ID and a Instrucor ID.


-- E. For every class type, return its name and whether it has an average rating higher or equal to 7, or lower than 7, in a column named "Rating" with values "Good" or "Bad", respectively.
WITH ClassesAndRatings AS (
    SELECT Type.name, AVG(Attends.rating) AS avg_rating
    FROM Attends
    JOIN Class ON Attends.CID = Class.ID
    JOIN Type ON Class.TID = Type.ID
    GROUP BY Type.name
)
SELECT name,
       CASE 
           WHEN avg_rating >= 7 THEN 'Good'
           ELSE 'Bad'
       END AS good_or_bad
FROM ClassesAndRatings;
-- Explanation: all Classes are saved to ClassesAndRatings along with a average rating then i use a case clause wich was very helpfull to differentiate between Good and Bad ratings 
--My initial thougt was to make a ClassesAndRatings and calculate the average in the end but i could not and was stuck for some time.



-- F. Out of the members that have not quit, member with ID 6976 has been a customer for the shortest time. Out of the members that have not quit, return the ID of the member(s) that have been customer(s) for the longest time.
WITH HasNotQuit AS (
    SELECT ID, start_date
    FROM Member
    WHERE quit_date IS NULL
)
SELECT (ID)
FROM HasNotQuit
WHERE start_date = (SELECT MIN (start_date) FROM HasNotQuit);
-- Explanation: Filtered members that have not quit using NULL and saving it as HasNotQuit then checked the mininmum start date in HasNotQuit wich will give us the person/s that start the earliest wich will conveniently give us the person/s that have been a member the longest

-- G. How many class types have at least one equipment that costs more than 100.000 and at least one other equipment that costs less than 5.000?
SELECT COUNT(DISTINCT Type.ID)
FROM Type
WHERE EXISTS (
    SELECT 1 
    FROM Needs 
    JOIN Equipment ON Needs.EID = Equipment.ID 
    WHERE Needs.TID = Type.ID AND Equipment.price > 100000
)
AND EXISTS (
    SELECT 1 
    FROM Needs 
    JOIN Equipment ON Needs.EID = Equipment.ID 
    WHERE Needs.TID = Type.ID AND Equipment.price < 5000
);

-- Explanation: 



-- H. How many instructors have led a class in all gyms on the same day?
WITH TotalGyms AS (
    SELECT COUNT(DISTINCT ID) AS total_gyms FROM Gym
),
--Class table (which includes instructor ID, gym ID, and date)
TotalGymsTaughtPerInstructorOnDay AS (
    SELECT Class.IID, Class.date, COUNT(DISTINCT Class.GID) AS total_gyms_taught_per_instructor_on_day
    FROM Class
    GROUP BY Class.IID, Class.date
)
SELECT COUNT(DISTINCT IID)
FROM TotalGymsTaughtPerInstructorOnDay
WHERE total_gyms_taught_per_instructor_on_day = (SELECT total_gyms FROM TotalGyms);
-- Explanation: It was very easy to use the knowlage from I to do change I to the correct answer for H



-- I. How many instructors have not led classes of all different class types?
WITH TotalTypesOfClasses AS(
    SELECT COUNT(DISTINCT ID) AS total_types_of_classes FROM Type

),TotalTypesOfClassesTaught AS(
    SELECT IID, COUNT(DISTINCT TID) AS total_types_of_classes_taught
FROM Class
GROUP BY IID
)
SELECT COUNT(*) 
FROM TotalTypesOfClassesTaught
WHERE total_types_of_classes_taught < (SELECT total_types_of_classes FROM TotalTypesOfClasses);
-- Explanation:TotalTypesOfClasses counts the obvious, TotalTypesOfClassesTaught aslo counts the obvious then they are compared using the < opperator, to check if the types of classes taught are are fewer than the type of class each instructor has taught if true it counts 1 instructor, then the next and the next, 

--first i tried to do it the other way around and it never worked, I struggled for a long time trying to use convetional joins and i find this method easier 



-- J. The class type "Circuit training" has the lowest equipment cost per member, based on full capacity. Return the name of the class type that has the highest equipment cost per person, based on full capacity.
SELECT Type.name, MAX(Equipment.price / Type.capacity) AS MaxPricePerCappacity
FROM Class
JOIN Type ON Class.TID = Type.ID
JOIN Needs ON Type.ID = Needs.TID
JOIN Equipment ON Needs.EID = Equipment.ID
GROUP BY Type.name
ORDER BY MaxPricePerCappacity DESC
LIMIT 1;
-- Explanation: I select the Equipment price and devide it by how many people are allowed in the Type of excersise, i then join the tables from type to class to needs and all the way to Equipment, now i have a table containing all the info i need, to display the, as MaxPricePerCappacity



-- K (BONUS). The hacker revealed in query C has left a message for the database engineers. This message may save the database!
-- Return the 5th letter of all members that started the gym on December 24th of any year and have at least 3 different odd numbers in their phone number, in a descending order of their IDs,
-- followed by the 8th letter of all instructors that have not led any "Trampoline Burn" classes, in an ascending order of their IDs.
-- Explanation: 

