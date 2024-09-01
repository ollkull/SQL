-- количество аэропортов по городам
select city, count(airport_name) as cuantity_of_airports
from airports_data ad 
group by city
order by count(airport_name) desc;
-- самый загруженный аэропорт по кол-ву вылетов
select ad.airport_code, count(f.flight_no) as cuantity_of_flights
from airports_data ad inner join flights f on ad.airport_code = f.departure_airport 
group by ad.airport_code 
order by count(f.flight_no) desc 
limit 1;

select departure_airport, count(flight_no) as cnt 
from flights f2 
group by departure_airport 
order by count(flight_no) desc;
-- самый загруженный аропорт по кол-ву прилетов
select ad.airport_code, count(f.flight_no) as cuantity_of_flights
from airports_data ad inner join flights f on ad.airport_code = f.arrival_airport 
group by ad.airport_code 
order by count(f.flight_no) desc 
limit 1;

select arrival_airport , count(flight_no) as cnt 
from flights f2 
group by arrival_airport  
order by count(flight_no) desc
limit 1;
-- самый загруженный аэропорт
select
    airport_code,
    sum(flight_count) as total_flights
from
    (
        select departure_airport as airport_code, count(*) as flight_count
        from flights
        group by departure_airport
        union all
        select arrival_airport as airport_code, count(*) as flight_count
        from flights
        group by arrival_airport
    ) as combined
group by airport_code
order by total_flights desc
limit 1;

-- самый длинный рейс
select flight_no, departure_airport, departure_airport_name, arrival_airport, arrival_airport_name, arrival_city, duration
from routes r 
where duration = (select max(duration) from routes);
-- самый короткий рейс
select flight_no, departure_airport, departure_airport_name, arrival_airport, arrival_airport_name, arrival_city, duration
from routes r 
where duration = (select min(duration) from routes);
-- самый загруженный маршрут
select departure_airport, arrival_airport, count(*) as flight_count
from flights f 
group by departure_airport, arrival_airport 
order by flight_count desc 
limit 1;
-- наименее загруженный маршрут
select departure_airport, arrival_airport, count(*) as flight_count
from flights f 
group by departure_airport, arrival_airport 
order by flight_count asc 
limit 1;
-- Рейсы с максимальной задержкой вылета
select flight_no, departure_airport, arrival_airport, (actual_departure - scheduled_departure) as delay
from flights f 
where actual_departure is not null and (status = 'Departed' or status = 'Arrived')
order by delay desc
limit 10;
