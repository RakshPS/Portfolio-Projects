------***Covid 19 DATASET FROM 2020-01-01 TO 2022-09-14****------

--SELECT * from dbo.CovidDeaths$ ORDER BY 3,4;
--Select * from dbo.CovidVaccinations$ ORDER by 3,4;
--selecting data that is needed
select location, date, population, total_cases, new_cases, total_deaths
from Portfolio_projects.dbo.CovidDeaths$ 
ORDER BY 1,2

--looking at total_cases vs deaths i.e Death percentage
select location, date, total_cases , total_deaths, Round((total_deaths/total_cases * 100 ), 2) as death_percentage
from Portfolio_projects.dbo.CovidDeaths$
order by 1,2
select distinct location from Portfolio_projects.dbo.CovidDeaths$ where location LIKE 'I%'
select location, date, total_cases , total_deaths, Round((total_deaths/total_cases * 100 ), 2) as death_percentage
from Portfolio_projects.dbo.CovidDeaths$
where location = 'India'
order by death_percentage DESC

-- total cases vs population i.e Affected percentage
select location, date,population, total_cases , Round((total_cases/population *100),2) as affected_percentage
from Portfolio_projects.dbo.CovidDeaths$
--where location LIKE '%india%'
order by 5 DESC

--countries with highest infection rate compared to its population
select location, population, max(total_cases) as highest_infection_count, Round(MAX(total_cases/population *100),2) as highest_percent_of_infection
from Portfolio_projects.dbo.CovidDeaths$
where continent IS NOT NULL
group by location, population
order by highest_infection_count DESC

--countries with highest death rate compared to its population
select location, population, max(total_deaths) as highest_death_count, Round(MAX(total_deaths/population *100),2) as  highest_percent_of_death
from Portfolio_projects.dbo.CovidDeaths$
--where location like '%india%'
group by location, population
order by  highest_percent_of_death DESC

--countries with highest death count per population
select location, max(CAST(total_deaths AS INT)) as Total_deaths
from Portfolio_projects.dbo.CovidDeaths$
where continent IS NOT NULL
group by location
order by Total_deaths DESC

--highest death count by continent
select continent, max(Cast(total_deaths AS INT)) as Total_deaths
from Portfolio_projects.dbo.CovidDeaths$
where continent is not null
group by continent 
ORDER BY Total_deaths DESC

--total cases & death percentage globally 
select sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as 'Total Deaths',
sum(CAST(new_deaths as int))/sum(new_cases) *100 as 'Death percentage'
from Portfolio_projects..CovidDeaths$

--total population vs vaccination 
--temp table
DROP table if exists #Population_of_PeopleVaccination
Create table #Population_of_PeopleVaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #Population_of_PeopleVaccination
select dea.continent, dea.location, dea.date,dea.population , vac.new_vaccinations,
sum(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
as PeopleVaccinated
from Portfolio_projects..CovidDeaths$ dea
join Portfolio_projects..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select *, PeopleVaccinated/Population *100 as Vaccinated_Percentage
from #Population_of_PeopleVaccination

--saving it as view
Create View Population_of_PeopleVaccination as
select dea.continent, dea.location, dea.date,dea.population , vac.new_vaccinations,
sum(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
as PeopleVaccinated
from Portfolio_projects..CovidDeaths$ dea
join Portfolio_projects..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from Population_of_PeopleVaccination

--view2
Create View Global_stats as
select sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as 'Total Deaths',
sum(CAST(new_deaths as int))/sum(new_cases) *100 as 'Death percentage'
from Portfolio_projects..CovidDeaths$
select * from Global_stats
