-- question 1
select * from payment 
where amount >= 9.99;
-- question 2
select max(amount)
from payment;
-- max price is 11.99
select rental_id from payment where amount =11.99;
-- rental id's are 14759, 15415, 14763, 16040, 11479, 4383, 3973, 8831
-- question 3
select first_name, last_name, email, address, city, country
from staff s
left join address a
on s.address_id=a.address_id
left join city c
on a.city_id=c.city_id
left join country l
on c.country_id=l.country_id
--question 4
-- Ideally I want to work with data analytics for sports teams. The end goal is statistics and analytics
--relating to the actual sport, but I know that probably comes after working with analytics relating to customers
-- bonus
--looking at country and city
-- a country can have zero or many cities while a city must be mapped to one and only one country.
-- we see the first part by the O< and the second part by the ||