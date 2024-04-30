-- TABLE
CREATE TABLE '#PercentPopulationVaccinated'(continent nvarchar(255), location nvarchar(255), date date, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric);
CREATE TABLE 'CovidDeath'('' TEXT,'iso_code' TEXT,'continent' TEXT,'location' TEXT,'date' DATE,'population' TEXT,'total_cases' TEXT,'new_cases' TEXT,'new_cases_smoothed' TEXT,'total_deaths' TEXT,'new_deaths' TEXT,'new_deaths_smoothed' TEXT,'total_cases_per_million' TEXT,'new_cases_per_million' TEXT,'new_cases_smoothed_per_million' TEXT,'total_deaths_per_million' TEXT,'new_deaths_per_million' TEXT,'new_deaths_smoothed_per_million' TEXT,'reproduction_rate' TEXT,'icu_patients' TEXT,'icu_patients_per_million' TEXT,'hosp_patients' TEXT,'hosp_patients_per_million' TEXT,'weekly_icu_admissions' TEXT,'weekly_icu_admissions_per_million' TEXT,'weekly_hosp_admissions' TEXT,'weekly_hosp_admissions_per_million' TEXT);
CREATE TABLE 'CovidDeaths' ('' TEXT,'iso_code' TEXT,'continent' TEXT,'location' TEXT,'date' TEXT,'population' TEXT,'total_cases' TEXT,'new_cases' TEXT,'new_cases_smoothed' TEXT,'total_deaths' TEXT,'new_deaths' TEXT,'new_deaths_smoothed' TEXT,'total_cases_per_million' TEXT,'new_cases_per_million' TEXT,'new_cases_smoothed_per_million' TEXT,'total_deaths_per_million' TEXT,'new_deaths_per_million' TEXT,'new_deaths_smoothed_per_million' TEXT,'reproduction_rate' TEXT,'icu_patients' TEXT,'icu_patients_per_million' TEXT,'hosp_patients' TEXT,'hosp_patients_per_million' TEXT,'weekly_icu_admissions' TEXT,'weekly_icu_admissions_per_million' TEXT,'weekly_hosp_admissions' TEXT,'weekly_hosp_admissions_per_million' TEXT);
CREATE TABLE 'CovidVaccination' ('iso_code' TEXT,'continent' TEXT,'location' TEXT,'date' TEXT,'new_tests' TEXT,'total_tests' TEXT,'total_tests_per_thousand' TEXT,'new_tests_per_thousand' TEXT,'new_tests_smoothed' TEXT,'new_tests_smoothed_per_thousand' TEXT,'positive_rate' TEXT,'tests_per_case' TEXT,'tests_units' TEXT,'total_vaccinations' TEXT,'people_vaccinated' TEXT,'people_fully_vaccinated' TEXT,'new_vaccinations' TEXT,'new_vaccinations_smoothed' TEXT,'total_vaccinations_per_hundred' TEXT,'people_vaccinated_per_hundred' TEXT,'people_fully_vaccinated_per_hundred' TEXT,'new_vaccinations_smoothed_per_million' TEXT,'stringency_index' TEXT,'population_density' TEXT,'median_age' TEXT,'aged_65_older' TEXT,'aged_70_older' TEXT,'gdp_per_capita' TEXT,'extreme_poverty' TEXT,'cardiovasc_death_rate' TEXT,'diabetes_prevalence' TEXT,'female_smokers' TEXT,'male_smokers' TEXT,'handwashing_facilities' TEXT,'hospital_beds_per_thousand' TEXT,'life_expectancy' TEXT,'human_development_index' TEXT);
CREATE TABLE 'CovidVaccinations'('iso_code' TEXT,'continent' TEXT,'location' TEXT,'date' DATE,'new_tests' TEXT,'total_tests' TEXT,'total_tests_per_thousand' TEXT,'new_tests_per_thousand' TEXT,'new_tests_smoothed' TEXT,'new_tests_smoothed_per_thousand' TEXT,'positive_rate' TEXT,'tests_per_case' TEXT,'tests_units' TEXT,'total_vaccinations' TEXT,'people_vaccinated' TEXT,'people_fully_vaccinated' TEXT,'new_vaccinations' TEXT,'new_vaccinations_smoothed' TEXT,'total_vaccinations_per_hundred' TEXT,'people_vaccinated_per_hundred' TEXT,'people_fully_vaccinated_per_hundred' TEXT,'new_vaccinations_smoothed_per_million' TEXT,'stringency_index' TEXT,'population_density' TEXT,'median_age' TEXT,'aged_65_older' TEXT,'aged_70_older' TEXT,'gdp_per_capita' TEXT,'extreme_poverty' TEXT,'cardiovasc_death_rate' TEXT,'diabetes_prevalence' TEXT,'female_smokers' TEXT,'male_smokers' TEXT,'handwashing_facilities' TEXT,'hospital_beds_per_thousand' TEXT,'life_expectancy' TEXT,'human_development_index' TEXT);
 
-- INDEX
 
-- TRIGGER
 
-- VIEW
CREATE VIEW PercentPopulationVaccinated AS 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not '';
 
