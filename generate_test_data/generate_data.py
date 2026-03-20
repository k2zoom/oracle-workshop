import requests
import oracledb
from dotenv import load_dotenv
import json
import logging
import os
from datetime import datetime
import time
from settings import CITIES

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
env = os.environ
DATA_URL = 'https://api.openweathermap.org/data/2.5/weather?q={}&appid={}&units=metric'


load_dotenv()

def create_bd_connection():
    try:
        conn=oracledb.connect(user=env.get("DB_USER"), password=env.get("DB_PASSWORD"), dsn="localhost:1521/XE")
    except oracledb.DatabaseError as e:
        logging.error(f"Database connection error: {e}")
        return None
    else:
        return conn

def prepare_for_db(data):
    if data:        
        return [(
            data['name'],
            data['main'].get('temp',0),
            data['main'].get('temp_min',0),
            data['main'].get('temp_max',0),
            data['main'].get('feels_like',0),
            data['main'].get('humidity',0),
            data['main'].get('pressure',0),
            data['weather'][0].get('description', '') if data['weather'] else '',
            data['wind'].get('speed',0),
            data['wind'].get('gust', 0),
            data.get('visibility'),
            data['clouds'].get('all', 0),
            datetime.fromtimestamp(data['dt']),
            datetime.fromtimestamp(data['sys']['sunrise']) if 'sys' in data and 'sunrise' in data['sys'] else None,
            datetime.fromtimestamp(data['sys']['sunset']) if 'sys' in data and 'sunset' in data['sys'] else None
        )]

def get_weather_data(city):
    url = DATA_URL.format(city, env.get("WEATHER_API_KEY"))
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

def main():
    conn=create_bd_connection()
    for city in CITIES:
        data=get_weather_data(city)
        time.sleep(1)
        prepared_data = prepare_for_db(data)
        logging.info(f'Weather data for {data}')
        with conn.cursor() as cursor:
            cursor.executemany('''
            INSERT INTO weather(name,temp,temp_min,temp_max,feels_like,humidity,pressure,weather_description,wind_speed,
            gust,visibility,clouds,rep_dt,sunrise_dt,sunset_dt) VALUES(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15)
            ''',prepared_data)
            conn.commit()
            
        logging.info(f"Source_data: {prepare_for_db(data)}")
if __name__ == '__main__':
    main()