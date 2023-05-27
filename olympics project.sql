create database olympic_database;
update olympic_history set Medal=NULL where medal='NA'
use olympic_database;
select * from olympic_history;
select count(ID) from olympic_history
--1. How many olympics games have been held?
select count(distinct(games)) as Total_olympic_games from olympic_history;

--2. List down all Olympics games held so far.
select distinct year,season,city from olympic_history
order by year;

--3. Mention the total no of nations who participated in each olympics game?
with all_countries as(
select olympic_history.games,r.region from olympic_history
join regions r on olympic_history.noc=r.noc
group by games,r.region)
select games, count(region) as Total_Participated_countries from all_countries
group by games
order by games;

--4. Which year saw the highest and lowest no of countries participating in olympics

with countries as(
	select games, count(distinct r.region) as number_of_participants
	from olympic_history oh
	join regions r on r.NOC=oh.NOC
	group by oh.Games)
select concat(max(Games),' - ',max(number_of_participants))as Lowest_countries,
concat(min(Games),' - ',min(number_of_participants))as Highest_countries
from countries c;

--5. Which nation has participated in all of the olympic games
WITH participated_by_years as(
	select oh.games,r.region
	from olympic_history oh
	join regions r on r.NOC=oh.NOC
	group by oh.games,region
)
select region from participated_by_years
group by region
having count(region) =(select count(distinct games) from olympic_history);

--6. Identify the sport which was played in all summer olympics.
with sports_in_olympic as(
	select distinct games,sport 
	from olympic_history
	where Season='Summer')

select sport from sports_in_olympic
group by Sport
having count(sport)= (select count(distinct games) from olympic_history
where Season='Summer');

--7 Which Sports were just played only once in the olympics.
SELECT distinct sport, Games
FROM olympic_history
WHERE sport IN (
    SELECT sport
    FROM olympic_history
    GROUP BY sport
    HAVING COUNT(DISTINCT Games) = 1
)
order by sport;


--8. Fetch the total no of sports played in each olympic games.
select games ,count(games) as games_played from
(select distinct games,sport
from olympic_history) oh
group by games
order by games_played desc;

--9. Fetch oldest athletes to win a gold medal.
with gold_in_olympic as(
	select * 
	from olympic_history
	where medal='Gold')
select * from gold_in_olympic 
where age=(select max(age) from gold_in_olympic);


--10. Fetch the top 5 most successful countries in olympics.
--    Success is defined by no of medals won.
with most_medals_by_countries as(
select r.region,count(medal) as Total_medals
from olympic_history oh
join regions r on r.NOC=oh.NOC
where Medal<>'NA'
group by r.region)

select * from (select *,dense_RANK() OVER(order by total_medals desc) as rnk
from most_medals_by_countries) as ranked
where rnk <6;



--11. Fetch the top 5 athletes who have won the most gold medals.
with t1 as(
select id, name,count(Medal) as gold_medal_won
from olympic_history
where medal='Gold'
group by id,name
)
select * from(
select *,dense_Rank() over(order by gold_medal_won desc)as rnk
from t1) ranked
where rnk<=5
order by rnk;

--12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
WITH t2 as(
select id, name,Team,count(Medal) as medals_won
from olympic_history
group by id,name,team
)
select * from (
select *,dense_Rank() over(order by medals_won desc)as rnk
from t2) as ranked
where rnk<=5;

--13. List down total gold, silver and bronze medals won by each country.
with gold_won as(
select r.region,count(medal) as Gold
from olympic_history oh
join regions  r on r.NOC=oh.NOC
where medal='Gold'
group by r.region),

silver_won as(
select r.region,count(medal) as silver
from olympic_history oh
join regions  r on r.NOC=oh.NOC
where medal='Silver'
group by r.region),

bronze_won as(
select r.region,count(medal) as bronze
from olympic_history oh
join regions  r on r.NOC=oh.NOC
where medal='bronze'
group by r.region)

select g.region,g.gold,s.silver,b.bronze
from gold_won g
join silver_won s on s.region=g.region 
join bronze_won b on b.region=s.region
order by g.Gold desc;


--14. List down total gold, silver and bronze medals won by each country 
--  corresponding to each olympic games.
with gold_won as(
select oh.Games,r.region,count(medal) as Gold
from olympic_history oh
join regions  r on r.NOC=oh.NOC
where medal='Gold'
group by Games,r.region),

