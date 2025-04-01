SELECT *
FROM world_happiness_report;

#MAKE A STAGE TABLE
CREATE TABLE happy_stage
LIKE world_happiness_report;

INSERT happy_stage
SELECT *
FROM world_happiness_report;

SELECT *
FROM happy_stage;

#STANDARDIZE DATA
#MAKING ALL COLUMNS FROM RANGE MEASURED DATA A (0-10) RANGE
SELECT Social_Support, ROUND((Social_Support * 10),1) AS new_social_support
FROM happy_stage;

UPDATE happy_stage
SET Social_Support = ROUND((Social_Support * 10),1);

UPDATE happy_stage
SET Freedom = ROUND((Freedom * 10),1);

SELECT Generosity, ROUND((((Generosity + 1) / 2) * 10),2)
FROM happy_stage;

UPDATE happy_stage
SET Generosity = ROUND((((Generosity + 1) / 2) * 10),2);

UPDATE happy_stage
SET Corruption_Perception = ROUND((Corruption_Perception * 10),1);

UPDATE happy_stage
SET Education_Index = ROUND((Education_Index * 10),1);

UPDATE happy_stage
SET Public_Trust = ROUND((Public_Trust * 10),1);

SELECT Mental_Health_Index, ROUND((Mental_Health_Index / 10), 2)
FROM happy_stage;

UPDATE happy_stage
SET Mental_Health_Index = ROUND((Mental_Health_Index / 10), 2);

UPDATE happy_stage
SET Climate_Index = ROUND((Climate_Index / 10), 2);

UPDATE happy_stage
SET Political_Stability = ROUND((Political_Stability * 10),1);

#CHECK FOR DUPLICATES
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY Country, `Year`, Happiness_Score, GDP_per_Capita, Social_Support, Healthy_Life_Expectancy, Freedom, Generosity, Corruption_Perception, Unemployment_Rate, Education_Index, Population, Urbanization_Rate, Life_Satisfaction, Public_Trust, Mental_Health_Index, Income_Inequality, Public_Health_Expenditure, Climate_Index, Work_Life_Balance, Internet_Access, Crime_Rate, Political_Stability, Employment_Rate) AS row_num
FROM happy_stage
)
SELECT *
FROM duplicate_cte
WHERE row_num >  1;

WITH duplicate_year AS
(
SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY Country, `Year`) AS row_nums
FROM happy_stage
)
SELECT *
FROM duplicate_year
WHERE row_nums >  1;

#CHECK FOR NULL
SELECT *
FROM happy_stage
WHERE COALESCE(Country, 
`Year`, 
Happiness_Score, 
GDP_per_Capita, 
Social_Support, 
Healthy_Life_Expectancy, 
Freedom, Generosity, 
Corruption_Perception, 
Unemployment_Rate, 
Education_Index, 
Population, 
Urbanization_Rate, 
Life_Satisfaction, 
Public_Trust, 
Mental_Health_Index, 
Income_Inequality, 
Public_Health_Expenditure, 
Climate_Index, 
Work_Life_Balance, 
Internet_Access, 
Crime_Rate, 
Political_Stability, 
Employment_Rate) IS NULL;