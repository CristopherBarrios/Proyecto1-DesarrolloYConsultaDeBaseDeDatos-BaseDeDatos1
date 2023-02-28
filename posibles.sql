--1.  La cantidad de juegos jugados en cada temporada por cada equipo, de cada liga 
--(tome en cuenta que cada equipo puede jugar como visitante o como anfitrión.
select datos,team_long_name, count(*)
from
(select home_team_api_id datos from match
union all
select away_team_api_id datos from match) as equipo_partido
inner join team
on equipo_partido.datos = team.team_api_id
group by datos, team_long_name
order by datos desc
--para mientras
select league_id, name as liga, season, equipo_id, team_long_name
from
(select league_id, season, home_team_api_id equipo_id from match
union all
select league_id, season, away_team_api_id equipo_id from match) as equipo_partido
inner join team
on equipo_partido.equipo_id = team.team_api_id
inner join league
on equipo_partido.league_id = league.id

order by season asc
--what
select  season, count(*)
from (select league_id, season, home_team_api_id equipo_id from match
union all
select league_id, season, away_team_api_id equipo_id from match) as equipo_partido
group by season
order by season