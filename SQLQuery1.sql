CREATE DATABASE mta_daily_ridership
USE mta_daily_ridership
select * from daily_ridership 


--Total Daily Ridership--
SELECT 
    date,
    Subways_Total + Buses_Total + LIRR_Total + Metro_total 
        + AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership AS total_ridership
FROM daily_ridership

--Total Ridership by Month--
SELECT 
    FORMAT([date], 'yyyy-MM') AS Month,
    SUM(
        Subways_Total +
        Buses_Total +
        LIRR_Total +
        Metro_total +
        AAR_Trips +
        Bridges_and_Tunnels_Traffic +
        SIR_Ridership
    ) AS Monthly_Ridership
FROM daily_ridership
GROUP BY FORMAT([date], 'yyyy-MM')
ORDER BY FORMAT([date], 'yyyy-MM')


--Total ridership for each transport mode--

SELECT 
    sum(CAST(Subways_Total AS FLOAT )) AS sum_subway,
    sum(CAST(Buses_Total AS FLOAT )) AS sum_bus,
    sum(CAST(LIRR_Total AS FLOAT)) AS sum_lirr,
    sum(CAST(Metro_total AS FLOAT)) AS sum_metro,
    sum(CAST(AAR_Trips AS FLOAT)) AS sum_aar,
    sum(CAST(Bridges_and_Tunnels_Traffic AS FLOAT)) AS sum_bridges,
    sum(CAST(SIR_Ridership AS FLOAT)) AS sum_sir
FROM daily_ridership

--Average Pre-Pandemic Daily for each transport mode--

SELECT 
    AVG(CAST(Subway_Pct_PrePandemic AS FLOAT))  AS avg_Subway_PrePandemic_day,
    AVG(CAST(Buses_Pct_PrePandemic AS FLOAT))   AS avg_Buses_PrePandemic_day,
    AVG(CAST(LIRR_Pct_PrePandemic AS FLOAT))    AS avg_LIRR_PrePandemic_day,
    AVG(CAST(Metro_Pct_PrePandemic AS FLOAT))   AS avg_Metro_PrePandemic_day,
    AVG(CAST(AAR_Pct_PrePandemic AS FLOAT))     AS avg_AAR_PrePandemic_day,
    AVG(CAST(Bridges_and_Tunnels_Pct_PrePandemic AS FLOAT)) AS avg_Bridges_PrePandemic_day,
    AVG(CAST(SIR_Pct_PrePandemic AS FLOAT))     AS avg_SIR_PrePandemic_day
FROM daily_ridership



----Busiest Subway Day--
SELECT TOP 1
    date,
    Subways_Total
FROM daily_ridership
ORDER BY Subways_Total DESC


--Top 5 Days Closest to Pre-Pandemic Subway Levels

SELECT TOP 5
    date,
    Subways_Total,
    Subway_Pct_PrePandemic
FROM daily_ridership
ORDER BY Subway_Pct_PrePandemic DESC



---Busiest Bus Day--
SELECT top 1
    date,
    Subways_Total
FROM daily_ridership
ORDER BY Subways_Total DESC

--Average Bus Ridership Over Time
SELECT 
    AVG(Buses_Total) AS avg_bus_ridership
FROM daily_ridership
WHERE date BETWEEN '2020-03-01' AND '2020-03-31';

--Busiest LIRR Day

SELECT TOP 1
    date,
    LIRR_Total
FROM daily_ridership
ORDER BY LIRR_Total DESC

--LIRR Pre-Pandemic Comparison
SELECT 
    date,
    LIRR_Total,
    LIRR_Pct_PrePandemic
FROM daily_ridership
ORDER BY date

--Busiest Metro-North Ridership Day

SELECT TOP 1
    date,
    Metro_total
FROM daily_ridership
ORDER BY Metro_total DESC

--Total AAR Trips Over a Month
SELECT 
    SUM(AAR_Trips) AS total_aar_trips
FROM daily_ridership
WHERE date BETWEEN '2020-03-01' AND '2020-03-31';

--Peak AAR Trips Day
SELECT TOP 1
    date,
    AAR_Trips
FROM daily_ridership
ORDER BY AAR_Trips DESC

--Traffic Pre-Pandemic Comparison
SELECT 
    date,
    Bridges_and_Tunnels_Traffic,
    Bridges_and_Tunnels_Pct_PrePandemic
FROM daily_ridership
ORDER BY date


--Highest Recovery System 

SELECT TOP 1 *
FROM (
    SELECT 'Subway' AS SystemName, AVG(Subway_Pct_PrePandemic) AS Recovery FROM daily_ridership
    UNION ALL
    SELECT 'Buses', AVG(Buses_Pct_PrePandemic) FROM daily_ridership
    UNION ALL
    SELECT 'LIRR', AVG(LIRR_Pct_PrePandemic) FROM daily_ridership
    UNION ALL
    SELECT 'MetroNorth', AVG(Metro_Pct_PrePandemic) FROM daily_ridership
    UNION ALL
    SELECT 'AAR', AVG(AAR_Pct_PrePandemic) FROM daily_ridership
    UNION ALL
    SELECT 'Bridges_Tunnels', AVG(Bridges_and_Tunnels_Pct_PrePandemic) FROM daily_ridership
    UNION ALL
    SELECT 'SIR', AVG(SIR_Pct_PrePandemic) FROM daily_ridership
) AS systems
ORDER BY Recovery DESC;



