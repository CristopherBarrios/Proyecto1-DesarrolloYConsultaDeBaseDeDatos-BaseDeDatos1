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
--4. ¿Quién es el mejor equipo de todas las ligas y de todas las temporadas según las
--apuestas? Observe la información dada en la siguientes páginas para poder interpretar las
--cuotas promedio para obtener las probabilidades:
--● https://www.apuestas-deportivas.es/calculadora-probabilidades-apuestas-deportivas
--/
--● https://www.pasionamarilla.com/ud-laspalmas-noticias/como-se-calculan-las-probabi
--lidades-en-las-apuestas-deportivas/
--Hint: Obtenga el promedio de todas las casas de apuesta por partido, y luego obtenga el
--promedio de estas por temporada, liga y equipo.

SELECT
match.season, league.name, team.team_long_name,
100 / AVG(B365H) AS avg_B365H, 100 / AVG(B365D) AS avg_B365D, 100 / AVG(B365A) AS avg_B365A,
100 / AVG(BWH) AS avg_BWH, 100 / AVG(BWD) AS avg_BWD, 100 / AVG(BWA) AS avg_BWA,
100 / AVG(IWH) AS avg_IWH, 100 / AVG(IWD) AS avg_IWD, 100 / AVG(IWA) AS avg_IWA,
100 / AVG(LBH) AS avg_LBH, 100 / AVG(LBD) AS avg_LBD, 100 / AVG(LBA) AS avg_LBA,
100 / AVG(PSH) AS avg_PSH, 100 / AVG(PSD) AS avg_PSD, 100 / AVG(PSA) AS avg_PSA,
100 / AVG(WHH) AS avg_WHH, 100 / AVG(WHD) AS avg_WHD, 100 / AVG(WHA) AS avg_WHA,
100 / AVG(SJH) AS avg_SJH, 100 / AVG(SJD) AS avg_SJD, 100 / AVG(SJA) AS avg_SJA,
100 / AVG(VCH) AS avg_VCH, 100 / AVG(VCD) AS avg_VCD, 100 / AVG(VCA) AS avg_VCA,
100 / AVG(GBH) AS avg_GBH, 100 / AVG(GBD) AS avg_GBD, 100 / AVG(GBA) AS avg_GBA,
100 / AVG(BSH) AS avg_BSH, 100 / AVG(BSD) AS avg_BSD, 100 / AVG(BSA) AS avg_BSA
FROM match
JOIN league ON match.league_id = league.id
JOIN team ON match.home_team_api_id = team.team_api_id
GROUP BY match.season, league.name, team.team_long_name
ORDER BY match.season, league.name, team.team_long_name;

------------------------------------------------------------------------

SELECT 
    match.season, 
    league.name, 
    team.team_long_name, 
    AVG(100 / B365H + 100 / B365D + 100 / (B365A) +
100 / (BWH) + 100 / (BWD) + 100 / (BWA) +
100 / (IWH) + 100 / (IWD) + 100 / (IWA) +
100 / (LBH) + 100 / (LBD) + 100 / (LBA) +
100 / (PSH) + 100 / (PSD) + 100 / (PSA) +
100 / (WHH) + 100 / (WHD) + 100 / (WHA) +
100 / (SJH) + 100 / (SJD) + 100 / (SJA) +
100 / (VCH) + 100 / (VCD) + 100 / (VCA) +
100 / (GBH) + 100 / (GBD) + 100 / (GBA) +
100 / (BSH) + 100 / (BSD) + 100 / (BSA) ) AS avg_odds
FROM 
    match
JOIN 
    league ON match.league_id = league.id
JOIN 
    team ON match.home_team_api_id = team.team_api_id
GROUP BY 
    match.season, 
    league.name, 
    team.team_long_name
