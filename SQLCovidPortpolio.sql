select * 
from CovidDeaths
where continent IS not null
order by 3,4

--select * from
--CovidVaccination
--order by 3,4

--select data that we are going to be using


select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2


--looking at total cases vs total deaths
--shows liklihood of dying if you contract Covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%ind%'
order by 1,2


--looking at total cases vs population
--shows what percentage of population got covid

select location,date,population,total_cases,(total_cases/population)*100 as AffectedPopulationPrecentage
from CovidDeaths
where location like '%ind%'
order by 1,2


--looking at countries at hightest infection rate compared to population

select continent,population,MAX(total_cases) as highestinfection,MAX((total_cases/population))*100 as AffectedPopulationPrecentage
from PortfolioProject..CovidDeaths
--where location like '%ind%'
where continent is not null
Group by population,continent
order by AffectedPopulationPrecentage DESC


--showing Continent with highest death count per population

select continent,Max(cast(Total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%ind%'
where continent IS not  null
Group by continent
order by totalDeathCount DESC

--Gloabl numbers

select SUM (new_cases) as total_cases,SUM(cast (new_deaths as int)) as total_deaths,SUM(cast (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%ind%'
where continent is not null
--Group by date
--order by 1,2



--looking at total population vs vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY	dea.location order by dea.location,dea.date) 
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
order by 2,3


--CTE
With popvsvac(continent,location,date,Population,new_vaccinations,RollingPeoplevaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY	dea.location order by dea.location,dea.date) 
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeoplevaccinated/population)*100
from popvsvac
