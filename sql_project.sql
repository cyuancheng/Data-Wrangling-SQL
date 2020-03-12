/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name, membercost
FROM country_club.Facilities
WHERE membercost !=0
ORDER BY name

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) AS count_no_fee
FROM country_club.Facilities
WHERE membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM country_club.Facilities
WHERE membercost > 0
AND membercost / monthlymaintenance < 0.2

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM country_club.Facilities
WHERE facid
IN (1, 5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
  CASE WHEN monthlymaintenance >100 THEN 'expensive' 
  ELSE 'cheap'END AS label
FROM country_club.Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT surname, firstname, MAX(joindate) AS last_date
FROM country_club.Members

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT f.name, 
CONCAT(m.firstname, ' ',m.surname) AS member_name 

FROM country_club.Bookings b
JOIN country_club.Members m 
ON b.memid = m.memid
JOIN country_club.Facilities f 
ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
ORDER BY member_name 

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility,
	CONCAT( m.firstname,  ' ', m.surname ) AS member_name,
	CASE WHEN m.memid = 0 THEN b.slots*f.guestcost 
	ELSE b.slots*f.membercost END AS cost
FROM country_club.Bookings b
JOIN country_club.Members m 
ON b.memid = m.memid
JOIN country_club.Facilities f 
ON b.facid = f.facid

WHERE b.starttime >= '2012-09-14' AND b.starttime < '2012-09-15' AND ((m.memid = 0 AND b.slots*f.guestcost > 30) OR (m.memid != 0 AND b.slots*f.membercost > 30))
ORDER BY cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT facility, member_name, cost FROM (
    	SELECT f.name AS facility,
		CONCAT(m.firstname, ' ', m.surname) AS member_name,
	CASE WHEN m.memid = 0 THEN b.slots*f.guestcost 
		ELSE b.slots*f.membercost END AS cost
	FROM country_club.Bookings b
	JOIN country_club.Members m 
		ON b.memid = m.memid
	JOIN country_club.Facilities f 
		ON b.facid = f.facid
	WHERE b.starttime >= '2012-09-14' AND b.starttime < '2012-09-15' 
) as bookings
WHERE COST > 30
ORDER BY cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT f.name, SUM(b.slots * (
CASE WHEN b.memid = 0 THEN f.guestcost 
    ELSE f.membercost END)) AS revenue
FROM country_club.Bookings AS b
JOIN country_club.Facilities AS f 
ON b.facid = f.facid

GROUP BY f.name
HAVING revenue < 1000
ORDER BY revenue

