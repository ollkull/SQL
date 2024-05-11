
-- общее количество за все года 
select sum(ft_patient) as total_ft_patient, 
	sum(hosp_patient) as total_hosp_patient,
	sum(mortality) as total_mortality
from tub t;

-- доля впервые заболевших отобщего количества
SELECT 
    year,
    concat(round((SUM(ft_patient) * 100.0 / SUM(ft_patient + hosp_patient)), 2), ' %') AS доля_впервые_заболевших
FROM 
    tub t 
GROUP BY 
    "year" 
order by "year" ;

-- общее кол-во пациентов и доля смертности по годам 
select year, sum(ft_patient + hosp_patient) as общее_количество_больных, 
		CONCAT(ROUND(SUM(mortality) * 100.0 / SUM(ft_patient + hosp_patient), 2), ' %') as доля_смертей 
from tub t 
group by year 
order by "year" 

-- общее количество больных, количество впервые заболевших по годам в сравнении со среднм значением
SELECT 
    year AS год,
    SUM(ft_patient + hosp_patient) AS общее_количество_больных,
    SUM(ft_patient) AS впервые_заболевшие,
    (SELECT AVG(ft_patient) FROM tub) AS среднее_колво_заболевших_впервые,
    CONCAT(ROUND((SUM(ft_patient) * 100.0 / SUM(ft_patient + hosp_patient)), 2), ' %') AS доля_впервые_заболевших,
    (SELECT CONCAT(ROUND((AVG(ft_patient) * 100.0) / AVG(ft_patient + hosp_patient), 2), ' %') FROM tub) AS средняя_доля_заболевщих_впервые
FROM 
    tub 
GROUP BY 
    "year"
order by "year";

-- сравнение смертности с предыдущим годом 
 select year, mortality, lag(mortality) over() as смертность_прошлого_года
 from tub t 
 order by "year";

-- сравнение количества впервые заболевших и смертей
SELECT 
    year,
    round(mortality * 100.0 / SUM(ft_patient) OVER (PARTITION BY year), 2) AS процент_смертей
FROM 
    tub t;

-- сравнение количества пациентов и смертей
   SELECT 
    year,
    round(mortality * 100.0 / SUM(ft_patient + hosp_patient) OVER (PARTITION BY year), 2) AS процент_смертей
FROM 
    tub t;

-- объединение таблиц
   select t.year, t.ft_patient, t.hosp_patient, t.mortality, tpt.ft_patient_per100thousand, tpt.hosp_patient_per100thousand,
   tpt.mortality_per100thousand 
   from tub t 
   join tub_per_100thousand tpt on t.year = tpt.year 

-- динамика изменений показателей по годам
SELECT 
    t.year as год,
    t.ft_patient - LAG(t.ft_patient) OVER (ORDER BY t.year) AS изменение_колва_впервые_заболевших_абзн,
    t.hosp_patient - LAG(t.hosp_patient) OVER (ORDER BY t.year) AS изменение_колва_пациентов_под_наблюдением_абзн,
    t.mortality - LAG(t.mortality) OVER (ORDER BY t.year) AS изменение_смертности_абзн,
    tpt.ft_patient_per100thousand - LAG(tpt.ft_patient_per100thousand) OVER (ORDER BY tpt.year) AS изменение_колва_впервые_заболевших_на100тыс,
    tpt.hosp_patient_per100thousand - LAG(tpt.hosp_patient_per100thousand) OVER (ORDER BY tpt.year) AS изменение_колва_пациентов_под_наблюдением_на100тыс,
    tpt.mortality_per100thousand - LAG(tpt.mortality_per100thousand) OVER (ORDER BY tpt.year) AS изменение_смертности_на100тыс
FROM 
    tub t 
JOIN 
    tub_per_100thousand tpt  ON t.year = tpt.year
order by t.year;


 


 