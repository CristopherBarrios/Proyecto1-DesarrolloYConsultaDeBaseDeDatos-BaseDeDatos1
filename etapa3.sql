--Etapa 3
--A continuación, debe plantear sus propias preguntas que le permitan justificar la decisión que
--tomará acerca de en qué equipo invertirá. Todas sus conclusiones deben estar basadas en el
--resultado de consultas SQL. Por ejemplo (sugerencias):

--● Podría plantearse apostar en el equipo que sea más consistente en la cantidad de
--partidos que gana por temporada

--● Podría plantearse apostar en el equipo que haya mejorado en las últimas tres
--temporadas

--● Podría plantearse invertir en el equipo tienen características de ser más que son más
--creativos y que tienen una alta presión sobre la defensa, o a lo mejor los que tienen un
--juego rápido y un juego más agresivo.

--●   Etc.

--Requerimientos mínimos a completar:
--●   Se debe presentar el resultado de al menos 15 queries en todo el proyecto
--●   Deben presentarse al menos tres queries diferentes con agrupaciones (GROUP BY)
--●   Deben presentarse al menos tres queries diferentes con JOINs entre dos o más tablas
--●   Debe presentarse al menos una consulta que haga uso de subqueries


---------------------------------------------------------------------------------

--¿Cuales son los 20 equipos que tienen mejor defensa en términos de goles recibidos por temporada?
SELECT  season, equipo, team_long_name, SUM(goles_contra) AS goles_contra 
FROM (
  SELECT league_id, season, home_team_api_id AS equipo, away_team_goal AS goles_contra
  FROM match
  UNION ALL
  SELECT league_id, season, away_team_api_id AS equipo, home_team_goal AS goles_contra
  FROM match
) as equipo_partido

inner join team
on equipo_partido.equipo = team.team_api_id
GROUP BY  season, equipo, team_long_name
order by goles_contra asc
LIMIT 20;

-- ¿Cual es el equipo más consistente en la cantidad de partidos que gana por temporada?
select equipo, team_long_name, wins
from(
SELECT home_team_api_id as equipo, COUNT(*) AS wins
FROM match
WHERE home_team_goal > away_team_goal
GROUP BY home_team_api_id

UNION

SELECT away_team_api_id as equipo, COUNT(*) AS wins
FROM match
WHERE away_team_goal > home_team_goal
GROUP BY away_team_api_id

ORDER BY wins DESC) as tabla
inner join team t
on tabla.equipo= t.team_api_id

-- ¿Cuáles son los 20 equipos más organizados y su manejo en pases?
select team_long_name, buildupplaypositioningclass, chanceCreationCrossing
from team t
inner join team_attributes ta
on t.team_api_id = ta.team_api_id
where buildupplaypositioningclass = 'Organised'
group by team_long_name, buildupplaypositioningclass, chanceCreationCrossing
ORDER BY chanceCreationCrossing DESC
LIMIT 20;

--¿Cuales son los jugadores que más aciertan a los penalties?
select p.player_api_id, player_name, penalties
from player p
inner join player_attributes pa
on p.player_api_id = pa.player_api_id
where penalties is not null
group by player_name, penalties, p.player_api_id
order by penalties desc
limit 20;

--¿Cuáles son los 50 países que más partidos han jugado y sus ligas?
select datos, l.name, team_long_name, count(*)
from
(select home_team_api_id datos, league_id from match
union all
select away_team_api_id datos, league_id from match) as equipo_partido
inner join team
on equipo_partido.datos = team.team_api_id

inner join league l
on equipo_partido.league_id = l.id

group by datos, team_long_name, l.name
order by count(*) desc
limit 50;
