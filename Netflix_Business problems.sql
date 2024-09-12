use netflix;

drop table netflixdata;

create table netflixdata
(show_id varchar(5),
types varchar(10), 
title varchar(120),
director varchar(250),
casts varchar(800),
country varchar(150),
date_added varchar(25),
release_year int,
rating varchar(10),
duration varchar(20),
listed_in varchar(100),
descriptions varchar(300));

-- 1. Count the number of Movies vs TV Shows

select types, count(types)
from netflixdata
group by types;

-- 2. Find the most common rating for movies and TV shows

select types, rating
from
(select types, rating, count(rating), rank() over(partition by types order by count(rating) desc) as ranking
from netflixdata
group by types, rating) as t1
where ranking =1;

-- 3. List all movies released in a specific year (e.g., 2020)

select release_year, title
from netflixdata
where types = "movie" and release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

select
country, count(country) as total_content
from netflixdata
group by country
order by total_content desc
limit 5;

-- 5. Identify the longest movie

select *
from netflixdata
where types= "movie" and duration = (select max(duration) from netflixdata);

-- 6. Find content added in the last 5 years

SELECT title, date_added
FROM netflixdata
WHERE EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) >= YEAR(NOW()) - 5;

-- 7. List all TV shows with more than 5 seasons

select *
from netflixdata
where types= "tv show" and duration like "% season%"
and cast(substring_index(duration, " ",1) as unsigned)>5;

-- 8. Count the number of content items in each genre

select substring_index(listed_in, ",", 1) as Genre, count(*) as "No. of content"
from netflixdata
group by genre;

-- 9. List all movies that are documentaries

select	*
from netflixdata
where listed_in like "%documentaries%";

-- 10. Find all content without a director

select	*
from netflixdata
where director = '' or director is null;

-- 11. Find how many movies actor 'Jitendra Kumar' appeared in last 10 years!

select *
from netflixdata
where casts like "%Jitendra Kumar%"
and release_year > year(now()) -10;

-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select substring_index(casts, ",", 1), count(*) from netflixdata
where country like "%india%"
group by 1
order by 2 desc
limit 10;

-- 13. Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

select category, types, count(*) as content_count
From
(select *, 
case 
when descriptions like "kill" or descriptions like "violence" then "BAD"
else "Good"
end as category
from netflixdata) as category_content
group by 1, 2
order by 2;




