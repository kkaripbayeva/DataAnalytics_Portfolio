/* COVID 19 DATA Exploration
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM CovidDeath
WHERE continent IS NOT ''
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM CovidDeath
WHERE continent IS NOT ''
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelehood of dying if you contract covid in Kazakhstan

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM CovidDeath
WHERE location like 'Kazakhstan'
	AND continent IS NOT ''
ORDER BY 1,2

-- Looking at Total cases vs PopulationCovidDeaths
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PopulationPercentage 
FROM CovidDeath
WHERE location like 'Kazakhstan'
	AND continent IS NOT ''
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population 

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PopulationPercentageInfected 
FROM CovidDeath
WHERE continent IS NOT ''
GROUP BY population, location
ORDER BY PopulationPercentageInfected DESC

-- Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeath
WHERE continent IS NOT ''
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing highest death count per population by continent 

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeath
WHERE continent IS ''
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global numbers 

SELECT date, SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS INT)) AS Total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
FROM CovidDeath
WHERE continent IS NOT ''
--GROUP BY date
ORDER BY 1,2

SELECT * FROM CovidVaccinations

--Total population vs Vaccinations 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeath AS dea
JOIN CovidVaccinations AS vac ON dea.location=vac.location AND to_date(dea.date, 'YYYY-MM-DD')=to_date(vac.date, 'MM/DD/YYYY')
WHERE dea.continent IS NOT ''
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not '' 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

-- creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not '' 
