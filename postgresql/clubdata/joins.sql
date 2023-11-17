-- Retrieve the start times of members' bookings
-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT bks.starttime 
	FROM cd.bookings bks
		INNER JOIN cd.members mems
		ON mems.memid = bks.memid
	WHERE 
		mems.firstname='David' 
		AND mems.surname='Farrell';  

-- Work out the start times of bookings for tennis courts
-- How can you produce a list of the start times for bookings for tennis courts, 
-- for the date '2012-09-21'? 
-- Return a list of start time and facility name pairings, ordered by the time.
SELECT bks.starttime AS start, facs.name AS name
 	FROM cd.facilities facs
		INNER JOIN cd.bookings bks
		ON bks.facid=facs.facid
	WHERE
		facs.facid IN (0,1) AND 
		bks.starttime >= '2012-09-21' AND
		bks.starttime < '2012-09-22'		
	ORDER BY bks.starttime;

-- Produce a list of all members who have recommended another member
-- How can you output a list of all members who have recommended another member?
-- Ensure that there are no duplicates in list, and that results are ordered by (surname, firstname).
SELECT DISTINCT recs.firstname, recs.surname 
	FROM cd.members mems
		INNER JOIN cd.members recs
		ON recs.memid = mems.recommendedby
	ORDER BY recs.surname, recs.firstname;
    