HAVING         AVG(100 / B365H + 100 / B365D + 100 / (B365A) +
100 / (BWH) + 100 / (BWD) + 100 / (BWA) +
100 / (IWH) + 100 / (IWD) + 100 / (IWA) +
100 / (LBH) + 100 / (LBD) + 100 / (LBA) +
100 / (PSH) + 100 / (PSD) + 100 / (PSA) +
100 / (WHH) + 100 / (WHD) + 100 / (WHA) +
100 / (SJH) + 100 / (SJD) + 100 / (SJA) +
100 / (VCH) + 100 / (VCD) + 100 / (VCA) +
100 / (GBH) + 100 / (GBD) + 100 / (GBA) +
100 / (BSH) + 100 / (BSD) + 100 / (BSA) ) IS NOT NULL
ORDER BY 
    avg_odds DESC


--5. ¿Quiénes son los jugadores de cada liga y cada temporada que tienen los mejores
--atributos – características de juego? ¿De acuerdo a este inciso y comparándolo con el
--inciso 2 y 4 anteriores, alguno de los jugadores más valiosos se encuentra dentro del
--mejor equipo?
select  m.season as temporada, l.name as liga,
m.home_player_1, hp1.player_name as name_home_player_1, pa1.overall_rating as home_player_1_rating, 
m.home_player_2, hp2.player_name as name_home_player_2, pa2.overall_rating as home_player_2_rating,
m.home_player_3, hp3.player_name as name_home_player_3, pa3.overall_rating as home_player_3_rating,
m.home_player_4, hp4.player_name as name_home_player_4, pa4.overall_rating as home_player_4_rating,
m.home_player_5, hp5.player_name as name_home_player_5, pa5.overall_rating as home_player_5_rating,
m.home_player_6, hp6.player_name as name_home_player_6, pa6.overall_rating as home_player_6_rating,
m.home_player_7, hp7.player_name as name_home_player_7, pa7.overall_rating as home_player_7_rating,
m.home_player_8, hp8.player_name as name_home_player_8, pa8.overall_rating as home_player_8_rating,
m.home_player_9, hp9.player_name as name_home_player_9, pa9.overall_rating as home_player_9_rating,
m.home_player_10, hp10.player_name as name_home_player_10, pa10.overall_rating as home_player_10_rating,
m.home_player_11, hp11.player_name as name_home_player_11, pa11.overall_rating as home_player_11_rating,

m.away_player_1, ap1.player_name as name_away_player_1, apa1.overall_rating as away_player_1_rating,
m.away_player_2, ap2.player_name as name_away_player_2, apa2.overall_rating as away_player_2_rating,
m.away_player_3, ap3.player_name as name_away_player_3, apa3.overall_rating as away_player_3_rating,
m.away_player_4, ap4.player_name as name_away_player_4, apa4.overall_rating as away_player_4_rating,
m.away_player_5, ap5.player_name as name_away_player_5, apa5.overall_rating as away_player_5_rating,
m.away_player_6, ap6.player_name as name_away_player_6, apa6.overall_rating as away_player_6_rating,
m.away_player_7, ap7.player_name as name_away_player_7, apa7.overall_rating as away_player_7_rating,
m.away_player_8, ap8.player_name as name_away_player_8, apa8.overall_rating as away_player_8_rating,
m.away_player_9, ap9.player_name as name_away_player_9, apa9.overall_rating as away_player_9_rating,
m.away_player_10, ap10.player_name as name_away_player_10, apa10.overall_rating as away_player_10_rating,
m.away_player_11, ap11.player_name as name_away_player_11, apa11.overall_rating as away_player_11_rating

from match m
inner join league l
on m.league_id = l.id

