CREATE DATABASE PROJECT;
USE PROJECT;
CREATE TABLE Consumers (
    Consumer_ID VARCHAR(50) PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Latitude FLOAT,
    Longitude FLOAT,
    Smoker VARCHAR(10),
    Drink_Level VARCHAR(20),
    Transportation_Method VARCHAR(50),
    Marital_Status VARCHAR(20),
    Children VARCHAR(50),
    Age INT,
    Budget VARCHAR(20),
    Occupation VARCHAR(50)
);

CREATE TABLE Consumer_Preferences (
    Consumer_ID VARCHAR(50),
    Preferred_Cuisine VARCHAR(100),
    PRIMARY KEY (Consumer_ID, Preferred_Cuisine),
    FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID)
);

CREATE TABLE Ratings (
    Consumer_ID VARCHAR(50),
    Restaurant_ID VARCHAR(50),
    Overall_Rating TINYINT,     -- 0=Unsatisfactory, 1=Satisfactory, 2=Highly Satisfactory
    Food_Rating TINYINT,        -- 0=Unsatisfactory, 1=Satisfactory, 2=Highly Satisfactory
    Service_Rating TINYINT,     -- 0=Unsatisfactory, 1=Satisfactory, 2=Highly Satisfactory
    PRIMARY KEY (Consumer_ID, Restaurant_ID),
    FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants(Restaurant_ID)
);

CREATE TABLE Restaurants (
    Restaurant_ID VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Zip_Code VARCHAR(20),
    Latitude FLOAT,
    Longitude FLOAT,
    Alcohol_Service VARCHAR(50),   -- no alcohol, wine & beer, full bar
    Smoking_Allowed VARCHAR(50),   -- yes/no or section
    Price VARCHAR(20),             -- low, medium, high
    Franchise VARCHAR(20),
    Area VARCHAR(50),              -- open or closed
    Parking VARCHAR(50)            -- none, yes, public, valet
);

CREATE TABLE Restaurant_Cuisines (
    Restaurant_ID VARCHAR(50),
    Cuisine VARCHAR(100),
    PRIMARY KEY (Restaurant_ID, Cuisine),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants(Restaurant_ID)
);

 --                                          Using the WHERE clause to filter data based on specific  criteria.


-- 1. List all details of consumers who live in the city of 'Cuernavaca'.

SELECT * FROM Consumers WHERE City = 'Cuernavaca';

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.

SELECT Consumer_ID ,Age,Occupation FROM Consumers 
WHERE Occupation ='Student' AND Smoker ='Yes';

-- 3. List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and  have a 'Medium' price level.

SELECT Name ,City,Alcohol_Service,Price	FROM Restaurants 
WHERE Alcohol_Service = 'Wine & Beer' AND Price = 'Medium';

-- 4. Find the names and cities of all restaurants that are part of a 'Franchise'.

SELECT Name,City from Restaurants 
where Franchise = 'Yes';

/* 5 . Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory'
 (which corresponds to a value of 2, according to the data dictionary).
*/

SELECT Consumer_ID ,Restaurant_Id ,Overall_Rating  from Ratings 
WHERE Overall_Rating = 2;


--                                                               Questions JOINs with Subqueries


-- 1. List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.

SELECT R.Name ,R.City, T.Overall_Rating FROM Restaurants R 
JOIN Ratings T on R.Restaurant_ID = T.Restaurant_ID 
WHERE t.Overall_rating = 2;

-- 2.  Find the Consumer_ID and Age of consumers who have rated restaurants located in 'SanLuis Potosi'.

SELECT	 C.Consumer_ID ,C.Age FROM Consumers C
 JOIN Ratings R ON C.Consumer_ID =R.Consumer_ID 
 JOIN Restaurants T ON R.Restaurant_ID =T.Restaurant_ID 
 WHERE T.City='San Luis Potosi';

-- 3. List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.

SELECT R.NAME FROM Restaurants R 
JOIN Ratings T ON R.Restaurant_ID =T.Restaurant_ID 
JOIN  Restaurant_Cuisines C ON R.Restaurant_ID = C.Restaurant_ID 
WHERE C.Cuisine = "Mexican" AND T.Consumer_ID = 'U1001';

-- 4.Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.

SELECT * FROM Consumers C 
JOIN Consumer_Preferences P ON C.Consumer_ID = P.Consumer_ID 
WHERE P.Preferred_Cuisine ='American' AND C.Budget='Medium';


-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.

SELECT R.NAME, R.City FROM Restaurants R 
JOIN Ratings T ON R.Restaurant_ID =T.Restaurant_ID 
GROUP BY R.Restaurant_ID, R.Name, R.City
HAVING  AVG(T.Food_Rating) < (SELECT AVG(Food_Rating) FROM Ratings);