silver_won as(
select oh.Games,r.region,count(medal) as silver
from olympic_history oh
join regions r on r.NOC=oh.NOC
where medal='Silver'
group by oh.Games,r.region
),

bronze_won as(
select oh.Games,r.region,count(medal) as bronze
from olympic_history oh
join regions  r on r.NOC=oh.NOC
where medal='bronze'
group by oh.Games,r.region)

select g.Games,g.region,g.gold,s.silver,b.bronze
from gold_won g
join silver_won s on s.region=g.region 
join bronze_won b on b.region=s.region
order by g.Games;

--15 Identify which country won the most gold,
--most silver, most bronze medals and the most medals in each olympic games.
with golds_by_countries as(select games,gold_won,region from
(select games,count(medal) as gold_won,r.region,
ROW_NUMBER() over(partition by games order by count(medal) desc)as row_num from olympic_history oh
join regions r on r.NOC= oh.NOC
where medal='gold' 
group by region,Games)as subquery
where row_num=1),

silver_by_countries as(select games,silver_won,region from
(select games,count(medal) as silver_won,r.region,
ROW_NUMBER() over(partition by games order by count(medal) desc)as row_nu from olympic_history oh
join regions r on r.NOC= oh.NOC
where medal='silver'
group by games,region)as subquery
where row_nu=1),

bronze_by_countries as(select games,bronze_won,region from
(select games,count(medal) as bronze_won,r.region,
ROW_NUMBER() over(partition by games order by count(medal) desc)as row_numb from olympic_history oh
join regions r on r.NOC= oh.NOC
where medal='bronze'
group by games,region)as subquery
where row_numb=1),

max_medals as( select games,medals_won,region from
(select games,count(medal) as medals_won,r.region,
ROW_NUMBER() over(partition by games order by count(medal) desc)as row_numb 
from olympic_history oh
join regions r on r.NOC= oh.NOC
where Medal ='Gold' or medal='silver' or medal='bronze'
group by games,region)as subquery
where row_numb=1)

select g.games,
concat((g.region),'-',(g.gold_won))as max_gold,
CONCAT((s.region),'-',(s.silver_won))as max_silver,
CONCAT((b.region),'-',(b.bronze_won))as max_bronze,
CONCAT((m.region),'-',(m.medals_won))as max_medals
from golds_by_countries g
join silver_by_countries s on s.games = g.games
join bronze_by_countries b on b.games =g.games
join max_medals m on m.Games=g.Games
group by g.Games,g.region,g.gold_won,s.region,s.silver_won,
b.region,b.bronze_won,m.region,m.medals_won
order by Games


-- 16 countries have never won gold medal but have won silver/bronze medals?
with gold_won as(select distinct region from regions
where region not in ( select distinct r.region from olympic_history
join regions r on r.NOC= olympic_history.NOC
where medal='gold'
group by r.region
)),
silver_won as(select r.region,count(medal) as Total_silver from regions r
join olympic_history oh on r.NOC=oh.NOC
where medal='Silver' and r.region in (select region from gold_won)
group by r.region
),
bronze_won as(select r.region,count(medal) as Total_bronze from olympic_history oh
join regions r on r.NOC=oh.NOC
where medal='Bronze' and r.region in (select region from gold_won)
group by r.region
)

select g.region,s.Total_silver,b.Total_bronze
from  gold_won g
left join silver_won s on s.region=g.region
left join bronze_won b on b.region=g.region
where (Total_silver is not null or Total_bronze is not null)
order by s.Total_silver desc;

--17 In which Sport/event, India has won highest medals.
select sport from (select sport,ROW_NUMBER() over(order by count(games) desc)as rnk
from olympic_history oh
join regions r on r.NOC=oh.NOC
where r.region='INDIA' and oh.Medal is not null
group by Sport)as medals_won
where rnk=1;


 --18 Find the Ratio of male and female athletes participated in all olympic games
select
	count(case when sex='M' then 1 end)as male_counts,
	count(case when sex='F' then 1 end)as female_counts,
	concat('1 : ',count(case when sex='M' then 1 end) *1.0/count(case when sex='F'then 1 end))as ratio
from olympic_history;

;



