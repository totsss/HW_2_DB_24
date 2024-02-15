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
-- Explanation:


-- E. For every class type, return its name and whether it has an average rating higher or equal to 7, or lower than 7, in a column named "Rating" with values "Good" or "Bad", respectively.
SELECT Type, name
FROM Type
JOIN Type.name ON Attends.rating = 
WHERE avg(rating) >= 7 or avg(rating) < 7;
-- Explanation: 



-- F. Out of the members that have not quit, member with ID 6976 has been a customer for the shortest time. Out of the members that have not quit, return the ID of the member(s) that have been customer(s) for the longest time.
-- Explanation: 



-- G. How many class types have at least one equipment that costs more than 100.000 and at least one other equipment that costs less than 5.000?
-- Explanation: 



-- H. How many instructors have led a class in all gyms on the same day?
-- Explanation: 



-- I. How many instructors have not led classes of all different class types?
-- Explanation: 



-- J. The class type "Circuit training" has the lowest equipment cost per member, based on full capacity. Return the name of the class type that has the highest equipment cost per person, based on full capacity.
-- Explanation: 



-- K (BONUS). The hacker revealed in query C has left a message for the database engineers. This message may save the database!
-- Return the 5th letter of all members that started the gym on December 24th of any year and have at least 3 different odd numbers in their phone number, in a descending order of their IDs,
-- followed by the 8th letter of all instructors that have not led any "Trampoline Burn" classes, in an ascending order of their IDs.
-- Explanation: 

