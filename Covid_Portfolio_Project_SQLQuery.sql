SELECT *
FROM Portfolio_Project..Covid_death$
ORDER BY 3,4

--select data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_death$
ORDER BY 1,2

-- finding total_cases vs total_deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate
FROM Portfolio_Project..Covid_death$
WHERE location like '%Bangladesh%'
ORDER BY 1,2

--finding total_cases vs populations

SELECT location, date, total_cases, population, (total_cases/population)*100 AS infection_rate
FROM Portfolio_Project..Covid_death$
WHERE location like '%Bangladesh%'
ORDER BY 1,2

--finding countries with highest infection rate compare to population

SELECT location,population, MAX(total_cases) AS highest_infection_count,  MAX((total_cases/population))*100 AS infection_rate
FROM Portfolio_Project..Covid_death$
GROUP BY location, population
ORDER BY infection_rate desc

--finding countries with highest infection rate compare to population according to date

SELECT location,population,date, MAX(total_cases) AS highest_infection_count,  MAX((total_cases/population))*100 AS infection_rate
FROM Portfolio_Project..Covid_death$
GROUP BY location, population,date
ORDER BY infection_rate desc

--finding countries with highest death_rate

SELECT location,MAX(cast(total_deaths AS int)) AS total_death_count
FROM Portfolio_Project..Covid_death$
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count desc


--let's break things down by continent

SELECT location,MAX(cast(total_deaths AS int)) AS total_death_count
FROM Portfolio_Project..Covid_death$
WHERE continent is null
and location not in ('World','European Union','International','Upper middle income','High income','Lower middle income','Low income')
GROUP BY location
ORDER BY total_death_count desc

-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as golbal_death_rate
FROM Portfolio_Project..Covid_death$
WHERE continent is not null
ORDER BY 1,2

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Portfolio_Project..Covid_death$ dea
Join Portfolio_Project..Covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

--due to limitation of bytes approching new way

SELECT continent, location, date, population, new_vaccinations,SUM(new_vaccinations) OVER (Partition by location Order by location, date) as Rolling_People_Vaccinated
FROM Portfolio_Project..combined_dataset$
WHERE continent is not null
ORDER BY 2,3

--Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
SELECT continent, location, date, population, new_vaccinations,SUM(new_vaccinations) OVER (Partition by location Order by location, date) as Rolling_People_Vaccinated
FROM Portfolio_Project..combined_dataset$
WHERE continent is not null
--ORDER BY 2,3
)
Select *, (Rolling_People_Vaccinated/Population)*100 as vaccination_rate
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #Percent_Population_Vaccinated
Create Table #Percent_Population_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #Percent_Population_Vaccinated

SELECT continent, location, date, population, new_vaccinations,SUM(new_vaccinations) OVER (Partition by location Order by location, date) as Rolling_People_Vaccinated
FROM Portfolio_Project..combined_dataset$
WHERE continent is not null
ORDER BY 2,3
Select *, (Rolling_People_Vaccinated/Population)*100 as vaccination_rate
From #Percent_Population_Vaccinated

-- Creating View to store data for later visualizations

Create View Percent_Population_Vaccinated as
SELECT continent, location, date, population, new_vaccinations,SUM(new_vaccinations) OVER (Partition by location Order by location, date) as Rolling_People_Vaccinated
FROM Portfolio_Project..combined_dataset$
WHERE continent is not null
--ORDER BY 2,3