--Weekly Mobility
SELECT
    DATEPART(WEEK, date) AS week_number,
    SUM(Subways_Total 
        + Buses_Total
        + LIRR_Total
        + Metro_total
        + AAR_Trips
        + Bridges_and_Tunnels_Traffic
        + SIR_Ridership) AS weekly_mobility
FROM daily_ridership
GROUP BY DATEPART(WEEK, date)
ORDER BY week_number;

--First Day Above Pre-Pandemic

SELECT TOP 1 date
FROM daily_ridership
WHERE Subway_Pct_PrePandemic > 100
ORDER BY date


--System with Highest Share-
SELECT TOP 1 *
FROM (
    SELECT date, 'Subway' AS system, 
        CAST(Subways_Total AS FLOAT) / 
        (Subways_Total + Buses_Total + LIRR_Total + Metro_total + 
         AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership) AS share
    FROM daily_ridership

    UNION ALL
    SELECT date, 'Bus',
        CAST(Buses_Total AS FLOAT) /
        (Subways_Total + Buses_Total + LIRR_Total + Metro_total +
         AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership)
    FROM daily_ridership
) AS t
ORDER BY share DESC

--When Traffic Dominated Mobility

SELECT TOP 1
    date,
    Bridges_and_Tunnels_Traffic,
    (Bridges_and_Tunnels_Traffic * 1.0) /
    (Subways_Total + Buses_Total + LIRR_Total + Metro_total +
     AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership) AS traffic_share
FROM daily_ridership
ORDER BY traffic_share DESC

---Subway–Bus Correlation

SELECT 
(
    (COUNT(*) * SUM(CAST(Subways_Total AS FLOAT) * CAST(Buses_Total AS FLOAT))) -
    (SUM(CAST(Subways_Total AS FLOAT)) * SUM(CAST(Buses_Total AS FLOAT)))
)
/
(
    SQRT(
        (COUNT(*) * SUM(CAST(Subways_Total AS FLOAT) * CAST(Subways_Total AS FLOAT))) - 
        (SUM(CAST(Subways_Total AS FLOAT)) * SUM(CAST(Subways_Total AS FLOAT)))
    )
    *
    SQRT(
        (COUNT(*) * SUM(CAST(Buses_Total AS FLOAT) * CAST(Buses_Total AS FLOAT))) - 
        (SUM(CAST(Buses_Total AS FLOAT)) * SUM(CAST(Buses_Total AS FLOAT)))
    )
) AS correlation_subway_bus
FROM daily_ridership;

---Subway Up / Others Down
WITH t AS (
    SELECT 
        date,
        Subways_Total,
        Buses_Total,
        LIRR_Total,
        Metro_total,
        LAG(Subways_Total) OVER (ORDER BY date) AS prev_subway,
        LAG(Buses_Total) OVER (ORDER BY date) AS prev_bus,
        LAG(LIRR_Total) OVER (ORDER BY date) AS prev_lirr,
        LAG(Metro_total) OVER (ORDER BY date) AS prev_metro
    FROM daily_ridership
)
SELECT TOP 1 *
FROM t
WHERE 
    Subways_Total > prev_subway
    AND (
        Buses_Total < prev_bus
        OR LIRR_Total < prev_lirr
        OR Metro_total < prev_metro
    )
ORDER BY date;

--Monthly Total Mobility
SELECT
    DATEPART(MONTH, date) AS month_num,
    SUM(Subways_Total + Buses_Total + LIRR_Total + Metro_total +
        AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership) AS month_total
FROM daily_ridership
GROUP BY DATEPART(MONTH, date)
ORDER BY month_num;



--High Recovery Day Across All Systems
SELECT *
FROM daily_ridership
WHERE Subway_Pct_PrePandemic > 90
  AND Buses_Pct_PrePandemic > 90
  AND LIRR_Pct_PrePandemic > 90
  AND Metro_Pct_PrePandemic > 90
  AND AAR_Pct_PrePandemic > 90
  AND Bridges_and_Tunnels_Pct_PrePandemic > 90
  AND SIR_Pct_PrePandemic > 90

--Small System Spike
SELECT TOP 1
    date,
    SIR_Ridership,
    CAST(SIR_Ridership AS FLOAT) /
    (Subways_Total + Buses_Total + LIRR_Total + Metro_total +
     AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership) AS sir_share
FROM daily_ridership
ORDER BY sir_share DESC


--Largest Mobility Jump
SELECT TOP 1 *
FROM (
    SELECT
        date,
        (Subways_Total + Buses_Total + LIRR_Total + Metro_total +
         AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership)
         - LAG((Subways_Total + Buses_Total + LIRR_Total + Metro_total +
                AAR_Trips + Bridges_and_Tunnels_Traffic + SIR_Ridership))
           OVER (ORDER BY date) AS change_value
    FROM daily_ridership
) t
ORDER BY change_value DESC;

--Bus Uptick When Subway Down
WITH t AS (
    SELECT 
        date,
        Subways_Total,
        Buses_Total,
        LAG(Subways_Total) OVER (ORDER BY date) AS prev_subway,
        LAG(Buses_Total) OVER (ORDER BY date) AS prev_bus
    FROM daily_ridership
)
SELECT TOP 1 *
FROM t
WHERE 
    Subways_Total < prev_subway
    AND Buses_Total > prev_bus
ORDER BY date;