-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.

SELECT c.Consumer_ID, c.Age, c.Occupation
FROM Consumers c
WHERE EXISTS (SELECT 1 FROM Ratings rt WHERE rt.Consumer_ID=c.Consumer_ID)
AND NOT EXISTS (
      SELECT 1
      FROM Ratings rt
      JOIN Restaurant_Cuisines rc ON rt.Restaurant_ID = rc.Restaurant_ID
      WHERE rt.Consumer_ID=c.Consumer_ID AND rc.Cuisine='Italian'
  );

--  7. List restaurants (Name) that have received ratings from consumers older than 30.

SELECT R.NAME FROM Restaurants R
 JOIN RatingS T ON R.Restaurant_ID =T.Restaurant_ID 
 JOIN Consumers C ON C.Consumer_ID = T.Consumer_ID 
 WHERE C.Age >30;
 
 /* 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican'
 and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).*/
 
SELECT C.Consumer_ID ,C.Occupation FROM Consumers C JOIN Consumer_Preferences P ON C.Consumer_ID = P.Consumer_ID 
JOIN Ratings R ON C.Consumer_ID =R.Consumer_ID 
WHERE P.Preferred_Cuisine = 'Mexican' AND R.Overall_Rating < 1;

/* 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city
where at least one 'Student' consumer lives.
*/

SELECT R.NAME ,R.City FROM Restaurants R
JOIN Restaurant_Cuisines C ON R.Restaurant_ID = C.Restaurant_ID 
JOIN Ratings T ON R.Restaurant_ID = T.Restaurant_ID 
JOIN Consumers S ON T.Consumer_ID = S.Consumer_ID 
WHERE C.Cuisine = 'Pizzeria' AND R.City=S.City AND S.Occupation ='Student';

-- 10 .Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.

SELECT C.Consumer_ID , C.Age FROM Consumers C
JOIN Ratings T ON C.Consumer_ID = T.Consumer_ID 
JOIN Restaurants R ON T.Restaurant_ID = R.Restaurant_ID 
WHERE C.Drink_Level ='Social Drinkers' AND 
R.Parking = 'none';

-- 

--                                                      Questions Emphasizing WHERE Clause and Order of Execution


-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.

SELECT C.Consumer_ID ,COUNT(DISTINCT T.Restaurant_ID) AS 'COUNT OF RESTAURANT RATED' FROM Consumers C 
JOIN Ratings T ON C.Consumer_ID =T.Consumer_ID 
WHERE C.Occupation ='Student'
GROUP BY C.Consumer_ID 
HAVING COUNT(DISTINCT T.Restaurant_ID)>2;

/*2  We want to categorize consumers by an 'Engagement_Score' which is their Age divided by
10 (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but
only for consumers whose Engagement_Score would be exactly 2 and who use 'Public'
*/

SELECT Consumer_ID ,Age ,(Age/10) AS Engagement_Score FROM Consumers
 WHERE (Age/10) = 2 AND Transportation_Method='Public';

/* 3. For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name,
City, and its calculated average Overall_Rating, but only for restaurants located in
'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.
*/

SELECT R.NAME ,R.City ,AVG(T.Overall_Rating) AS AVG_RATING FROM Restaurants R 
JOIN Ratings T ON R.Restaurant_ID = T.Restaurant_ID 
WHERE R.City = 'Cuernavaca'
GROUP BY R.NAME 
HAVING AVG(T.Overall_Rating) > 1.0;

/* 4. Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any
restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings
where the Overall_Rating was 2.
*/

SELECT C.Consumer_ID ,C.Age FROM Consumers C 
JOIN Ratings T ON C.Consumer_ID = T.Consumer_ID 
WHERE C.Marital_Status ='Married' 
AND T.Food_Rating = T.Service_Rating 
AND T.Overall_Rating = 2;

/* 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers
who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in
'Ciudad Victoria'.
*/

SELECT C.Consumer_ID , C.Age ,R.NAME FROM Consumers C
JOIN Ratings T ON C.Consumer_ID = T.Consumer_ID 
JOIN Restaurants R ON T.Restaurant_ID = R.Restaurant_ID 
WHERE C.Occupation = 'Employed'
AND T.Food_Rating = 0 AND R.City='Ciudad Victoria';


--                                  Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures



/* 1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID,
Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.
*/

WITH MEX_REST AS (SELECT Consumer_ID , Age  FROM Consumers WHERE City = 'San Luis Potosi')
SELECT C.Consumer_ID, C.Age ,R.NAME AS REST_NAME ,RC.Cuisine FROM MEX_REST C 
JOIN Ratings T ON C.Consumer_ID = T.Consumer_ID 
JOIN Restaurants R ON T.Restaurant_ID = R.Restaurant_ID 
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID 
WHERE RC.Cuisine='Mexican' AND T.Overall_Rating= 2;

