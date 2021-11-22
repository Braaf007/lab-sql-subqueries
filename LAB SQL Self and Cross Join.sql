---- Lab | SQL Subqueries

-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

select i.film_id, f.title, count(f.title)
from inventory i
join film f
on i.film_id = f.film_id
where f.title = 'HUNCHBACK IMPOSSIBLE'
group by i.film_id
order by count(f.title)

-- 2 List all films whose length is longer than the average of all the films.
select * from film 
where length > (select avg(length) from film)

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name , ' ' , last_name) as Actor
from sakila.actor
where actor_id in (
select actor_id
from sakila.film_actor
where film_id = (
select film_id
from sakila.film
where title = 'ALONE TRIP'
;

--- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.film_id, f.category_id, c.name, fm.title
from film_category f
join category c
on f.category_id = c.category_id
join film fm
on f.film_id = fm.film_id
where c.name = 'family'

-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name , ' ' , last_name) as Customer Name, email
from sakila.customer
where address_id in (
select address_id
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id in (
select country_id
from sakila.country
where country = 'Canada'
)
)
);

--- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred

select f.film_id, f.title
from film f
join film_actor fa
on f.film_id = fa.film_id
where actor_id = ( 
select actor_id
from film_actor 
group by actor_id 
order by count(film_id) desc limit 1)

--- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select f.title
from rental r
join inventory i
on r.inventory_id = i.inventory_id
join film f
on f.film_id = i.film_id
where customer_id = (
select customer_id from payment
group by customer_id
order by sum(amount) desc
limit 1)

--- 8 Customers who spent more than the average payments.
select c.customer_id, c.first_name, c.last_name, sum(p.amount) 
from payment p
join customer c
on p.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
having sum(p.amount) >
	(select avg(total_per_customer)
	from (
		select customer_id, sum(amount) as total_per_customer
		from payment
		group by customer_id
		) sub1
	);






