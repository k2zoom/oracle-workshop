import requests
import oracledb
from dotenv import load_dotenv
import json
import logging
import os
from datetime import datetime

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
        return (
            data['name'],
            data['main'].get('temp'),
            data['main'].get('feels_like'),
            data['main'].get('humidity'),
            data['main'].get('pressure'),
            data['weather'][0].get('description', '') if data['weather'] else '',
            data['wind'].get('speed'),
            data['wind'].get('gust'),
            data.get('visibility'),
            data['clouds'].get('all', 0),
            datetime.fromtimestamp(data['dt']),
            datetime.now(),
            datetime.fromtimestamp(data['sys']['sunrise']) if 'sys' in data and 'sunrise' in data['sys'] else None,
            datetime.fromtimestamp(data['sys']['sunset']) if 'sys' in data and 'sunset' in data['sys'] else None
        )

def get_weather_data(city):
    url = DATA_URL.format(city, env.get("WEATHER_API_KEY"))
    response = requests.get(url)
    response.raise_for_status()
    return response.json()


def main():
    data=get_weather_data('Moscow')
    logging.info(f"Source_data: {data}")
    logging.info(f"Data: {prepare_for_db(data)}")
if __name__ == '__main__':
    main()