CREATE TABLE weather_data (
    id                  NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_name           VARCHAR2(100) NOT NULL,
    city_lat            NUMBER(10, 6),
    city_lon            NUMBER(10, 6),
    weather_id          NUMBER(5),
    weather_main        VARCHAR2(50),
    weather_description VARCHAR2(100),
    weather_icon        VARCHAR2(10),
    temp_c              NUMBER(5, 2),
    feels_like_c        NUMBER(5, 2),
    temp_min_c          NUMBER(5, 2),
    temp_max_c          NUMBER(5, 2),
    pressure_hpa        NUMBER(6),
    humidity_percent    NUMBER(3),
    sea_level_hpa       NUMBER(6),
    ground_level_hpa    NUMBER(6),
    visibility_m        NUMBER(8),
    wind_speed_ms       NUMBER(6, 2),
    wind_deg            NUMBER(5),
    wind_gust_ms        NUMBER(6, 2),
    clouds_all_percent  NUMBER(3),
    dt_unix             NUMBER(10),
    sunrise_unix        NUMBER(10),
    sunset_unix         NUMBER(10),
    timezone_offset     NUMBER(6),
    country_code        VARCHAR2(2),
    cod                 NUMBER(3),
    created_date        TIMESTAMP DEFAULT SYSTIMESTAMP
);

DROP TABLE countries

