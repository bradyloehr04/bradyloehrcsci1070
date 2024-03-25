--1 
ALTER TABLE rental
ADD COLUMN status VARCHAR(20);

CREATE INDEX idx_rental_inventory_id ON rental (inventory_id);
CREATE INDEX idx_inventory_film_id ON inventory (film_id);

UPDATE rental
SET status = CASE
    WHEN r.return_date > r.rental_date + (f.rental_duration || ' days')::INTERVAL THEN 'Late'
    WHEN r.return_date < r.rental_date + (f.rental_duration || ' days')::INTERVAL THEN 'Early'
    ELSE 'On Time'
END
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

--2
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE ci.city IN ('Kansas City', 'Saint Louis')
GROUP BY c.customer_id, c.first_name, c.last_name;

--3
SELECT category.name AS category_name, COUNT(film.film_id) AS film_count
FROM film_category
JOIN film ON film_category.film_id = film.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

--4
-- the main reason it is important to have separate tables for category and film_category is 
-- that a film can belong to multple genres(categories). this means that if we look at the 
-- crow's foot notation we would see a many to many relationship. separation of these two tables 
-- helps avoid data duplication

--5
SELECT film.film_id, film.title, film.length
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.return_date BETWEEN '2005-05-15' AND '2005-05-31';

--6
SELECT film.film_id, film.title, film.rental_rate
FROM film
JOIN (
    SELECT AVG(rental_rate) AS avg_rental_rate
    FROM film
) AS avg_price ON film.rental_rate < avg_price.avg_rental_rate;

--7
SELECT
    CASE
        WHEN rental_date + film.rental_duration * INTERVAL '1 DAY' < return_date THEN 'Late'
        WHEN rental_date + film.rental_duration * INTERVAL '1 DAY' > return_date THEN 'Early'
        ELSE 'On Time'
    END AS return_status,
    COUNT(*) AS num_films
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY return_status;

--8
WITH FilmDurations AS (
    SELECT
        film_id,
        title,
        length,
        NTILE(100) OVER (ORDER BY length) AS duration_percentile
    FROM film
)
SELECT
    title,
    length,
    duration_percentile
FROM FilmDurations;

--9
--3
EXPLAIN SELECT category.name AS category_name, COUNT(film.film_id) AS film_count
FROM film_category
JOIN film ON film_category.film_id = film.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

-- from this explain plan we see that sequential scans are used on film, category, and film_category
-- additionally, we are using hash joins. We also see there is no cost expense for the the sequential scans

--5
EXPLAIN SELECT film.film_id, film.title, film.length
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.return_date BETWEEN '2005-05-15' AND '2005-05-31';

-- from this explain plan we see that we are again using sequential scans and hash joins,
-- but we are also using a nested loop. Additionally the costs on the non sequential scans
-- are much higher in this chunk than the last, about 5 times as costworthy

-- Bonus
-- Set based programming works on sets of data simultaneously, and performs operations at mass
-- on entire tables. Procedural programming executes data in a step by step manner. The machine
-- performs a given set of tasks in a given order. Procedural programming seems to be much more
-- linear while set based programming is almost directionless.
-- SQL is set based programming while Python is procedural programming.