/* 2. For each Occupation, find the average age of consumers. Only consider consumers who
have made at least one rating. (Use a derived table to get consumers who have rated).
*/

SELECT c.Occupation,AVG(c.Age) AS Avg_Age
FROM Consumers c
JOIN (
SELECT DISTINCT Consumer_ID
FROM Ratings
) rated ON c.Consumer_ID = rated.Consumer_ID
GROUP BY c.Occupation;


/* 3 . Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each
restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID,
Overall_Rating, and the RatingRank.
*/

WITH MY_RATING AS (
SELECT R.Restaurant_ID ,T.Consumer_ID ,T.Overall_Rating ,R.City
FROM Ratings T
JOIN Restaurants R ON T.Restaurant_ID = R.Restaurant_ID
) 
SELECT Restaurant_ID, Consumer_ID, Overall_Rating,ROW_NUMBER() OVER (PARTITION BY Restaurant_ID ORDER BY Overall_Rating DESC) AS RatingRank
FROM MY_RATING;

/* 4. For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the
average Overall_Rating given by that specific consumer across all their ratings.
*/

SELECT T.Consumer_ID ,T.Restaurant_ID,T.Overall_Rating ,
AVG(T.Overall_Rating) OVER(PARTITION BY T.Consumer_ID) AS AVG_RATING FROM Ratings T;

/* 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students,
list their top 3 most preferred cuisines based on the order they appear in the
Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID,
Preferred_Cuisine to define order for ROW_NUMBER).
*/

WITH low_budget_students AS (
SELECT Consumer_ID
FROM Consumers
WHERE Occupation = 'Student' AND Budget = 'Low'),
prefs_ordered AS (
SELECT cp.Consumer_ID,cp.Preferred_Cuisine,
ROW_NUMBER() OVER (PARTITION BY cp.Consumer_ID ORDER BY cp.Preferred_Cuisine) AS rn
FROM Consumer_Preferences cp
WHERE cp.Consumer_ID IN (SELECT Consumer_ID FROM low_budget_students)
)
SELECT Consumer_ID, Preferred_Cuisine
FROM prefs_ordered
WHERE rn <= 3
ORDER BY Consumer_ID, rn;

/* 6.Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the
Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if
any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a
derived table to filter for the consumer's ratings first.
*/


WITH u1008_ratings AS (
SELECT Restaurant_ID, Overall_Rating,LEAD(Overall_Rating) OVER (ORDER BY Restaurant_ID) AS Next_Overall_Rating
FROM Ratings
WHERE Consumer_ID = 'U1008'
)
SELECT * FROM u1008_ratings;

/* 7.  Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name,
and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.*/

CREATE VIEW HIGH_RATE_MAX_REST AS
SELECT r.Restaurant_ID, r.Name, r.City
FROM Restaurants r
JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN Ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.5;

SELECT * FROM HIGH_RATE_MAX_REST ;


/* 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to
find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who have
not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.
*/

WITH mexican_pref_consumers AS (
SELECT DISTINCT Consumer_ID FROM Consumer_Preferences WHERE Preferred_Cuisine = 'Mexican')
SELECT mpc.Consumer_ID
FROM mexican_pref_consumers mpc
WHERE NOT EXISTS ( SELECT 1
  FROM Ratings rt
JOIN HighlyRatedMexicanRestaurants hrm ON rt.Restaurant_ID = hrm.Restaurant_ID
WHERE rt.Consumer_ID = mpc.Consumer_ID
);

/* Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there
are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and
Overall_Rating.
*/

DROP PROCEDURE IF EXISTS GetRestaurantRatingsAboveThreshold;
DELIMITER $$
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold(
  IN p_restaurant_id VARCHAR(50),
  IN p_min_overall TINYINT
)
BEGIN
  SELECT Consumer_ID, Overall_Rating, Food_Rating, Service_Rating
  FROM Ratings
  WHERE Restaurant_ID = p_restaurant_id
    AND Overall_Rating >= p_min_overall;
END $$
DELIMITER ;

CALL GetRestaurantRatingsAboveThreshold('132560', 1);
-- enter the Restaurant _ id 

SELECT DISTINCT Restaurant_ID FROM Ratings LIMIT 10;


/* 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there
are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and
Overall_Rating.
*/ 

