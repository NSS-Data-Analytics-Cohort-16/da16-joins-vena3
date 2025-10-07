-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

select specs.film_title AS name,
       release_year,
	   revenue. worldwide_gross AS gross
from   specs
left join revenue 
on specs.movie_id = revenue.movie_id
order by gross;

-- 2. What year has the highest average imdb rating?

select *
from rating

select * 
from specs

select release_year AS year,
       round(avg(imdb_rating), 2) as avg_rating
from specs
inner join rating
on specs.movie_id = rating. movie_id
group by year
order by avg_rating DESC;

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

select *
from distributors

select *
from revenue

select distributors.company_name as company,
       specs.film_title as title,
	   specs.mpaa_rating,
	   revenue. worldwide_gross AS gross
from distributors
inner join specs
on distributors.distributor_id = specs.domestic_distributor_id
inner join revenue
on specs.movie_id = revenue.movie_id
where specs.mpaa_rating = 'G'
limit 1
	   

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

select distributors.company_name as name,
       count(specs.film_title) as number
from distributors 
left join specs
on distributors.distributor_id = specs.domestic_distributor_id
group by name
order by number;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

select distributors.company_name as name,
       round(avg(revenue.film_budget), 0) as highest_budget
from distributors
inner join specs
on distributors.distributor_id = specs.domestic_distributor_id
left join revenue
on specs.movie_id = revenue.movie_id
where revenue.film_budget is not NULL
group by name
order by highest_budget
limit 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

select distributors.company_name as company,
	   headquarters,
	   film_title as title,
	   imdb_rating as imdb	   
from distributors
inner join specs
on distributors.distributor_id = specs.domestic_distributor_id
inner join rating
using (movie_id) 
where headquarters not like '%CA%'
order by imdb_rating DESC;
       

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
select length_in_min
from specs

select case when (specs.length_in_min) > 120 then 'over_2_houra'
            when(specs.length_in_min) <= 120  then 'under_2_houra'
	        end as length_category,
            count(specs.film_title) as movies,
      round(avg(imdb_rating), 2) as avg_rating     
from specs
left join rating
using (movie_id)
where specs.length_in_min is not NULL
group by length_category
order by avg_rating DESC;


-- Bonus Questions

-- 1.	Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. This should result in a table with just one row.

select 
       floor(specs.release_year/10)*10 as decade,
	   round(avg(rating.imdb_rating), 2) as avg_rating,
	   sum(revenue.worldwide_gross) AS total_gross
from  specs
inner join rating 
on specs.movie_id = rating.movie_id
left join revenue
on specs.movie_id = revenue.movie_id
group by decade
order by avg_rating DESC;

	   
 -- 2.	Our goal in this question is to compare the worldwide gross for movies compared to their sequels.   
-- 	a.	Start by finding all movies whose titles end with a space and then the number 2.

select specs.film_title as title
from   specs
where film_title LIKE '% 2%';


-- 	b.	For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. For example, for the film “Cars 2”, the original title would be “Cars”. Hint: You may find the string functions listed in Table 9-10 of https://www.postgresql.org/docs/current/functions-string.html to be helpful for this.

select specs.film_title,
replace (film_title, ' 2', ' ') as film
from  specs
where film_title LIKE '% 2%';



-- 	c.	Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. Modify your query to fix these issues. 

select specs.film_title,
replace (film_title, ' 2', ' ') as film
from  specs
where film_title LIKE '% 2';


-- 	d.	Now, build off of the query you wrote for the previous part to pull in worldwide revenue for both the original movie and its sequel. Do sequels tend to make more in revenue? Hint: You will likely need to perform a self-join on the specs table in order to get the movie_id values for both the original films and their sequels. Bonus: A common data entry problem is trailing whitespace. In this dataset, it shows up in the film_title field, where the movie “Deadpool” is recorded as “Deadpool “. One way to fix this problem is to use the TRIM function. Incorporate this into your query to ensure that you are matching as many sequels as possible.

-- 3.	Sometimes movie series can be found by looking for titles that contain a colon. For example, Transformers: Dark of the Moon is part of the Transformers series of films.  
-- 	a.	Write a query which, for each film will extract the portion of the film name that occurs before the colon. For example, “Transformers: Dark of the Moon” should result in “Transformers”.  If the film title does not contain a colon, it should return the full film name. For example, “Transformers” should result in “Transformers”. Your query should return two columns, the film_title and the extracted value in a column named series. Hint: You may find the split_part function useful for this task.

select film_title,
       case
	       when position(':' in film_title) >0 then split_part(film_title::text, ':', 1)
		   else film_title
		   end as new_title
from specs

 

-- 	b.	Keep only rows which actually belong to a series. Your results should not include “Shark Tale” but should include both “Transformers” and “Transformers: Dark of the Moon”. Hint: to accomplish this task, you could use a WHERE clause which checks whether the film title either contains a colon or is in the list of series values for films that do contain a colon. 

select film_title,
       split_part(film_title::text, ':', 1) as new_title
from specs
where film_title like '%:%'	

-- 	c.	Which film series contains the most installments?

select *
from specs



-- 	d.	Which film series has the highest average imdb rating? Which has the lowest average imdb rating?




-- 4.	How many film titles contain the word “the” either upper or lowercase? How many contain it twice? three times? four times? Hint: Look at the sting functions and operators here: https://www.postgresql.org/docs/current/functions-string.html 

-- 5.	For each distributor, find its highest rated movie. Report the company name, the film title, and the imdb rating. Hint: you may find the LATERAL keyword useful for this question. This keyword allows you to join two or more tables together and to reference columns provided by preceding FROM items in later items. See this article for examples of lateral joins in postgres: https://www.cybertec-postgresql.com/en/understanding-lateral-joins-in-postgresql/ 

-- 6.	Follow-up: Another way to answer 5 is to use DISTINCT ON so that your query returns only one row per company. You can read about DISTINCT ON on this page: https://www.postgresql.org/docs/current/sql-select.html. 

-- 7.	Which distributors had movies in the dataset that were released in consecutive years? For example, Orion Pictures released Dances with Wolves in 1990 and The Silence of the Lambs in 1991. Hint: Join the specs table to itself and think carefully about what you want to join ON. 
