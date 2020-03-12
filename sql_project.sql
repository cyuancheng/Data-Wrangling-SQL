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




