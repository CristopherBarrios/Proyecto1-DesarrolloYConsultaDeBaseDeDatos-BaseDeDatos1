
CREATE TABLE country ( 
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE league (
    id INT PRIMARY KEY,
    country_id INT,
    name VARCHAR(50),
    FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE match ( 
    id INT PRIMARY KEY,
    country_id INT,
    league_id INT,
    season VARCHAR(50),
    stage INT,
    date DATE,
    match_api_id INT,
    home_team_api_id INT,
    away_team_api_id INT,
    home_team_goal INT,
    away_team_goal INT,
    home_player_X1 INT,
    home_player_X2 INT,
    home_player_X3 INT,
    home_player_X4 INT,
    home_player_X5 INT,
    home_player_X6 INT,
    home_player_X7 INT,
    home_player_X8 INT, 
    home_player_X9 INT,
    home_player_X10 INT,
    home_player_X11 INT,
    away_player_X1 INT,
    away_player_X2 INT,
    away_player_X3 INT,
    away_player_X4 INT,
    away_player_X5 INT,
    away_player_X6 INT,
    away_player_X7 INT,
    away_player_X8 INT,
    away_player_X9 INT,
    away_player_X10 INT,
    away_player_X11 INT,
    home_player_Y1 INT,
    home_player_Y2 INT,
    home_player_Y3 INT,
    home_player_Y4 INT,
    home_player_Y5 INT,
    home_player_Y6 INT,
    home_player_Y7 INT,
    home_player_Y8 INT,
    home_player_Y9 INT,
    home_player_Y10 INT,
    home_player_Y11 INT,
    away_player_Y1 INT,
    away_player_Y2 INT,
    away_player_Y3 INT,
    away_player_Y4 INT,
    away_player_Y5 INT,
    away_player_Y6 INT,
    away_player_Y7 INT,
    away_player_Y8 INT,
    away_player_Y9 INT,
    away_player_Y10 INT,
    away_player_Y11 INT,
    home_player_1 INT,
    home_player_2 INT,
    home_player_3 INT,
    home_player_4 INT,
    home_player_5 INT,
    home_player_6 INT,
    home_player_7 INT,
    home_player_8 INT,
    home_player_9 INT,
    home_player_10 INT,
    home_player_11 INT,
    away_player_1 INT,
    away_player_2 INT,
    away_player_3 INT,
    away_player_4 INT,
    away_player_5 INT,
    away_player_6 INT,
    away_player_7 INT,
    away_player_8 INT,
    away_player_9 INT,
    away_player_10 INT,
    away_player_11 INT,
    goal TEXT,
    shoton TEXT,
    shotoff TEXT,
    foulcommit TEXT,
    card TEXT,
    "cross" TEXT,
    corner TEXT,
    possession TEXT,
    B365H FLOAT,
    B365D FLOAT,
    B365A FLOAT,
    BWH FLOAT,
    BWD FLOAT,
    BWA FLOAT,
    IWH FLOAT,
    IWD FLOAT,
    IWA FLOAT,
    LBH FLOAT,
    LBD FLOAT,
    LBA FLOAT,
    PSH FLOAT,
    PSD FLOAT,
    PSA FLOAT,
    WHH FLOAT,
    WHD FLOAT,
    WHA FLOAT,
    SJH FLOAT,
    SJD FLOAT,
    SJA FLOAT,
    VCH FLOAT,
    VCD FLOAT,
    VCA FLOAT,
    GBH FLOAT,
    GBD FLOAT,
    GBA FLOAT,
    BSH FLOAT,
    BSD FLOAT,
    BSA FLOAT,
    FOREIGN KEY (country_id) REFERENCES country(id),
    FOREIGN KEY (league_id) REFERENCES league(id)
);

CREATE TABLE player_attributes (
    id INT PRIMARY KEY,
    player_fifa_api_id INT,
    player_api_id INT,
    date DATE,
    overall_rating INT,
    potential INT,
    preferred_foot VARCHAR(50),
    attacking_work_rate VARCHAR(50),
    defensive_work_rate VARCHAR(50),
    crossing INT,
    finishing INT,
    heading_accuracy INT,
    short_passing INT,
    volleys INT,
    dribbling INT,
    curve INT,
    free_kick_accuracy INT,
    long_passing INT,
    ball_control INT,
    acceleration INT,
    sprint_speed INT,
    agility INT,
    reactions INT,
    balance INT,
    shot_power INT,
    jumping INT,
    stamina INT,
    strength INT,
    long_shots INT,
    aggression INT,
    interceptions INT,
    positioning INT,
    vision INT,
    penalties INT,
    marking INT,
    standing_tackle INT,
    sliding_tackle INT,
    gk_diving INT,
    gk_handling INT,
    gk_kicking INT,
    gk_positioning INT,
    gk_reflexes INT
);

CREATE TABLE player (
    id INT PRIMARY KEY,
    player_api_id INT,
    player_name VARCHAR(50),
    player_fifa_api_id INT,
    birthday DATE,
    height FLOAT,
    weight INT
);

CREATE TABLE team_attributes (
    id INT PRIMARY KEY,
    team_fifa_api_id INT,
    team_api_id INT,
    date DATE,
    buildUpPlaySpeed INT,
    buildUpPlaySpeedClass VARCHAR(50),
    buildUpPlayDribbling INT,
    buildUpPlayDribblingClass VARCHAR(50),
    buildUpPlayPassing INT,
    buildUpPlayPassingClass VARCHAR(50),
    buildUpPlayPositioningClass VARCHAR(50),
    chanceCreationPassing INT,
    chanceCreationPassingClass VARCHAR(50),
    chanceCreationCrossing INT,
    chanceCreationCrossingClass VARCHAR(50),
    chanceCreationShooting INT,
    chanceCreationShootingClass VARCHAR(50),
    chanceCreationPositioningClass VARCHAR(50),
    defencePressure INT,
    defencePressureClass VARCHAR(50),
    defenceAggression INT,
    defenceAggressionClass VARCHAR(50),
    defenceTeamWidth INT,
    defenceTeamWidthClass VARCHAR(50),
    defenceDefenderLineClass VARCHAR(50)
);

CREATE TABLE team (
    id INT PRIMARY KEY,
    team_api_id INT,
    team_fifa_api_id INT,
    team_long_name VARCHAR(50),
    team_short_name VARCHAR(50)
);
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
SELECT name as liga, season, equipo, SUM(goles_favor) AS goles_favor, SUM(goles_contra) AS goles_contra, SUM(goles_favor) - SUM(goles_contra) AS diferencia
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
GROUP BY liga, season, equipo
ORDER BY diferencia DESC
LIMIT 1;

--Utilizando este mismo query, obtenga el ranking de los equipos por temporada y por
--liga, ordenados por ese ranking de manera descendente por diferencia (utilice la función
--Rank () over patition), para obtener el equipo ganador (la respuesta es obvia).

SELECT name as liga, season, equipo, SUM(goles_favor) AS goles_favor, SUM(goles_contra) AS goles_contra, SUM(goles_favor) - SUM(goles_contra) AS diferencia, RANK() OVER (PARTITION BY name, season ORDER BY SUM(goles_favor) - SUM(goles_contra) DESC) AS ranking
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
GROUP BY liga, season, equipo
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

--Etapa 3

