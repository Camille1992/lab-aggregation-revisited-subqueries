# Lab | Aggregation Revisited - Sub queries
# In this lab, you will be using the Sakila database of movie rentals. 
# You have been using this database for a couple labs already, but if you need to get the data again, refer to the official installation link.

# Instructions
# Write the SQL queries to answer the following questions:
# Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT
	c.first_name, c.last_name, c.email
FROM
	rental r
LEFT JOIN
	customer c ON c.customer_id = r.customer_id
GROUP BY
	r.customer_id;

# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT
	r.customer_id, CONCAT(c.first_name, " ",  c.last_name) AS name, ROUND(AVG(p.amount),2) AS average_payment
FROM
	rental r
LEFT JOIN
	customer c ON c.customer_id = r.customer_id
LEFT JOIN
	payment p ON p.customer_id = r.customer_id
GROUP BY
	r.customer_id;

# Select the name and email address of all the customers who have rented the "Action" movies.
# Write the query using multiple join statements
SELECT
	CONCAT(c.first_name, " ",  c.last_name) AS name, c.email
FROM
	rental r
LEFT JOIN
	customer c ON c.customer_id = r.customer_id
LEFT JOIN
	inventory i ON i.inventory_id = r.inventory_id
LEFT JOIN
	film_category fc ON fc.film_id = i.film_id
LEFT JOIN
	category cat ON cat.category_id = fc.category_id
WHERE
	cat.name = "Action"
GROUP BY
	r.customer_id
ORDER BY
	name ASC;

# Write the query using sub queries with multiple WHERE clause and IN condition
SELECT
	CONCAT(first_name, " ",  last_name) AS name, email
FROM
	(SELECT
		first_name, last_name, email
	FROM
		customer
	WHERE
		customer_id IN (SELECT
							customer_id
						FROM
							rental
						WHERE
							inventory_id IN (SELECT
												inventory_id
											FROM
												inventory
											WHERE
												film_id IN (SELECT
																film_id
															FROM
																film_category
															WHERE
																category_id IN (SELECT 
																					category_id
																				FROM
																					category
																				WHERE
																					name = "Action"))))) AS subs
ORDER BY
	name ASC;
	
# Verify if the above two queries produce the same results or not
	# They do.

# Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
SELECT
	r.customer_id, CONCAT(c.first_name, " ",  c.last_name) AS name, p.amount,
    CASE
		WHEN p.amount <2 THEN 'Low' 
        WHEN p.amount >=2 AND p.amount <4 THEN 'Medium'
        ELSE 'High'
        END AS payment_rating
FROM
	rental r
LEFT JOIN
	customer c ON c.customer_id = r.customer_id
LEFT JOIN
	payment p ON p.customer_id = r.customer_id
ORDER BY
	name ASC, p.amount ASC;