LEFT JOIN player_attributes pa1 ON m.home_player_1 = pa1.player_api_id
LEFT JOIN player_attributes pa2 ON m.home_player_2 = pa2.player_api_id 
LEFT JOIN player_attributes pa3 ON m.home_player_3 = pa3.player_api_id 
LEFT JOIN player_attributes pa4 ON m.home_player_4 = pa4.player_api_id 
LEFT JOIN player_attributes pa5 ON m.home_player_5 = pa5.player_api_id 
LEFT JOIN player_attributes pa6 ON m.home_player_6 = pa6.player_api_id 
LEFT JOIN player_attributes pa7 ON m.home_player_7 = pa7.player_api_id 
LEFT JOIN player_attributes pa8 ON m.home_player_8 = pa8.player_api_id 
LEFT JOIN player_attributes pa9 ON m.home_player_9 = pa9.player_api_id 
LEFT JOIN player_attributes pa10 ON m.home_player_10 = pa10.player_api_id 
LEFT JOIN player_attributes pa11 ON m.home_player_11 = pa11.player_api_id 

LEFT JOIN player_attributes apa1 ON m.away_player_1 = apa1.player_api_id
LEFT JOIN player_attributes apa2 ON m.away_player_2 = apa2.player_api_id 
LEFT JOIN player_attributes apa3 ON m.away_player_3 = apa3.player_api_id 
LEFT JOIN player_attributes apa4 ON m.away_player_4 = apa4.player_api_id 
LEFT JOIN player_attributes apa5 ON m.away_player_5 = apa5.player_api_id 
LEFT JOIN player_attributes apa6 ON m.away_player_6 = apa6.player_api_id 
LEFT JOIN player_attributes apa7 ON m.away_player_7 = apa7.player_api_id 
LEFT JOIN player_attributes apa8 ON m.away_player_8 = apa8.player_api_id 
LEFT JOIN player_attributes apa9 ON m.away_player_9 = apa9.player_api_id 
LEFT JOIN player_attributes apa10 ON m.away_player_10 = apa10.player_api_id 
LEFT JOIN player_attributes apa11 ON m.away_player_11 = apa11.player_api_id 

left join player hp1
on m.home_player_1 = hp1.player_api_id
left join player hp2
on m.home_player_2 = hp2.player_api_id
left join player hp3
on m.home_player_3 = hp3.player_api_id
left join player hp4
on m.home_player_4 = hp4.player_api_id
left join player hp5
on m.home_player_5 = hp5.player_api_id
left join player hp6
on m.home_player_6 = hp6.player_api_id
left join player hp7
on m.home_player_7 = hp7.player_api_id
left join player hp8
on m.home_player_8 = hp8.player_api_id
left join player hp9
on m.home_player_9 = hp9.player_api_id
left join player hp10
on m.home_player_10 = hp10.player_api_id
left join player hp11
on m.home_player_11 = hp11.player_api_id

left join player ap1
on m.away_player_1 = ap1.player_api_id
left join player ap2
on m.away_player_2 = ap2.player_api_id
left join player ap3
on m.away_player_3 = ap3.player_api_id
left join player ap4
on m.away_player_4 = ap4.player_api_id
left join player ap5
on m.away_player_5 = ap5.player_api_id
left join player ap6
on m.away_player_6 = ap6.player_api_id
left join player ap7
on m.away_player_7 = ap7.player_api_id
left join player ap8
on m.away_player_8 = ap8.player_api_id
left join player ap9
on m.away_player_9 = ap9.player_api_id
left join player ap10
on m.away_player_10 = ap10.player_api_id
left join player ap11
on m.away_player_11 = ap11.player_api_id

where pa1.overall_rating is not null 
and pa2.overall_rating IS NOT NULL
and pa3.overall_rating IS NOT NULL
and pa4.overall_rating IS NOT NULL
and pa5.overall_rating IS NOT NULL
and pa6.overall_rating IS NOT NULL
and pa7.overall_rating IS NOT NULL
and pa8.overall_rating IS NOT NULL
and pa9.overall_rating IS NOT NULL
and pa10.overall_rating IS NOT NULL
and pa11.overall_rating IS NOT NULL

and apa1.overall_rating is not null 
and apa2.overall_rating IS NOT NULL
and apa3.overall_rating IS NOT NULL
and apa4.overall_rating IS NOT NULL
and apa5.overall_rating IS NOT NULL
and apa6.overall_rating IS NOT NULL
and apa7.overall_rating IS NOT NULL
and apa8.overall_rating IS NOT NULL
and apa9.overall_rating IS NOT NULL
and apa10.overall_rating IS NOT NULL
and apa11.overall_rating IS NOT NULL

