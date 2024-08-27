SELECT *
FROM [Portfolio Project].dbo.CovidDeaths
where continent is not null;

SELECT location, date, total_cases,new_cases,total_deaths,population
from [Portfolio Project].dbo.CovidDeaths
order by 1,2;

--Looking for Total cases VS Total deaths

SELECT location, date, total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
where location like '%kenya%'
order by 1,2;

-- Looking for Total cases vs Population
-- Shows the percentage of population that got covid

SELECT location, date,population, total_cases,(total_cases/population)*100 as Percentage_of_Population_Infected
from [Portfolio Project].dbo.CovidDeaths
where location like '%kenya%'
order by 1,2;

--Looking at the country with the most cases

SELECT location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Max_Percentage_of_Total_Cases
from [Portfolio Project].dbo.CovidDeaths
--where location like '%kenya%'
Group by location,population
order by Max_Percentage_of_Total_Cases desc;

--Looking for countries with highest deaths per population

SELECT location,MAX(cast (total_deaths as int)) as Total_Death_Count
from [Portfolio Project].dbo.CovidDeaths
--where location like '%kenya%'
Where continent is not null
Group by location
order by Total_Death_Count desc;

-- Looking at continents with highest death count

SELECT continent,MAX(cast (total_deaths as int)) as Total_Death_Count
from [Portfolio Project].dbo.CovidDeaths
--where location like '%kenya%'
Where continent is not null
Group by continent
order by Total_Death_Count desc;

--Showing Total Population vs vaccination

SELECT dea.continent,dea.location,dea.date,dea.population
, SUM(cast(dea.new_cases as int)) OVER (partition by dea.location order by dea.location,vac.date) as Rolling_Cases
FROM [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3