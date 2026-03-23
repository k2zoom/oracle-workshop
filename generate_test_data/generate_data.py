import requests
import oracledb
from dotenv import load_dotenv
import json
import logging
import os
from datetime import datetime
import time
from settings import CITIES

logging.basicConfig(level=logging.INFO,з format='%(asctime)s - %(levelname)s - %(message)s')
env = os.environ
DATA_URL = 'https://api.openweathermap.org/data/2.5/weather?q={}&appid={}&units=metric'

load_dotenv()

def create_bd_connection():
    try:
        conn = oracledb.connect(
            user=env.get("DB_USER"), 
            password=env.get("DB_PASSWORD"), 
            dsn=env.get("DB_DSN", "localhost:1521/XE")
        )
    except oracledb.DatabaseError as e:
        logging.error(f"Database connection error: {e}")
        return None
    else:
        return conn

def prepare_for_db(data):
    """Подготовка данных для вставки в таблицу weather_data"""
    if data:
        coord = data.get('coord', {})
        lat = coord.get('lat')
        lon = coord.get('lon')
        weather = data.get('weather', [{}])[0]
        main = data.get('main', {})
        wind = data.get('wind', {})
        clouds = data.get('clouds', {})
        sys = data.get('sys', {})
        
        return [(
            data.get('name'),                                    # city_name
            lat,                                                 # city_lat
            lon,                                                 # city_lon
            weather.get('id'),                                   # weather_id
            weather.get('main'),                                 # weather_main
            weather.get('description'),                          # weather_description
            weather.get('icon'),                                 # weather_icon
            main.get('temp'),                                    # temp_c
            main.get('feels_like'),                              # feels_like_c
            main.get('temp_min'),                                # temp_min_c
            main.get('temp_max'),                                # temp_max_c
            main.get('pressure'),                                # pressure_hpa
            main.get('humidity'),                                # humidity_percent
            main.get('sea_level'),                               # sea_level_hpa
            main.get('grnd_level'),                              # ground_level_hpa
            data.get('visibility'),                              # visibility_m
            wind.get('speed'),                                   # wind_speed_ms
            wind.get('deg'),                                     # wind_deg
            wind.get('gust'),                                    # wind_gust_ms
            clouds.get('all'),                                   # clouds_all_percent
            data.get('dt'),                                      # dt_unix
            sys.get('sunrise'),                                  # sunrise_unix
            sys.get('sunset'),                                   # sunset_unix
            data.get('timezone'),                                # timezone_offset
            sys.get('country'),                                  # country_code
            data.get('cod')                                      # cod
        )]

def get_weather_data(city):
    """Получение данных о погоде из API"""
    url = DATA_URL.format(city, env.get("WEATHER_API_KEY"))
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching weather data for {city}: {e}")
        return None

def main():
    conn = create_bd_connection()
    if not conn:
        logging.error("Failed to create database connection")
        return
    
    try:
        for city in CITIES:
            data = get_weather_data(city)
            if not data:
                logging.warning(f"Skipping {city} due to API error")
                continue
                
            prepared_data = prepare_for_db(data)
            logging.info(f'Weather data for {city}: {json.dumps(data, ensure_ascii=False)[:200]}...')
            
            with conn.cursor() as cursor:
                cursor.executemany('''
                    INSERT INTO weather_data (
                        city_name,
                        city_lat,
                        city_lon,
                        weather_id,
                        weather_main,
                        weather_description,
                        weather_icon,
                        temp_c,
                        feels_like_c,
                        temp_min_c,
                        temp_max_c,
                        pressure_hpa,
                        humidity_percent,
                        sea_level_hpa,
                        ground_level_hpa,
                        visibility_m,
                        wind_speed_ms,
                        wind_deg,
                        wind_gust_ms,
                        clouds_all_percent,
                        dt_unix,
                        sunrise_unix,
                        sunset_unix,
                        timezone_offset,
                        country_code,
                        cod
                    ) VALUES (
                        :1, :2, :3, :4, :5, :6, :7, :8, :9, :10,
                        :11, :12, :13, :14, :15, :16, :17, :18, :19, :20,
                        :21, :22, :23, :24, :25, :26
                    )
                ''', prepared_data)
                conn.commit()
                
            logging.info(f"Successfully inserted weather data for {city}")
            time.sleep(1)  # Пауза между запросами к API
            
    except Exception as e:
        logging.error(f"Error in main execution: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == '__main__':
    main()