WITH cuisine_rest_avg AS (
SELECT rc.Cuisine, r.Restaurant_ID, r.Name, r.City, AVG(rt.Overall_Rating) AS avg_overall
FROM Restaurant_Cuisines rc
JOIN Restaurants r ON rc.Restaurant_ID = r.Restaurant_ID
JOIN Ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY rc.Cuisine, r.Restaurant_ID, r.Name, r.City
),
ranked AS (
  SELECT cr.*, RANK() OVER (PARTITION BY Cuisine ORDER BY avg_overall DESC) AS rnk
FROM cuisine_rest_avg cr
)
SELECT Cuisine, Name AS Restaurant_Name, City, avg_overall AS Overall_Rating
FROM ranked
WHERE rnk <= 2
ORDER BY Cuisine, Overall_Rating DESC;



/* 11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their
average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their
average overall rating. For these top 5 consumers, list their Consumer_ID, their average
rating, and the number of 'Mexican' restaurants they have rated.
*/
CREATE VIEW ConsumerAverageRatings AS
SELECT Consumer_ID, AVG(Overall_Rating) AS avg_overall
FROM Ratings
GROUP BY Consumer_ID;

WITH top5 AS (
  SELECT Consumer_ID, avg_overall
  FROM ConsumerAverageRatings
  ORDER BY avg_overall DESC
  LIMIT 5
)
SELECT t.Consumer_ID, t.avg_overall,
       COUNT(DISTINCT CASE WHEN rc.Cuisine = 'Mexican' THEN r.Restaurant_ID END) AS mexican_restaurants_rated
FROM top5 t
LEFT JOIN Ratings rt ON t.Consumer_ID = rt.Consumer_ID
LEFT JOIN Restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
LEFT JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
GROUP BY t.Consumer_ID, t.avg_overall
ORDER BY t.avg_overall DESC;

SELECT * FROM ConsumerAverageRatings;


/* 12.Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that
accepts a Consumer_ID as input.
The procedure should:
1. Determine the consumer's "Spending Segment" based on their Budget:
 'Low' -> 'Budget Conscious'
 'Medium' -> 'Moderate Spender' 
 'High' -> 'Premium Spender'
 NULL or other -> 'Unknown Budget'
2. For all restaurants rated by this consumer:
 List the Restaurant_Name.
 The Overall_Rating given by this consumer.
 The average Overall_Rating this restaurant has received from all consumers(not just the input consumer).
A "Performance_Flag" indicating if the input consumer's rating for that
restaurant is 'Above Average', 'At Average', or 'Below Average' compared to
the restaurant's overall average rating.
 Rank these restaurants for the input consumer based on the Overall_Rating
they gave (highest rating = rank 1).*/


DROP PROCEDURE IF EXISTS GetConsumerSegmentAndRestaurantPerformance;
DELIMITER $$
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(IN p_consumer_id VARCHAR(50))
BEGIN
  SET @budget := (
    SELECT Budget FROM Consumers WHERE Consumer_ID = p_consumer_id LIMIT 1
  );
  SET @segment := CASE
    WHEN @budget = 'Low' THEN 'Budget Conscious'
    WHEN @budget = 'Medium' THEN 'Moderate Spender'
    WHEN @budget = 'High' THEN 'Premium Spender'
    ELSE 'Unknown Budget'
  END;
WITH rated AS (
SELECT rt.Restaurant_ID, r.Name AS Restaurant_Name, rt.Overall_Rating AS Consumer_Overall_Rating
FROM Ratings rt
JOIN Restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
WHERE rt.Consumer_ID = p_consumer_id
  ),
  rest_avg AS (
SELECT Restaurant_ID, AVG(Overall_Rating) AS Restaurant_Avg_Overall
FROM Ratings
GROUP BY Restaurant_ID
  ),
  combined AS (
SELECT rd.Restaurant_ID, rd.Restaurant_Name, rd.Consumer_Overall_Rating, ra.Restaurant_Avg_Overall
FROM rated rd
JOIN rest_avg ra ON rd.Restaurant_ID = ra.Restaurant_ID
  ),
  ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY Consumer_Overall_Rating DESC) AS Consumer_Rank,
           CASE
             WHEN Consumer_Overall_Rating > Restaurant_Avg_Overall THEN 'Above Average'
             WHEN Consumer_Overall_Rating = Restaurant_Avg_Overall THEN 'At Average'
             ELSE 'Below Average'
           END AS Performance_Flag
    FROM combined)
SELECT @segment AS Spending_Segment,Restaurant_Name,
Consumer_Overall_Rating,ROUND(Restaurant_Avg_Overall,2) AS Restaurant_Avg_Overall,
Performance_Flag,Consumer_Rank
FROM ranked
ORDER BY Consumer_Rank;
END $$
DELIMITER ;

SELECT Consumer_ID, Budget FROM Consumers LIMIT 10;

CALL GetConsumerSegmentAndRestaurantPerformance('U1001');

-- enter the Consumer_id 


/*                                                               END                                                                 */