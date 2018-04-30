USE sakila;

-- 1a
SELECT first_name, last_name	-- OK
FROM actor;

-- 1b
SELECT CONCAT(first_name, ' ', last_name) AS actor_name		-- OK
FROM actor;	

-- 2a
SELECT first_name, last_name			-- OK
FROM actor
WHERE first_name LIKE 'Joe%';

-- 2b
SELECT CONCAT(first_name, ' ', last_name)  -- OK
FROM actor
WHERE (lower(last_name) LIKE ('%gen%'));

-- 2c
SELECT first_name, last_name 				-- OK
FROM actor
WHERE (lower(last_name) LIKE ('%li%'))
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country					-- OK
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor							-- OK
  ADD middle_name VARCHAR(20) DEFAULT '';

-- 3b
ALTER TABLE actor							-- OK
	MODIFY COLUMN middle_name BLOB;
    
-- 3c
ALTER TABLE actor							-- OK
	DROP COLUMN middle_name;

-- 4a
SELECT last_name, COUNT(*) AS last_name_count	-- OK
	FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(*) AS last_name_count	-- OK
	FROM actor
GROUP BY last_name
HAVING last_name_count > 1;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';	-- OK

SELECT first_name, last_name
	FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';

-- 4d
UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'Williams';		-- OK

SELECT first_name, last_name
	FROM actor
WHERE first_name = 'MUCHO GROUCHO' AND last_name = 'Williams';

-- 5a
SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS					-- OK
WHERE TABLE_NAME= 'address';

-- 6a
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name, a.address		-- OK
	FROM staff s
		JOIN address a
			ON s.address_id = a.address_id;
        
-- 6b
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name, SUM(p.amount) AS full_expenses  -- OK
	FROM staff s 
		JOIN payment p
			ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 6c
SELECT f.title, COUNT(fa.film_id) AS number_actors		-- OK
	FROM film f 
		JOIN film_actor fa
			ON f.film_id = fa.film_id
GROUP BY f.film_id;

-- 6d
SELECT title, (
	SELECT COUNT(*) 
    FROM inventory i
    WHERE f.film_id = i.film_id) 		-- OK
    AS 'Number of Copies'
FROM film f
WHERE title LIKE 'HUNCHBACK%';

-- 6e
SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name, SUM(p.amount) AS total_amount  -- OK
	FROM customer c 
		JOIN payment p 
			ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC;

-- 7a
SELECT title, (
	SELECT name
		FROM language l
    WHERE f.language_id = l.language_id) 			-- OK
    AS language_used
FROM film f
WHERE (lower(f.title) LIKE 'k%') 
	OR (lower(f.title) LIKE 'q%');
    
-- 7b
SELECT CONCAT(first_name, ' ', last_name) AS full_name			-- works
	FROM actor a 
WHERE a.actor_id IN (
	SELECT actor_id
		FROM film_actor fa
	WHERE fa.film_id IN (
		SELECT film_id
			FROM film f 
		WHERE f.title LIKE 'ALONE%'
	)
);

-- 7c 
SELECT c.first_name, c.last_name, c.email, co.country    -- works
	FROM customer c 
		JOIN address a 
			ON c.address_id = a.address_id
		JOIN city ci
			ON ci.city_id = a.city_id
		JOIN country co 
			ON co.country_id = ci.country_id
		WHERE co.country = 'Canada';
        
-- 7d
SELECT f.title, c.name								-- WORKS
	FROM film f
		JOIN film_category fc
			ON fc.film_id = f.film_id
		JOIN category c 
			ON c.category_id = fc.category_id
            WHERE c.name = 'Family';

-- 7e
SELECT f.title, COUNT(r.inventory_id) AS rent_count			-- WORKS
	FROM film f 
		JOIN inventory i 
			ON f.film_id = i.film_id
		JOIN rental r 
			ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rent_count DESC;

-- 7f
SELECT store.store_id, CONCAT(st.first_name, ' ', st.last_name) AS staff_name, SUM(p.amount) AS total_amount
	FROM store
		JOIN staff st
			ON store.store_id = st.store_id								-- WORKS
		JOIN payment p 
			ON st.staff_id = p.staff_id
GROUP BY st.staff_id;

-- 7g
SELECT s.store_id, a.address, co.country						-- WORKS
	FROM store s 
		JOIN address a 
			ON a.address_id = s.address_id
		JOIN city ci
			ON ci.city_id = a.city_id
		JOIN country co
			ON co.country_id = ci.country_id;
            
-- 7h
SELECT c.name, SUM(p.amount) AS total_amount				-- WORKS
	FROM category c 
		JOIN film_category fc
			ON c.category_id = fc.category_id
		JOIN inventory i 
			ON i.film_id = fc.film_id
		JOIN rental r 
			ON r.inventory_id = i.inventory_id
		JOIN payment p 
			ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER by total_amount DESC
LIMIT 5;

-- 8a
CREATE VIEW top5_gross_revenue AS
SELECT c.name, SUM(p.amount) AS total_amount				-- WORKS
	FROM category c 
		JOIN film_category fc
			ON c.category_id = fc.category_id
		JOIN inventory i 
			ON i.film_id = fc.film_id
		JOIN rental r 
			ON r.inventory_id = i.inventory_id
		JOIN payment p 
			ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER by total_amount DESC
LIMIT 5;

-- 8b 
SELECT * FROM sakila.top5_gross_revenue;  -- done

-- 8c
DROP VIEW sakila.top5_gross_revenue;  -- done