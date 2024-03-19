--1
SELECT *
FROM customer
WHERE last_name LIKE 'T%'
ORDER BY first_name;

--2
SELECT *
FROM rental
WHERE return_date BETWEEN '2005-05-28' AND '2005-06-01';

--3
SELECT title, COUNT(*) AS rental_count
FROM film
GROUP BY title
ORDER BY rental_count DESC
LIMIT 10;

--4
SELECT customer_id, SUM(amount) AS total_amount_paid
FROM payment 
GROUP BY customer_id
ORDER BY total_amount_paid ASC;

--5
SELECT 
    a.actor_id, 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(*) AS movie_count
FROM 
    film_actor fa
JOIN 
    film f ON fa.film_id = f.film_id
JOIN 
    actor a ON fa.actor_id = a.actor_id
WHERE 
    f.release_year = 2006
GROUP BY 
    a.actor_id, a.first_name, a.last_name
ORDER BY 
    movie_count DESC;
	
--6
-- for 4
EXPLAIN SELECT customer_id, SUM(amount) AS total_amount_paid
FROM payment 
GROUP BY customer_id
ORDER BY total_amount_paid ASC;

-- for 5
EXPLAIN SELECT 
    a.actor_id, 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(*) AS movie_count
FROM 
    film_actor fa
JOIN 
    film f ON fa.film_id = f.film_id
JOIN 
    actor a ON fa.actor_id = a.actor_id
WHERE 
    f.release_year = 2006
GROUP BY 
    a.actor_id, a.first_name, a.last_name
ORDER BY 
    movie_count DESC;

--7
SELECT c.name,
       AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

--8
SELECT c.name AS category_name,
       COUNT(*) AS total_rentals,
       SUM(f.rental_rate) AS total_sales
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY total_rentals DESC
LIMIT 5;

--Bonus
SELECT 
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    c.name AS category_name,
    COUNT(*) AS total_rentals
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film_category fc ON i.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    EXTRACT(MONTH FROM r.rental_date), c.name
ORDER BY 
    EXTRACT(MONTH FROM r.rental_date), total_rentals DESC;