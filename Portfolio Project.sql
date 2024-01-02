select *
from CovidDeaths
order by 3,4

select *
from CovidVaccinations
order by 3,4

select location,population,date,total_cases,new_cases,total_deaths,New_deaths
from CovidDeaths
order by 1,2

-- calculating death rate out of total cases
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_percentage
from CovidDeaths
order by 1,2
--calculating case rate out of population 
select location,date,total_cases,total_deaths,Population,(total_cases/Population) as Case_rate
from CovidDeaths
where Location LIKE '%INDIA%'
order by 1,2
--Calculating hihest infection cases, and max infection rate
select location,max(total_cases) as Highest_Infectious_cases  ,Population,max(total_cases/Population) as Highest_Case_rate
from CovidDeaths
Group by Location,population
order by 1,2
--Calculation of total deaths 
Use  [Portfolio Project]

Select Location ,Max(cast (Total_deaths as int )) as highDeathcount
from Coviddeaths
where Continent is not null
Group by location
order by highDeathcount desc

--Breaking down by COntinent
Select continent ,Max(cast (Total_deaths as int )) as highDeathcount
from Coviddeaths
where Continent is  not null
Group by continent
order by highDeathcount desc

--Total Death Percentage

select sum(new_cases) as Total_cases,sum(cast(New_deaths as int)) as Total_Deaths, sum(cast(New_deaths as int))/sum(new_cases)*100 as Death_Percentage
from CovidDeaths

--Joining both tables
go
Select dea.location, dea.date,dea.population,vac.new_vaccinations
from CovidDeaths  dea join  CovidVaccinations Vac on dea.location=vac.location and  dea.date=vac.date
where dea.continent is not null

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast (new_vaccinations as int)) over (partition by dea.location 
 order by dea.date,dea.location) as RollingpeopleVaccinated 
from CovidDeaths dea join CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by  2,3

--Pop vs Vac
with popvsvac (continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as 

(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over 
(partition by dea.location order by dea.date,dea.location ) as Rollingpeoplevaccinated
from Coviddeaths Dea join covidvaccinations Vac on dea.location=vac.location and  dea.date=vac.date
where dea.continent is not null)
select*,(Rollingpeoplevaccinated/population)*100 as percentpeoplevaccinated 
from popvsvac
--temp Table
drop table if exists #percentpeoplevaccinated 
create Table #Percentpeoplevaccinated 
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric)
insert into #Percentpeoplevaccinated 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over 
(partition by dea.location order by dea.date,dea.location ) as Rollingpeoplevaccinated
from Coviddeaths Dea join covidvaccinations Vac on dea.location=vac.location and  dea.date=vac.date
where dea.continent is not null
select*,(Rollingpeoplevaccinated/population)*100 as percentpeoplevaccinated 
from #Percentpeoplevaccinated 
--creating view for visualizations 
go 
create view percentpeoplevaccinated 
as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over 
(partition by dea.location order by dea.date,dea.location ) as Rollingpeoplevaccinated
from Coviddeaths Dea join covidvaccinations Vac on dea.location=vac.location and  dea.date=vac.date
where dea.continent is not null
--select*,(Rollingpeoplevaccinated/population)*100 as percentpeoplevaccinated 
--from #Percentpeoplevaccinated 