ORDER BY 
    home_player_1_rating DESC,
	home_player_2_rating DESC,
	home_player_3_rating DESC,
	home_player_4_rating DESC,
	home_player_5_rating DESC,
	home_player_6_rating DESC,
	home_player_7_rating DESC,
	home_player_8_rating DESC,
	home_player_9_rating DESC,
	home_player_10_rating DESC,
	home_player_11_rating DESC,
	
	away_player_1_rating DESC,
	away_player_2_rating DESC,
	away_player_3_rating DESC,
	away_player_4_rating DESC,
	away_player_5_rating DESC,
	away_player_6_rating DESC,
	away_player_7_rating DESC,
	away_player_8_rating DESC,
	away_player_9_rating DESC,
	away_player_10_rating DESC,
	away_player_11_rating DESC

----------------Como no corre hay que ocupar este
select  m.season as temporada, l.name as liga,
m.home_player_1, hp1.player_name as name_home_player_1, pa1.overall_rating as home_player_1_rating,
m.home_player_2, hp2.player_name as name_home_player_2, pa2.overall_rating as home_player_2_rating


from match m
inner join league l
on m.league_id = l.id

LEFT JOIN player_attributes pa1 ON m.home_player_1 = pa1.player_api_id
LEFT JOIN player_attributes pa2 ON m.home_player_2 = pa2.player_api_id 

left join player hp1
on m.home_player_1 = hp1.player_api_id
left join player hp2
on m.home_player_2 = hp2.player_api_id
left join player hp3
on m.home_player_3 = hp3.player_api_id
left join player hp4
on m.home_player_4 = hp4.player_api_id
left join player hp5
on m.home_player_5 = hp5.player_api_id
left join player hp6
on m.home_player_6 = hp6.player_api_id
left join player hp7
on m.home_player_7 = hp7.player_api_id
left join player hp8
on m.home_player_8 = hp8.player_api_id
left join player hp9
on m.home_player_9 = hp9.player_api_id
left join player hp10
on m.home_player_10 = hp10.player_api_id
left join player hp11
on m.home_player_11 = hp11.player_api_id

left join player ap1
on m.away_player_1 = ap1.player_api_id
left join player ap2
on m.away_player_2 = ap2.player_api_id
left join player ap3
on m.away_player_3 = ap3.player_api_id
left join player ap4
on m.away_player_4 = ap4.player_api_id
left join player ap5
on m.away_player_5 = ap5.player_api_id
left join player ap6
on m.away_player_6 = ap6.player_api_id
left join player ap7
on m.away_player_7 = ap7.player_api_id
left join player ap8
on m.away_player_8 = ap8.player_api_id
left join player ap9
on m.away_player_9 = ap9.player_api_id
left join player ap10
on m.away_player_10 = ap10.player_api_id
left join player ap11
on m.away_player_11 = ap11.player_api_id

where pa1.overall_rating is not null and pa2.overall_rating IS NOT NULL

ORDER BY 
    home_player_1_rating DESC,
	home_player_2_rating DESC
--6. ¿Cuál es el equipo cuyos jugadores han incurrido en menos faltas?
SELECT team.team_long_name, SUM(match.foulcommit) as total_faltas
FROM match
JOIN player 
ON (match.home_team_api_id = player.player_api_id OR match.away_team_api_id = player.player_api_id)
JOIN team 
ON (match.home_team_api_id = team.team_api_id OR match.away_team_api_id = team.team_api_id)
GROUP BY team.team_long_name
ORDER BY total_faltas ASC
LIMIT 1;

--6. Muestre el top 10 de los jugadores más veloces de las ligas europes en todas las 
--temporadas (esta pregunta fue cambiada a la pregunta original, que pasó a ser de 
--puntos extras) 
SELECT pa.player_api_id, p.player_name, pa.sprint_speed