CREATE TABLE countries (
    country_id       VARCHAR2(2) PRIMARY KEY,      -- ISO 3166-1 alpha-2 код (RU, US, GB)
    country_name     VARCHAR2(100) NOT NULL,
    country_code3    VARCHAR2(3),                   -- ISO 3166-1 alpha-3 код (RUS, USA)
    numeric_code     NUMBER(3),                     -- Числовой код страны
    capital_city     VARCHAR2(100),                 -- Столица
    continent        VARCHAR2(50),                  -- Континент
    region           VARCHAR2(100),                 -- Регион (Western Europe, Eastern Europe)
    population       NUMBER(15),                    -- Население
    area_km2         NUMBER(12),                    -- Площадь в км²
    currency_code    VARCHAR2(3),                   -- Код валюты (RUB, USD)
    currency_name    VARCHAR2(50),                  -- Название валюты
    phone_code       VARCHAR2(10),                  -- Телефонный код
    timezone         VARCHAR2(100),                 -- Часовой пояс
    is_active        CHAR(1) DEFAULT 'Y',           -- Активна ли страна
    created_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_date     TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE countries IS 'Справочник стран мира';
COMMENT ON COLUMN countries.country_id IS 'ISO 3166-1 alpha-2 код страны';
COMMENT ON COLUMN countries.country_name IS 'Название страны на английском';
COMMENT ON COLUMN countries.continent IS 'Название континента';
COMMENT ON COLUMN countries.is_active IS 'Признак активности (Y/N)';


CREATE TABLE regions (
    region_id        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_id       VARCHAR2(2) NOT NULL,
    region_name      VARCHAR2(200) NOT NULL,
    region_code      VARCHAR2(50),                  -- Код региона (административный)
    region_type      VARCHAR2(50),                  -- Тип (State, Province, Oblast, Region)
    population       NUMBER(15),
    area_km2         NUMBER(12),
    capital_city     VARCHAR2(100),                 -- Административный центр региона
    is_active        CHAR(1) DEFAULT 'Y',
    created_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    
    CONSTRAINT fk_regions_country FOREIGN KEY (country_id) 
        REFERENCES countries(country_id) ON DELETE CASCADE,
    CONSTRAINT uk_region_country UNIQUE (country_id, region_name)
);

DROP TABLE cities

CREATE TABLE cities (
    city_id          NUMBER(10)  PRIMARY KEY,
    country_id       VARCHAR2(2) NOT NULL,
    region_id        NUMBER(10),                    -- Может быть NULL, если город не относится к региону
    city_name        VARCHAR2(200) NOT NULL,
    city_ascii       VARCHAR2(200),                 -- Название в ASCII (для поиска)
    city_alternative VARCHAR2(200),                 -- Альтернативные названия (через запятую)
    latitude         NUMBER(10, 6),                 -- Широта
    longitude        NUMBER(10, 6),                 -- Долгота
    population       NUMBER(15),                    -- Население
    elevation        NUMBER(8),                     -- Высота над уровнем моря (метры)
    timezone         VARCHAR2(100),                 -- Часовой пояс города
    is_capital       CHAR(1) DEFAULT 'N',           -- Является ли столицей страны
    is_region_capital CHAR(1) DEFAULT 'N',          -- Является ли административным центром региона
    importance       NUMBER(2) DEFAULT 0,           -- Важность (0-10, 10 - мегаполис)
    is_active        CHAR(1) DEFAULT 'Y',
    created_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    
    CONSTRAINT fk_cities_country FOREIGN KEY (country_id) 
        REFERENCES countries(country_id) ON DELETE CASCADE,
    CONSTRAINT fk_cities_region FOREIGN KEY (region_id) 
        REFERENCES regions(region_id) ON DELETE SET NULL,
    CONSTRAINT uk_city_country UNIQUE (country_id, city_name)
);



INSERT ALL
-- РОССИЯ (регионы/области) - ID 1-8
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(1, 'RU', 'Moscow Oblast', 'MOS', 'Oblast', 7700000, 44300, 'Moscow')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(2, 'RU', 'Moscow City', 'MOW', 'Federal City', 12506468, 2511, 'Moscow')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(3, 'RU', 'Saint Petersburg', 'SPE', 'Federal City', 5383890, 1439, 'Saint Petersburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(4, 'RU', 'Leningrad Oblast', 'LEN', 'Oblast', 1850000, 84500, 'Saint Petersburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(5, 'RU', 'Novosibirsk Oblast', 'NVS', 'Oblast', 2790000, 178200, 'Novosibirsk')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(6, 'RU', 'Sverdlovsk Oblast', 'SVE', 'Oblast', 4320000, 194800, 'Yekaterinburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(7, 'RU', 'Tatarstan Republic', 'TA', 'Republic', 3894000, 67800, 'Kazan')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(8, 'RU', 'Krasnodar Krai', 'KDA', 'Krai', 5700000, 76000, 'Krasnodar')

-- ВЕЛИКОБРИТАНИЯ (графства/регионы) - ID 9-13
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(9, 'GB', 'Greater London', 'LND', 'Region', 8982000, 1572, 'London')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(10, 'GB', 'South East England', 'OSE', 'Region', 9200000, 19096, 'Oxford')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(11, 'GB', 'North West England', 'NWN', 'Region', 7300000, 14165, 'Manchester')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(12, 'GB', 'West Midlands', 'WMD', 'Region', 5900000, 13004, 'Birmingham')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(13, 'GB', 'Yorkshire and the Humber', 'YSH', 'Region', 5500000, 15420, 'Leeds')

-- ФРАНЦИЯ (регионы) - ID 14-18
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(14, 'FR', 'Île-de-France', 'IDF', 'Region', 12200000, 12012, 'Paris')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(15, 'FR', 'Auvergne-Rhône-Alpes', 'ARA', 'Region', 8000000, 69711, 'Lyon')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(16, 'FR', 'Nouvelle-Aquitaine', 'NAQ', 'Region', 6000000, 84036, 'Bordeaux')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(17, 'FR', 'Occitanie', 'OCC', 'Region', 5900000, 72724, 'Toulouse')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(18, 'FR', 'Provence-Alpes-Côte d''Azur', 'PAC', 'Region', 5100000, 31400, 'Marseille')

-- ГЕРМАНИЯ (федеральные земли) - ID 19-23
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(19, 'DE', 'Berlin', 'BE', 'State', 3769495, 891, 'Berlin')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(20, 'DE', 'Bavaria', 'BY', 'State', 13120000, 70550, 'Munich')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(21, 'DE', 'North Rhine-Westphalia', 'NW', 'State', 17930000, 34084, 'Düsseldorf')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(22, 'DE', 'Baden-Württemberg', 'BW', 'State', 11100000, 35751, 'Stuttgart')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(23, 'DE', 'Hesse', 'HE', 'State', 6300000, 21115, 'Wiesbaden')

-- ИСПАНИЯ (автономные сообщества) - ID 24-28
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(24, 'ES', 'Community of Madrid', 'MD', 'Autonomous Community', 6700000, 8028, 'Madrid')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(25, 'ES', 'Catalonia', 'CT', 'Autonomous Community', 7700000, 32108, 'Barcelona')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(26, 'ES', 'Andalusia', 'AN', 'Autonomous Community', 8500000, 87599, 'Seville')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(27, 'ES', 'Valencian Community', 'VC', 'Autonomous Community', 5100000, 23255, 'Valencia')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(28, 'ES', 'Galicia', 'GA', 'Autonomous Community', 2700000, 29574, 'Santiago de Compostela')

-- ИТАЛИЯ (регионы) - ID 29-33
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(29, 'IT', 'Lazio', 'LAZ', 'Region', 5870000, 17236, 'Rome')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(30, 'IT', 'Lombardy', 'LOM', 'Region', 10060000, 23844, 'Milan')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(31, 'IT', 'Campania', 'CAM', 'Region', 5800000, 13590, 'Naples')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(32, 'IT', 'Veneto', 'VEN', 'Region', 4900000, 18399, 'Venice')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(33, 'IT', 'Piedmont', 'PIE', 'Region', 4300000, 25402, 'Turin')

-- НИДЕРЛАНДЫ (провинции) - ID 34-38
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(34, 'NL', 'North Holland', 'NH', 'Province', 2880000, 4092, 'Haarlem')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(35, 'NL', 'South Holland', 'ZH', 'Province', 3700000, 3419, 'The Hague')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(36, 'NL', 'Utrecht', 'UT', 'Province', 1350000, 1449, 'Utrecht')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(37, 'NL', 'North Brabant', 'NB', 'Province', 2560000, 5082, '''s-Hertogenbosch')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(38, 'NL', 'Gelderland', 'GE', 'Province', 2080000, 5137, 'Arnhem')

-- АВСТРИЯ (федеральные земли) - ID 39-43
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(39, 'AT', 'Vienna', 'W', 'State', 1899055, 414, 'Vienna')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(40, 'AT', 'Lower Austria', 'NÖ', 'State', 1680000, 19178, 'St. Pölten')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(41, 'AT', 'Upper Austria', 'OÖ', 'State', 1490000, 11982, 'Linz')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(42, 'AT', 'Styria', 'ST', 'State', 1240000, 16401, 'Graz')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(43, 'AT', 'Tyrol', 'T', 'State', 760000, 12648, 'Innsbruck')

-- ЧЕХИЯ (края) - ID 44-48
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(44, 'CZ', 'Prague', 'PR', 'Region', 1324277, 496, 'Prague')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(45, 'CZ', 'Central Bohemian', 'ST', 'Region', 1400000, 11014, 'Prague')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(46, 'CZ', 'South Moravian', 'JM', 'Region', 1200000, 7195, 'Brno')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(47, 'CZ', 'Moravian-Silesian', 'MO', 'Region', 1200000, 5427, 'Ostrava')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(48, 'CZ', 'Plzeň', 'PL', 'Region', 580000, 7601, 'Plzeň')

-- ПОЛЬША (воеводства) - ID 49-53
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(49, 'PL', 'Masovian', 'MZ', 'Voivodeship', 5450000, 35579, 'Warsaw')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(50, 'PL', 'Silesian', 'SL', 'Voivodeship', 4530000, 12333, 'Katowice')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(51, 'PL', 'Greater Poland', 'WP', 'Voivodeship', 3500000, 29826, 'Poznań')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(52, 'PL', 'Lesser Poland', 'MA', 'Voivodeship', 3400000, 15183, 'Kraków')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(53, 'PL', 'Lower Silesian', 'DS', 'Voivodeship', 2900000, 19946, 'Wrocław')

-- ВЕНГРИЯ (медье) - ID 54-58
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(54, 'HU', 'Budapest', 'BU', 'Capital City', 1752286, 525, 'Budapest')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(55, 'HU', 'Pest', 'PE', 'County', 1300000, 6393, 'Budapest')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(56, 'HU', 'Borsod-Abaúj-Zemplén', 'BZ', 'County', 680000, 7247, 'Miskolc')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(57, 'HU', 'Csongrád-Csanád', 'CS', 'County', 420000, 4263, 'Szeged')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(58, 'HU', 'Hajdú-Bihar', 'HB', 'County', 560000, 6211, 'Debrecen')

-- ГРЕЦИЯ (периферии) - ID 59-63
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(59, 'GR', 'Attica', 'I', 'Region', 3828434, 3808, 'Athens')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(60, 'GR', 'Central Macedonia', 'B', 'Region', 1880000, 18811, 'Thessaloniki')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(61, 'GR', 'Thessaly', 'E', 'Region', 730000, 14037, 'Larissa')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(62, 'GR', 'Crete', 'M', 'Region', 620000, 8336, 'Heraklion')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(63, 'GR', 'Western Greece', 'G', 'Region', 680000, 11350, 'Patras')

-- ПОРТУГАЛИЯ (регионы) - ID 64-68
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(64, 'PT', 'Lisbon', 'LIS', 'Metropolitan Area', 2870000, 3002, 'Lisbon')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(65, 'PT', 'North', 'N', 'Region', 3680000, 21286, 'Porto')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(66, 'PT', 'Central', 'C', 'Region', 2280000, 28199, 'Coimbra')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(67, 'PT', 'Alentejo', 'A', 'Region', 760000, 31603, 'Évora')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(68, 'PT', 'Algarve', 'G', 'Region', 460000, 4997, 'Faro')

-- ШВЕЦИЯ (лены) - ID 69-73
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(69, 'SE', 'Stockholm', 'AB', 'County', 2370000, 6488, 'Stockholm')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(70, 'SE', 'Västra Götaland', 'O', 'County', 1700000, 23942, 'Gothenburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(71, 'SE', 'Skåne', 'M', 'County', 1360000, 11027, 'Malmö')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(72, 'SE', 'Östergötland', 'E', 'County', 460000, 10562, 'Linköping')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(73, 'SE', 'Uppsala', 'C', 'County', 380000, 8209, 'Uppsala')

-- НОРВЕГИЯ (фюльке) - ID 74-78
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(74, 'NO', 'Oslo', '03', 'County', 697549, 454, 'Oslo')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(75, 'NO', 'Viken', '30', 'County', 1240000, 24477, 'Oslo')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(76, 'NO', 'Vestland', '46', 'County', 636000, 33871, 'Bergen')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(77, 'NO', 'Trøndelag', '50', 'County', 468000, 42202, 'Trondheim')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(78, 'NO', 'Rogaland', '11', 'County', 479000, 9377, 'Stavanger')

-- ФИНЛЯНДИЯ (области) - ID 79-83
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(79, 'FI', 'Uusimaa', '18', 'Region', 1700000, 9110, 'Helsinki')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(80, 'FI', 'Pirkanmaa', '06', 'Region', 514000, 14469, 'Tampere')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(81, 'FI', 'Southwest Finland', '19', 'Region', 480000, 10623, 'Turku')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(82, 'FI', 'North Ostrobothnia', '14', 'Region', 414000, 37207, 'Oulu')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(83, 'FI', 'Central Finland', '08', 'Region', 276000, 19950, 'Jyväskylä')

-- ЯПОНИЯ (префектуры) - ID 84-88
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(84, 'JP', 'Tokyo', '13', 'Prefecture', 13960000, 2194, 'Tokyo')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(85, 'JP', 'Osaka', '27', 'Prefecture', 8830000, 1905, 'Osaka')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(86, 'JP', 'Kanagawa', '14', 'Prefecture', 9200000, 2416, 'Yokohama')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(87, 'JP', 'Aichi', '23', 'Prefecture', 7550000, 5172, 'Nagoya')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(88, 'JP', 'Hokkaido', '01', 'Prefecture', 5380000, 83424, 'Sapporo')

-- КИТАЙ (провинции) - ID 89-93
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(89, 'CN', 'Beijing', 'BJ', 'Municipality', 21540000, 16410, 'Beijing')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(90, 'CN', 'Shanghai', 'SH', 'Municipality', 24280000, 6340, 'Shanghai')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(91, 'CN', 'Guangdong', 'GD', 'Province', 126000000, 179800, 'Guangzhou')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(92, 'CN', 'Sichuan', 'SC', 'Province', 83700000, 485000, 'Chengdu')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(93, 'CN', 'Zhejiang', 'ZJ', 'Province', 64500000, 101800, 'Hangzhou')

-- ЮЖНАЯ КОРЕЯ (провинции) - ID 94-98
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(94, 'KR', 'Seoul', '11', 'Special City', 9776000, 605, 'Seoul')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(95, 'KR', 'Gyeonggi', '41', 'Province', 13500000, 10183, 'Suwon')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(96, 'KR', 'Busan', '26', 'Metropolitan City', 3400000, 770, 'Busan')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(97, 'KR', 'Incheon', '28', 'Metropolitan City', 2960000, 1064, 'Incheon')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(98, 'KR', 'Daegu', '27', 'Metropolitan City', 2450000, 884, 'Daegu')

-- ИНДИЯ (штаты) - ID 99-103
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(99, 'IN', 'Delhi', 'DL', 'Union Territory', 16787941, 1484, 'New Delhi')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(100, 'IN', 'Maharashtra', 'MH', 'State', 123000000, 307713, 'Mumbai')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(101, 'IN', 'Uttar Pradesh', 'UP', 'State', 199000000, 243290, 'Lucknow')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(102, 'IN', 'West Bengal', 'WB', 'State', 91300000, 88752, 'Kolkata')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(103, 'IN', 'Tamil Nadu', 'TN', 'State', 72100000, 130058, 'Chennai')

-- США (штаты) - ID 104-109
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(104, 'US', 'New York', 'NY', 'State', 19440000, 141297, 'Albany')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(105, 'US', 'California', 'CA', 'State', 39510000, 423967, 'Sacramento')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(106, 'US', 'Illinois', 'IL', 'State', 12670000, 149995, 'Springfield')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(107, 'US', 'Texas', 'TX', 'State', 29150000, 695662, 'Austin')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(108, 'US', 'Florida', 'FL', 'State', 21780000, 170312, 'Tallahassee')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(109, 'US', 'Pennsylvania', 'PA', 'State', 13000000, 119283, 'Harrisburg')

-- КАНАДА (провинции) - ID 110-114
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(110, 'CA', 'Ontario', 'ON', 'Province', 14750000, 1076395, 'Toronto')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(111, 'CA', 'Quebec', 'QC', 'Province', 8570000, 1542056, 'Quebec City')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(112, 'CA', 'British Columbia', 'BC', 'Province', 5140000, 944735, 'Victoria')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(113, 'CA', 'Alberta', 'AB', 'Province', 4420000, 661848, 'Edmonton')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(114, 'CA', 'Manitoba', 'MB', 'Province', 1380000, 647797, 'Winnipeg')

-- МЕКСИКА (штаты) - ID 115-119
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(115, 'MX', 'Mexico City', 'CMX', 'Federal District', 9209944, 1485, 'Mexico City')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(116, 'MX', 'Jalisco', 'JAL', 'State', 8340000, 78600, 'Guadalajara')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(117, 'MX', 'Nuevo León', 'NLE', 'State', 5470000, 64210, 'Monterrey')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(118, 'MX', 'Puebla', 'PUE', 'State', 6580000, 34290, 'Puebla')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(119, 'MX', 'Guanajuato', 'GUA', 'State', 5850000, 30607, 'Guanajuato')

-- БРАЗИЛИЯ (штаты) - ID 120-124
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(120, 'BR', 'São Paulo', 'SP', 'State', 46200000, 248219, 'São Paulo')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(121, 'BR', 'Rio de Janeiro', 'RJ', 'State', 17300000, 43780, 'Rio de Janeiro')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(122, 'BR', 'Minas Gerais', 'MG', 'State', 21200000, 586528, 'Belo Horizonte')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(123, 'BR', 'Bahia', 'BA', 'State', 14900000, 564692, 'Salvador')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(124, 'BR', 'Paraná', 'PR', 'State', 11500000, 199315, 'Curitiba')

-- АРГЕНТИНА (провинции) - ID 125-129
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(125, 'AR', 'Buenos Aires', 'B', 'Province', 17500000, 307571, 'La Plata')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(126, 'AR', 'Córdoba', 'X', 'Province', 3750000, 165321, 'Córdoba')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(127, 'AR', 'Santa Fe', 'S', 'Province', 3550000, 133007, 'Santa Fe')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(128, 'AR', 'Mendoza', 'M', 'Province', 1850000, 148827, 'Mendoza')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(129, 'AR', 'Tucumán', 'T', 'Province', 1700000, 22524, 'San Miguel de Tucumán')

-- ЧИЛИ (регионы) - ID 130-134
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(130, 'CL', 'Santiago Metropolitan', 'RM', 'Region', 7190000, 15403, 'Santiago')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(131, 'CL', 'Valparaíso', 'VS', 'Region', 1810000, 16396, 'Valparaíso')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(132, 'CL', 'Biobío', 'BI', 'Region', 1550000, 37068, 'Concepción')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(133, 'CL', 'Maule', 'ML', 'Region', 1030000, 30296, 'Talca')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(134, 'CL', 'La Araucanía', 'AR', 'Region', 957000, 31842, 'Temuco')

-- ЕГИПЕТ (губернаторства) - ID 135-139
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(135, 'EG', 'Cairo', 'C', 'Governorate', 10230000, 3085, 'Cairo')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(136, 'EG', 'Alexandria', 'ALX', 'Governorate', 5300000, 2800, 'Alexandria')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(137, 'EG', 'Giza', 'GZ', 'Governorate', 8800000, 13184, 'Giza')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(138, 'EG', 'Qalyubia', 'KB', 'Governorate', 5600000, 1124, 'Banha')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(139, 'EG', 'Dakahlia', 'DK', 'Governorate', 6200000, 3471, 'Mansoura')

-- ЮАР (провинции) - ID 140-144
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(140, 'ZA', 'Gauteng', 'GP', 'Province', 15300000, 18178, 'Johannesburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(141, 'ZA', 'Western Cape', 'WC', 'Province', 7000000, 129462, 'Cape Town')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(142, 'ZA', 'KwaZulu-Natal', 'KZN', 'Province', 11500000, 94361, 'Pietermaritzburg')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(143, 'ZA', 'Eastern Cape', 'EC', 'Province', 6600000, 168966, 'Bhisho')
INTO regions (region_id, country_id, region_name, region_code, region_type, population, area_km2, capital_city) VALUES
(144, 'ZA', 'Mpumalanga', 'MP', 'Province', 4700000, 76495, 'Nelspruit')

SELECT * FROM dual;



INSERT ALL
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES ('RU', 'Russia', 'RUS', 643, 'Moscow', 'Europe/Asia', 'Eastern Europe', 144000000, 17098242, 'RUB', 'Russian Ruble', '+7', 'UTC+2 to UTC+12')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('GB', 'United Kingdom', 'GBR', 826, 'London', 'Europe', 'Northern Europe', 67886000, 243610, 'GBP', 'British Pound', '+44', 'UTC+0')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('FR', 'France', 'FRA', 250, 'Paris', 'Europe', 'Western Europe', 67390000, 551695, 'EUR', 'Euro', '+33', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('DE', 'Germany', 'DEU', 276, 'Berlin', 'Europe', 'Western Europe', 83190500, 357022, 'EUR', 'Euro', '+49', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('ES', 'Spain', 'ESP', 724, 'Madrid', 'Europe', 'Southern Europe', 47350000, 505992, 'EUR', 'Euro', '+34', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('IT', 'Italy', 'ITA', 380, 'Rome', 'Europe', 'Southern Europe', 60360000, 301340, 'EUR', 'Euro', '+39', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('NL', 'Netherlands', 'NLD', 528, 'Amsterdam', 'Europe', 'Western Europe', 17440000, 41543, 'EUR', 'Euro', '+31', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('AT', 'Austria', 'AUT', 040, 'Vienna', 'Europe', 'Western Europe', 8900000, 83871, 'EUR', 'Euro', '+43', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('CZ', 'Czech Republic', 'CZE', 203, 'Prague', 'Europe', 'Central Europe', 10700000, 78867, 'CZK', 'Czech Koruna', '+420', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('PL', 'Poland', 'POL', 616, 'Warsaw', 'Europe', 'Central Europe', 38380000, 312696, 'PLN', 'Polish Zloty', '+48', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('HU', 'Hungary', 'HUN', 348, 'Budapest', 'Europe', 'Central Europe', 9660000, 93028, 'HUF', 'Hungarian Forint', '+36', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('GR', 'Greece', 'GRC', 300, 'Athens', 'Europe', 'Southern Europe', 10410000, 131957, 'EUR', 'Euro', '+30', 'UTC+2')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('PT', 'Portugal', 'PRT', 620, 'Lisbon', 'Europe', 'Southern Europe', 10290000, 92090, 'EUR', 'Euro', '+351', 'UTC+0')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('SE', 'Sweden', 'SWE', 752, 'Stockholm', 'Europe', 'Northern Europe', 10380000, 450295, 'SEK', 'Swedish Krona', '+46', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('NO', 'Norway', 'NOR', 578, 'Oslo', 'Europe', 'Northern Europe', 5420000, 385207, 'NOK', 'Norwegian Krone', '+47', 'UTC+1')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('FI', 'Finland', 'FIN', 246, 'Helsinki', 'Europe', 'Northern Europe', 5520000, 338424, 'EUR', 'Euro', '+358', 'UTC+2')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('JP', 'Japan', 'JPN', 392, 'Tokyo', 'Asia', 'Eastern Asia', 125800000, 377930, 'JPY', 'Japanese Yen', '+81', 'UTC+9')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('CN', 'China', 'CHN', 156, 'Beijing', 'Asia', 'Eastern Asia', 1412000000, 9596960, 'CNY', 'Chinese Yuan', '+86', 'UTC+8')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('KR', 'South Korea', 'KOR', 410, 'Seoul', 'Asia', 'Eastern Asia', 51780000, 100210, 'KRW', 'South Korean Won', '+82', 'UTC+9')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('IN', 'India', 'IND', 356, 'New Delhi', 'Asia', 'Southern Asia', 1380000000, 3287263, 'INR', 'Indian Rupee', '+91', 'UTC+5:30')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('SG', 'Singapore', 'SGP', 702, 'Singapore', 'Asia', 'Southeast Asia', 5450000, 728, 'SGD', 'Singapore Dollar', '+65', 'UTC+8')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('TH', 'Thailand', 'THA', 764, 'Bangkok', 'Asia', 'Southeast Asia', 69800000, 513120, 'THB', 'Thai Baht', '+66', 'UTC+7')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('AE', 'United Arab Emirates', 'ARE', 784, 'Abu Dhabi', 'Asia', 'Western Asia', 9890000, 83600, 'AED', 'UAE Dirham', '+971', 'UTC+4')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('TR', 'Turkey', 'TUR', 792, 'Ankara', 'Asia/Europe', 'Western Asia', 84300000, 783562, 'TRY', 'Turkish Lira', '+90', 'UTC+3')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('IL', 'Israel', 'ISR', 376, 'Jerusalem', 'Asia', 'Western Asia', 9210000, 20770, 'ILS', 'Israeli Shekel', '+972', 'UTC+2')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('US', 'United States', 'USA', 840, 'Washington', 'North America', 'North America', 331900000, 9833520, 'USD', 'US Dollar', '+1', 'UTC-5 to UTC-10')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('CA', 'Canada', 'CAN', 124, 'Ottawa', 'North America', 'North America', 38250000, 9984670, 'CAD', 'Canadian Dollar', '+1', 'UTC-3.5 to UTC-8')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('MX', 'Mexico', 'MEX', 484, 'Mexico City', 'North America', 'Central America', 128900000, 1964375, 'MXN', 'Mexican Peso', '+52', 'UTC-6 to UTC-8')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('BR', 'Brazil', 'BRA', 076, 'Brasília', 'South America', 'South America', 213000000, 8515767, 'BRL', 'Brazilian Real', '+55', 'UTC-2 to UTC-5')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('AR', 'Argentina', 'ARG', 032, 'Buenos Aires', 'South America', 'South America', 45195777, 2780400, 'ARS', 'Argentine Peso', '+54', 'UTC-3')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('CL', 'Chile', 'CHL', 152, 'Santiago', 'South America', 'South America', 19100000, 756102, 'CLP', 'Chilean Peso', '+56', 'UTC-3 to UTC-5')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('EG', 'Egypt', 'EGY', 818, 'Cairo', 'Africa', 'Northern Africa', 102000000, 1001450, 'EGP', 'Egyptian Pound', '+20', 'UTC+2')
	INTO countries (country_id, country_name, country_code3, numeric_code, capital_city, continent, region, population, area_km2, currency_code, currency_name, phone_code, timezone) VALUES('ZA', 'South Africa', 'ZAF', 710, 'Pretoria', 'Africa', 'Southern Africa', 59300000, 1221037, 'ZAR', 'South African Rand', '+27', 'UTC+2')
SELECT * FROM dual;

SELECT * FROM cities




-- Обновить города, добавив связь с регионами (пример)
UPDATE cities c
SET region_id = (
    SELECT r.region_id 
    FROM regions r 
    WHERE r.country_id = c.country_id 
      AND r.region_name LIKE '%' || c.city_name || '%'
      AND ROWNUM = 1
)
WHERE EXISTS (
    SELECT 1 FROM regions r 
    WHERE r.country_id = c.country_id 
      AND r.region_name LIKE '%' || c.city_name || '%'
);


INSERT ALL
-- Россия (ID 1-5)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(1, 'RU', 'Moscow', 'Moscow', 55.7558, 37.6173, 12506468, 'Europe/Moscow', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(2, 'RU', 'Saint Petersburg', 'Saint Petersburg', 59.9343, 30.3351, 5383890, 'Europe/Moscow', 'N', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(3, 'RU', 'Novosibirsk', 'Novosibirsk', 55.0084, 82.9357, 1620162, 'Asia/Novosibirsk', 'N', 7)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(4, 'RU', 'Yekaterinburg', 'Yekaterinburg', 56.8389, 60.6057, 1493749, 'Asia/Yekaterinburg', 'N', 7)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(5, 'RU', 'Kazan', 'Kazan', 55.7887, 49.1221, 1257341, 'Europe/Moscow', 'N', 7)
-- Европа (ID 6-20)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(6, 'GB', 'London', 'London', 51.5074, -0.1278, 8982000, 'Europe/London', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(7, 'FR', 'Paris', 'Paris', 48.8566, 2.3522, 2148327, 'Europe/Paris', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(8, 'DE', 'Berlin', 'Berlin', 52.5200, 13.4050, 3769495, 'Europe/Berlin', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(9, 'ES', 'Madrid', 'Madrid', 40.4168, -3.7038, 3223334, 'Europe/Madrid', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(10, 'IT', 'Rome', 'Rome', 41.9028, 12.4964, 2873000, 'Europe/Rome', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(11, 'NL', 'Amsterdam', 'Amsterdam', 52.3702, 4.8952, 872680, 'Europe/Amsterdam', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(12, 'AT', 'Vienna', 'Vienna', 48.2082, 16.3738, 1899055, 'Europe/Vienna', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(13, 'CZ', 'Prague', 'Prague', 50.0755, 14.4378, 1324277, 'Europe/Prague', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(14, 'PL', 'Warsaw', 'Warsaw', 52.2297, 21.0122, 1790658, 'Europe/Warsaw', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(15, 'HU', 'Budapest', 'Budapest', 47.4979, 19.0402, 1752286, 'Europe/Budapest', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(16, 'GR', 'Athens', 'Athens', 37.9838, 23.7275, 664046, 'Europe/Athens', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(17, 'PT', 'Lisbon', 'Lisbon', 38.7223, -9.1393, 544851, 'Europe/Lisbon', 'Y', 7)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(18, 'SE', 'Stockholm', 'Stockholm', 59.3293, 18.0686, 975551, 'Europe/Stockholm', 'Y', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(19, 'NO', 'Oslo', 'Oslo', 59.9139, 10.7522, 697549, 'Europe/Oslo', 'Y', 7)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(20, 'FI', 'Helsinki', 'Helsinki', 60.1699, 24.9384, 658864, 'Europe/Helsinki', 'Y', 7)
-- Азия (ID 21-30)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(21, 'JP', 'Tokyo', 'Tokyo', 35.6762, 139.6503, 13960000, 'Asia/Tokyo', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(22, 'CN', 'Beijing', 'Beijing', 39.9042, 116.4074, 21540000, 'Asia/Shanghai', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(23, 'KR', 'Seoul', 'Seoul', 37.5665, 126.9780, 9776000, 'Asia/Seoul', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(24, 'CN', 'Shanghai', 'Shanghai', 31.2304, 121.4737, 24280000, 'Asia/Shanghai', 'N', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(25, 'IN', 'Delhi', 'Delhi', 28.7041, 77.1025, 16787941, 'Asia/Kolkata', 'Y', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(26, 'SG', 'Singapore', 'Singapore', 1.3521, 103.8198, 5703600, 'Asia/Singapore', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(27, 'TH', 'Bangkok', 'Bangkok', 13.7563, 100.5018, 8281000, 'Asia/Bangkok', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(28, 'AE', 'Dubai', 'Dubai', 25.2048, 55.2708, 3331420, 'Asia/Dubai', 'N', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(29, 'TR', 'Istanbul', 'Istanbul', 41.0082, 28.9784, 15462452, 'Europe/Istanbul', 'N', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(30, 'IL', 'Jerusalem', 'Jerusalem', 31.7683, 35.2137, 936425, 'Asia/Jerusalem', 'Y', 7)
-- Северная Америка (ID 31-35)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(31, 'US', 'New York', 'New York', 40.7128, -74.0060, 8419000, 'America/New_York', 'N', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(32, 'US', 'Los Angeles', 'Los Angeles', 34.0522, -118.2437, 3980000, 'America/Los_Angeles', 'N', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(33, 'US', 'Chicago', 'Chicago', 41.8781, -87.6298, 2716000, 'America/Chicago', 'N', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(34, 'CA', 'Toronto', 'Toronto', 43.6532, -79.3832, 2930000, 'America/Toronto', 'N', 8)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(35, 'MX', 'Mexico City', 'Mexico City', 19.4326, -99.1332, 9209944, 'America/Mexico_City', 'Y', 10)
-- Южная Америка (ID 36-38)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(36, 'BR', 'Sao Paulo', 'Sao Paulo', -23.5505, -46.6333, 12330000, 'America/Sao_Paulo', 'N', 10)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(37, 'AR', 'Buenos Aires', 'Buenos Aires', -34.6037, -58.3816, 2891000, 'America/Argentina/Buenos_Aires', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(38, 'CL', 'Santiago', 'Santiago', -33.4489, -70.6693, 6197000, 'America/Santiago', 'Y', 8)
-- Африка (ID 39-40)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(39, 'EG', 'Cairo', 'Cairo', 30.0444, 31.2357, 10230000, 'Africa/Cairo', 'Y', 9)
INTO cities (city_id, country_id, city_name, city_ascii, latitude, longitude, population, timezone, is_capital, importance) VALUES
(40, 'ZA', 'Cape Town', 'Cape Town', -33.9249, 18.4241, 433688, 'Africa/Johannesburg', 'N', 7)
SELECT * FROM dual;



CREATE OR REPLACE FUNCTION search_cities(
    p_search_term VARCHAR2,
    p_country_id VARCHAR2 DEFAULT NULL,
    p_min_population NUMBER DEFAULT NULL
) RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT 
            c.city_name,
            cnt.country_name,
            c.population,
            c.latitude,
            c.longitude
        FROM cities c
        JOIN countries cnt ON c.country_id = cnt.country_id
        WHERE (UPPER(c.city_name) LIKE '%' || UPPER(p_search_term) || '%'
               OR UPPER(c.city_ascii) LIKE '%' || UPPER(p_search_term) || '%')
          AND (p_country_id IS NULL OR c.country_id = p_country_id)
          AND (p_min_population IS NULL OR c.population >= p_min_population)
          AND c.is_active = 'Y'
        ORDER BY c.importance DESC, c.population DESC;
    
    RETURN v_cursor;
END search_cities;


SELECT * FROM WEATHER_DATA wd 
