-- CovidDeaths Table
select distinct continent, location
from [Portfolio Project]..CovidDeaths
order by 1

--CovidVaccinations Table
select *
from [Portfolio Project]..CovidVaccinations



-- select data of interest
select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by 1,2

-- look at total cases vs total deaths -> shows %death per case total over time
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
order by 1,2

-- total cases vs population -> shows what %pop has gotten covid
select location, date, total_cases, population, (total_cases/population)*100 as CasesPerPop
from [Portfolio Project]..CovidDeaths
where location like '%states%'
order by 1,2

-- countries with highest infection rate 
select location, max(total_cases) as MaxInfectionCount, population, max((total_cases/population))*100 as PercentInfected
from [Portfolio Project]..CovidDeaths
group by population, location
order by 4 desc

-- countries with highest death rate
select location, population, max(cast(total_deaths as int)) as TotalDeaths, max((total_deaths/population))*100 as DeathRate
from [Portfolio Project]..CovidDeaths
where continent is not null
group by location, population
order by 3 desc

-- continents with highest death rate
select location, population, max(cast(total_deaths as int)) as TotalDeaths, max((total_deaths/population))*100 as DeathRate
from [Portfolio Project]..CovidDeaths
where continent is null
group by location, population
order by 3 desc

-- global numbers
select sum(new_cases) as CaseCount, sum(cast(new_deaths as int)) as DeathCount, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where continent is null and new_cases <> 0
--group by date
order by 1,2

-- look at total population vs vaccinations, use temp table to allow PercentVaxd operation (cannot perform operation on a new column (PeopleVaxd)
DROP Table if exists #PercentPopulationVaxd
Create Table #PercentPopulationVaxd
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaxd numeric
)
Insert into #PercentPopulationVaxd
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaxd -- sum applies individually to each location & orders them by date --
--, (PeopleVaxd/population)*100 as PercentVaxd
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

Select *, (PeopleVaxd/population)*100 as PercentPeopleVaxd
from #PercentPopulationVaxd

--creating view to store data for later vizualizations
create view PercentPopulationVaxd as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaxd
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
from PercentPopulationVaxd

