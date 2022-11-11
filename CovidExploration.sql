-- view CovDeaths table
select *
from [Portfolio Project]..CovDeaths
order by 1,2,3

-- view all countries (location), note grouped locations (EU, NA/SA, etc = #9)
select distinct continent, location
from [Portfolio Project]..CovDeaths
order by 1,2

-- view CovVax table
select *
from [Portfolio Project]..CovVax
order by 1,2

-- total cases vs total deaths & show %death per population over time
select location, date, total_cases, total_deaths, population, (total_deaths/population)*100 as DeathPercent
from [Portfolio Project]..CovDeaths
order by 1,2

-- total cases vs population --> what %pop has gotten covid over time
select location, date, total_cases, population, (total_cases/population)*100 as PercentInfected
from CovDeaths
order by 1,2

-- TABLE1 show total death percentage 
select sum(new_cases) as CaseCount, sum(cast(new_deaths as int)) as DeathCount, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovDeaths
where continent is null and new_cases <> 0 -- removes grouped locations from calculation (EU, NA, etc.)
order by 1,2

-- TABLE2 continents with highest covid deaths respective to population
select location, population, max(cast(total_deaths as int)) as TotalDeaths, max((total_deaths/population))*100 as CovDeathPercent
from [Portfolio Project]..CovDeaths
where continent is null
and location not in ('World', 'European Union', 'International') and location not like '%income'  -- filtering down just to continents
group by location, population
order by 4 desc

-- TABLE3 countries with highest infection rate
select location, max(total_cases) as MaxInfectionCount, population, max((total_cases/population))*100 as PercentInfected
from [Portfolio Project]..CovDeaths
group by population, location
order by 4 desc

-- TABLE4 %infected per country, over time
select location, date, max(total_cases) as MaxInfectionCount, max((total_cases/population))*100 as PercentInfected
from [Portfolio Project]..CovDeaths
group by population, location, date
order by 4 desc, 2 desc

-- look at total population vs vaccinations, use temp table to allow PercentVaxd operation (cannot perform operation on a new column (PeopleVaxd))
DROP Table if exists #PercentPopulationVaxd
Create Table #PercentPopulationVaxd
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
VaccinationsGiven numeric
)
Insert into #PercentPopulationVaxd
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as VaccinationsGiven -- sum applies individually to each location & orders them by date --
from [Portfolio Project]..CovDeaths dea
join [Portfolio Project]..CovVax vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--using temp table from above to calculate new column
Select *, (VaccinationsGiven/population)*100 as PercentVaxd
from #PercentPopulationVaxd
order by 1,2,3

--creating view to store data for later vizualizations
create view PercentPopulationVaxd as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaxd
from [Portfolio Project]..CovDeaths dea
join [Portfolio Project]..CovVax vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
from PercentPopulationVaxd


