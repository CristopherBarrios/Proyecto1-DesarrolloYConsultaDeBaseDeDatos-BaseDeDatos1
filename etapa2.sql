---------------------------------------------------------
-----------------------CONSULTAS-------------------------
---------------------------------------------------------

--Etapa 2
--En la etapa 2 usted ejecutará algunos queries que le permitan familiarizarse con el modelo de
--datos presentado.
--Para esto deberá obtener lo siguiente:
--Según estadísticas:

--1.  La cantidad de juegos jugados en cada temporada por cada equipo, de cada liga 
--(tome en cuenta que cada equipo puede jugar como visitante o como anfitrión.

SELECT name as liga, season, team_long_name, COUNT(*) as cantidad_juegos
FROM (
  SELECT league_id, season, home_team_api_id
  FROM match
  UNION ALL
  SELECT league_id, season, away_team_api_id
  FROM match) as equipo_partido
inner join team
on equipo_partido.home_team_api_id = team.team_api_id
inner join league
on equipo_partido.league_id = league.id 
GROUP BY name, season, team_long_name;

--2. ¿Quién es el mejor equipo de todas las ligas y de todas las temporadas según las
--estadísticas?

--Hint: Obtenga la cantidad de goles a favor, goles en contra y la diferencia entre las dos
--anteriores, esto por cada temporada y por cada equipo de cada liga.
SELECT name as liga, season, equipo, team.team_long_name, SUM(goles_favor) AS goles_favor, SUM(goles_contra) AS goles_contra, SUM(goles_favor) - SUM(goles_contra) AS diferencia
FROM (
  SELECT league_id, season, home_team_api_id AS equipo, home_team_goal AS goles_favor, away_team_goal AS goles_contra
  FROM match
  UNION ALL
  SELECT league_id, season, away_team_api_id AS equipo, away_team_goal AS goles_favor, home_team_goal AS goles_contra
  FROM match
) as equipo_partido
inner join team
on equipo_partido.equipo = team.team_api_id
inner join league
on equipo_partido.league_id = league.id 
GROUP BY liga, season, equipo, team.team_long_name
ORDER BY diferencia DESC
LIMIT 1;

--Utilizando este mismo query, obtenga el ranking de los equipos por temporada y por
--liga, ordenados por ese ranking de manera descendente por diferencia (utilice la función
--Rank () over patition), para obtener el equipo ganador (la respuesta es obvia).

SELECT name as liga, season, equipo, team.team_long_name, SUM(goles_favor) AS goles_favor, SUM(goles_contra) AS goles_contra, SUM(goles_favor) - SUM(goles_contra) AS diferencia, RANK() OVER (PARTITION BY name, season ORDER BY SUM(goles_favor) - SUM(goles_contra) DESC) AS ranking
FROM (
  SELECT league_id, season, home_team_api_id AS equipo, home_team_goal AS goles_favor, away_team_goal AS goles_contra
  FROM match
  UNION ALL
  SELECT league_id, season, away_team_api_id AS equipo, away_team_goal AS goles_favor, home_team_goal AS goles_contra
  FROM match
) as equipo_partido
inner join team
on equipo_partido.equipo = team.team_api_id
inner join league
on equipo_partido.league_id = league.id 
GROUP BY liga, season, equipo,team.team_long_name
ORDER BY liga, season, ranking;

--Según apuestas:


--3.  Realice un promedio de las probabilidades de todas las casas de apuesta por temporada,
--liga y equipo (elimine aquellos equipos que no tienen estadísticas en ninguna casa de
--apuesta (casas de apuesta como B36, IW, LB, PSH, etc).
SELECT 
       match.season, league.name, team.team_long_name, 
	   AVG(B365H) AS avg_B365H, AVG(B365D) AS avg_B365D, AVG(B365A) AS avg_B365A,
       AVG(BWH) AS avg_BWH, AVG(BWD) AS avg_BWD, AVG(BWA) AS avg_BWA,
       AVG(IWH) AS avg_IWH, AVG(IWD) AS avg_IWD, AVG(IWA) AS avg_IWA,
       AVG(LBH) AS avg_LBH, AVG(LBD) AS avg_LBD, AVG(LBA) AS avg_LBA,
       AVG(PSH) AS avg_PSH, AVG(PSD) AS avg_PSD, AVG(PSA) AS avg_PSA,
       AVG(WHH) AS avg_WHH, AVG(WHD) AS avg_WHD, AVG(WHA) AS avg_WHA,
       AVG(SJH) AS avg_SJH, AVG(SJD) AS avg_SJD, AVG(SJA) AS avg_SJA,
       AVG(VCH) AS avg_VCH, AVG(VCD) AS avg_VCD, AVG(VCA) AS avg_VCA,
       AVG(GBH) AS avg_GBH, AVG(GBD) AS avg_GBD, AVG(GBA) AS avg_GBA,
       AVG(BSH) AS avg_BSH, AVG(BSD) AS avg_BSD, AVG(BSA) AS avg_BSA
FROM match
JOIN league ON match.league_id = league.id
JOIN team ON match.home_team_api_id = team.team_api_id
LEFT JOIN (
    SELECT DISTINCT home_team_api_id
    FROM match
    WHERE B365H IS NOT NULL
    UNION
    SELECT DISTINCT away_team_api_id
    FROM match
    WHERE B365H IS NOT NULL
) AS teams_with_odds ON team.team_api_id = teams_with_odds.home_team_api_id
WHERE teams_with_odds.home_team_api_id IS NOT NULL
GROUP BY match.season, league.name, team.team_long_name
ORDER BY match.season, league.name, team.team_long_name;

--4. ¿Quién es el mejor equipo de todas las ligas y de todas las temporadas según las
--apuestas? Observe la información dada en la siguientes páginas para poder interpretar las
--cuotas promedio para obtener las probabilidades:
--● https://www.apuestas-deportivas.es/calculadora-probabilidades-apuestas-deportivas
--/
--● https://www.pasionamarilla.com/ud-laspalmas-noticias/como-se-calculan-las-probabi
--lidades-en-las-apuestas-deportivas/
--Hint: Obtenga el promedio de todas las casas de apuesta por partido, y luego obtenga el
--promedio de estas por temporada, liga y equipo.

--Tengo duda de que este bien
SELECT 
    match.season, 
    league.name, 
    team.team_long_name, 
    100 / AVG(B365H + B365D + B365A + BWH + BWD + BWA + 
         IWH + IWD + IWA + LBH + LBD + LBA + 
         PSH + PSD + PSA + WHH + WHD + WHA + 
         SJH + SJD + SJA + VCH + VCD + VCA + 
         GBH + GBD + GBA + BSH + BSD + BSA) AS avg_odds
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
HAVING 100 / AVG(B365H + B365D + B365A + BWH + BWD + BWA + 
         IWH + IWD + IWA + LBH + LBD + LBA + 
         PSH + PSD + PSA + WHH + WHD + WHA + 
         SJH + SJD + SJA + VCH + VCD + VCA + 
         GBH + GBD + GBA + BSH + BSD + BSA) IS NOT NULL
ORDER BY 
    avg_odds DESC


-----------------Otros:
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

--6. Muestre el top 10 de los jugadores más veloces de las ligas europes en todas las 
--temporadas (esta pregunta fue cambiada a la pregunta original, que pasó a ser de 
--puntos extras) 
SELECT pa.player_api_id, p.player_name, AVG(pa.sprint_speed) AS avg_sprint_speed
FROM player_attributes pa
JOIN player p ON pa.player_api_id = p.player_api_id
WHERE pa.sprint_speed IS NOT NULL
GROUP BY pa.player_api_id, p.player_name
ORDER BY avg_sprint_speed DESC
LIMIT 10;


--7. ¿Cuáles son las características/atributos de los equipos que han sido los líderes de sus
--ligas en las distintas temporadas?  ¿Sus comportamientos son similares?
SELECT  equipo_partido.season as temporada, l.name as liga, t1.team_long_name, goles_favor, ta1.date,
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


FROM (
  SELECT league_id, season, date, home_team_api_id AS equipo, home_team_goal AS goles_favor, away_team_goal AS goles_contra
  FROM match
  UNION ALL
  SELECT league_id, season, date, away_team_api_id AS equipo, away_team_goal AS goles_favor, home_team_goal AS goles_contra
  FROM match
) as equipo_partido

INNER JOIN league l
ON equipo_partido.league_id = l.id

LEFT JOIN team_attributes ta1 ON equipo_partido.equipo = ta1.team_api_id 


LEFT JOIN team t1
ON equipo_partido.equipo = t1.team_api_id

GROUP BY equipo_partido.season, l.name, t1.team_long_name,  goles_favor,ta1.date,
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
ORDER BY goles_favor desc

--8. ¿Quiénes son los 3 países líderes según apuestas y según estadísticas?

--Apuestas
SELECT c.name, AVG(m.B365H + m.B365D + m.B365A 
				   + m.BWH + m.BWD + m.BWA 
				   + m.IWH + m.IWD + m.IWA
				   + m.LBH + m.LBD + m.LBA 
				   + m.PSH + m.PSD + m.PSA 
				   + m.WHH + m.WHD + m.WHA 
				   + m.SJH + m.SJD + m.SJA 
				   + m.VCH + m.VCD + m.VCA 
				   + m.GBH + m.GBD + m.GBA
				   + m.BSH + m.BSD + m.BSA) AS avg_odds  
FROM match m
JOIN league l 
ON m.league_id = l.id

JOIN country c 
ON l.country_id = c.id
GROUP BY c.name
HAVING AVG(m.B365H + m.B365D + m.B365A 
				   + m.BWH + m.BWD + m.BWA 
				   + m.IWH + m.IWD + m.IWA
				   + m.LBH + m.LBD + m.LBA 
				   + m.PSH + m.PSD + m.PSA 
				   + m.WHH + m.WHD + m.WHA 
				   + m.SJH + m.SJD + m.SJA 
				   + m.VCH + m.VCD + m.VCA 
				   + m.GBH + m.GBD + m.GBA
				   + m.BSH + m.BSD + m.BSA) IS NOT NULL
ORDER BY avg_odds DESC
LIMIT 3;
-- Estadisticas

SELECT c.name, SUM(CASE
                     WHEN m.home_team_goal > m.away_team_goal THEN 1
                     ELSE 0
                   END) AS total_home_wins
FROM match m
JOIN league l 
ON m.league_id = l.id
JOIN country c 
ON l.country_id = c.id
GROUP BY c.name
ORDER BY total_home_wins DESC
LIMIT 3;


--Puntos extras. ¿Cuál es el equipo cuyos jugadores han incurrido en menos faltas?
SELECT team, SUM(foulscommitted) AS total_fouls
FROM foulcommit
GROUP BY team
ORDER BY total_fouls ASC