FROM player_attributes pa

JOIN player p 
ON pa.player_api_id = p.player_api_id

WHERE pa.sprint_speed IS NOT NULL

group by pa.player_api_id, p.player_name, pa.sprint_speed

ORDER BY pa.sprint_speed DESC

LIMIT 10;

--7. ¿Cuáles son las características/atributos de los equipos que han sido los líderes de sus
--ligas en las distintas temporadas?  ¿Sus comportamientos son similares?


select  equipo_partido.season as temporada, l.name as liga, t1.team_long_name, goles_favor,
	ta1.buildupplayspeed,    
	ta1.buildUpPlaySpeed,
    ta1.buildUpPlaySpeedClass,
    ta1.buildUpPlayDribbling,
    ta1.buildUpPlayDribblingClass,
    ta1.buildUpPlayPassing,
    ta1.buildUpPlayPassingClass,
    ta1.buildUpPlayPositioningClass,
    ta1.chanceCreationPassing,
    ta1.chanceCreationPassingClass,
    ta1.chanceCreationCrossing,
    ta1.chanceCreationCrossingClass,
    ta1.chanceCreationShooting,
    ta1.chanceCreationShootingClass,
    ta1.chanceCreationPositioningClass,
    ta1.defencePressure,
    ta1.defencePressureClass,
    ta1.defenceAggression,
    ta1.defenceAggressionClass,
    ta1.defenceTeamWidth,
    ta1.defenceTeamWidthClass,
    ta1.defenceDefenderLineClass 


from (
  SELECT league_id, season, home_team_api_id AS equipo, home_team_goal AS goles_favor, away_team_goal AS goles_contra
  FROM match
  UNION ALL
  SELECT league_id, season, away_team_api_id AS equipo, away_team_goal AS goles_favor, home_team_goal AS goles_contra
  FROM match
) as equipo_partido

inner join league l
on equipo_partido.league_id = l.id

LEFT JOIN team_attributes ta1 ON equipo_partido.equipo = ta1.team_api_id


left join team t1
on equipo_partido.equipo = t1.team_api_id

order by goles_favor desc





--8. ¿Quiénes son los 3 países líderes según apuestas y según estadísticas?
SELECT c.name, AVG(m.B365H) AS avg_prob_win
FROM country c
JOIN match m ON c.id = m.country_id
WHERE B365H IS NOT NULL
GROUP BY c.name
ORDER BY avg_prob_win DESC
LIMIT 3;

--
SELECT c.name, AVG(m.home_team_goal) AS avg_goals
FROM country c
JOIN match m ON c.id = m.country_id
GROUP BY c.name
ORDER BY avg_goals DESC
LIMIT 3;


----------------------------
--etapa3
select team_id, team_long_name, season, points_per_game,  prev_points_per_game,
     points_per_game_diff
from(
SELECT t1.team_id, t1.season, t1.points_per_game, t2.points_per_game AS prev_points_per_game,
    t1.points_per_game - t2.points_per_game AS points_per_game_diff
FROM (
    SELECT m.home_team_api_id AS team_id, m.season,
        AVG(CASE WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0 END) +
        AVG(CASE WHEN m.home_team_goal < m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0 END) AS points_per_game
    FROM match m
    GROUP BY m.home_team_api_id, m.season
) t1
JOIN (
    SELECT m.home_team_api_id AS team_id, m.season,
        AVG(CASE WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0 END) +
        AVG(CASE WHEN m.home_team_goal < m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0 END) AS points_per_game
    FROM match m
    WHERE m.season = (SELECT DISTINCT season FROM match ORDER BY season DESC LIMIT 1 OFFSET 3)
    GROUP BY m.home_team_api_id, m.season
) t2
ON t1.team_id = t2.team_id AND t1.season = (SELECT DISTINCT season FROM match ORDER BY season DESC LIMIT 1)
) as points
left join team
on points.team_id = team.team_api_id
order by points_per_game_diff desc
