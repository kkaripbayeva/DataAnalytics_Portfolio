/* COVID 19 DATA Exploration
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelehood of dying if you contract covid in Kazakhstan

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM dbo.CovidDeaths
WHERE location like 'Kazakhstan'
	AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total cases vs PopulationCovidDeaths
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, (CAST(total_cases AS float)/population)*100 AS PopulationPercentage 
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population 

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((CAST(total_cases AS float)/population)*100) AS PopulationPercentageInfected 
FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
GROUP BY population, location
ORDER BY PopulationPercentageInfected DESC

-- Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing highest death count per population by continent 

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global numbers 

SELECT /*date,*/ SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS INT)) AS Total_deaths, (SUM(CAST(new_deaths AS float))/SUM(new_cases))*100 AS DeathPercentage
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

SELECT * FROM dbo.CovidVaccinations

--Total population vs Vaccinations 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac ON dea.location=vac.location AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--order by 2,3
)
SELECT *, (CAST(RollingPeopleVaccinated AS float)/Population)*100 AS PercentageRollingPeopleVaccinated
FROM PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

SELECT *, (CAST(RollingPeopleVaccinated AS float)/Population)*100 AS PercentageRollingPeopleVaccinated
FROM #PercentPopulationVaccinated

-- creating view to store data for later visualizations

CREATE VIEW PercentofPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION by dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

--Tableau Table 1
SELECT /*date,*/ SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS INT)) AS Total_deaths, (SUM(CAST(new_deaths AS float))/SUM(new_cases))*100 AS DeathPercentage
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--Tableau Table 2
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent IS NULL
	AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC

--Tableau Table 3
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((CAST(total_cases AS float)/population)*100) AS PopulationPercentageInfected 
FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
GROUP BY population, location
ORDER BY PopulationPercentageInfected DESC

-- Tableau Table 4
SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX((CAST(total_cases AS float)/population)*100) AS PopulationPercentageInfected 
FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY PopulationPercentageInfected DESC
