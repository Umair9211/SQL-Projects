
Use portfolioProject
Select Location,date,total_cases,new_cases,total_deaths,population from CovidDeaths
order by 1,2
--Looking at Total Cases/Total Death(Show likelihood of dying if you have covid in your country)
Select Location,date,total_cases,total_deaths
,(total_deaths/total_cases)*100 as deathCasesRatio
from CovidDeaths
where location  = 'Pakistan'
order by 1,2

--Looking at total cases/Population
--Seeing what percentage have covid
Select Location,date,total_cases,population
,(total_cases/population)*100 as PopulationCasesRatio
from CovidDeaths
where location  = 'Pakistan'
order by 1,2
--Looking at countries with highest Infection Rate
Select Location,population, max(total_cases) as HighestInfectionCount
,max((total_cases/population)*100) as PercentangePopulationInfected
from CovidDeaths
group by Location,population
order by PercentangePopulationInfected desc
--Looking at countries with highest Death count per population
Select Location ,max(cast(total_deaths as int)) as totalDeathCount
from CovidDeaths
where continent is not null
group by Location
order by totalDeathCount desc
--Let Do with Continent
Select continent ,max(cast(total_deaths as int)) as totalDeathCount
from CovidDeaths
where continent is  null
group by continent
order by totalDeathCount desc


-- showing continenet with highest death count per population
Select location ,max(cast(total_deaths as int)) as totalDeathCount
from CovidDeaths
where continent is  null
group by location
order by totalDeathCount desc;

--Calculate GLobal Number
Select date,sum(new_cases) as newCases,sum(cast(new_deaths as int)) as NewDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage

from CovidDeaths
where continent is not null
group by date
order by 1,2

Select sum(new_cases) as newCases,sum(cast(new_deaths as int)) as NewDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2

--Looking at total Population vs vaccination
with PopvsVac(Continent,Location,Date,Population,new_vaccination,PerDateVaccinationCount)
as (
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.Date)
as PerDateVaccinationCount
from CovidDeaths dea inner join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
Select *,(PerDateVaccinationCount/Population)*100 from PopvsVac

--TempTable
drop table if exists #VaccinationPerPopulationcount
Create table #VaccinationPerPopulationcount(
Continent varchar(50),
location varchar(100),
Date date,
Population numeric,
new_vaccinations numeric,
PerDateVaccinationCount numeric
)
INsert into #VaccinationPerPopulationcount
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.Date)
as PerDateVaccinationCount
from CovidDeaths dea inner join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

Select *,(PerDateVaccinationCount/Population)*100 from #VaccinationPerPopulationcount;

-- Create view for visualitation

Create View PopulationVacinatedPercentage as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.Date)
as PerDateVaccinationCount
from CovidDeaths dea inner join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

Select * from PopulationVacinatedPercentage