--Tables for visualization using Tableau
--Table 1:
select sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as 'Total Deaths',
sum(CAST(new_deaths as int))/sum(new_cases) *100 as 'Death percentage'
from Portfolio_projects..CovidDeaths$
where continent is not null

--checking the numbers using other way 
--select sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as 'Total Deaths',
--sum(CAST(new_deaths as int))/sum(new_cases) *100 as 'Death percentage'
--from Portfolio_projects..CovidDeaths$
--where location = 'World'

--Table 2:
--continent wise total deathcount
select continent, sum(Convert(int,new_deaths)) as 'Total Death Count'
from Portfolio_projects..CovidDeaths$
where continent is not null
group by continent
Order by [Total Death Count] DESC

--Table 3:
select location, population, max(total_cases) as HighestInfectionCount, (max(total_cases) / population) *100 as HighestInfectedPercentage
from Portfolio_projects..CovidDeaths$
group by location, population
order by HighestInfectedPercentage DESC

--Table 4:
select location, population, date, max(total_cases) as HighestInfectionCount, (max(total_cases) / population) *100 as HighestInfectedPercentage
from Portfolio_projects..CovidDeaths$
group by location, population, date
order by HighestInfectedPercentage DESC
