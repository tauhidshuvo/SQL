-- Bismillah 

-- Act like you are appointed in Domino's Pizza Company HQ

-- CS1 : Extract only the table information
DESCRIBE orders ;
DESCRIBE pizza_types; 

-- CS2 : Total Revenue from All Orders

	WITH CTE AS (SELECT 
		ORDER_ID, O.PIZZA_ID, QUANTITY, PRICE, (QUANTITY * PRICE) AS TOTAL_PRICE
    FROM 
    ORDER_DETAILS O
    LEFT JOIN PIZZAS P
    ON O.PIZZA_ID = P.PIZZA_ID ) 
    
    SELECT ROUND(SUM(TOTAL_PRICE),2) AS TWO_DIGIT_,
    SUM(TOTAL_PRICE) AS TOTAL_REVENUE
    FROM CTE 
    -- WHERE PRICE <> TOTAL_PRICE
    ;

-- CS2 : REVENUE BY PIZZA SIZE

	SELECT 
    -- DISTINCT SIZE
    P.SIZE, 
    ROUND(SUM(P.PRICE * OD.QUANTITY),0) AS TOTAL_REVENUE
    FROM ORDER_DETAILS OD 
	JOIN PIZZAS P 
    ON OD.PIZZA_ID = P.PIZZA_ID
    GROUP BY 1
    ORDER BY 2 DESC; 
    
-- CS3 : COUNT OF ORDERS BY DAY
		WITH CTE AS (SELECT
        DATE, 
        COUNT(ORDER_ID) AS DAILY_SALES,
        RANK() OVER (ORDER BY COUNT(ORDER_ID) DESC) AS RN
        FROM 
        ORDERS
        GROUP BY 1)
        
        SELECT * 
        FROM CTE
        WHERE RN <= 5;
        
-- CS4 : COUNT OF ORDERS IN DECEMBER
		
       SELECT SUM(IDS) AS TOTAL_ORDERS_IN_DECEMBER FROM  
        (SELECT DATE,
        COUNT(ORDER_ID) AS IDS
        FROM 
        ORDERS 
        WHERE STR_TO_DATE(date, '%Y-%m-%d')  BETWEEN '2015-12-01' AND '2015-12-30' 
        GROUP BY 1) X ;
        
-- CS5 : MONTHLY PIZZA SALES

	WITH CTE AS (
    SELECT STR_TO_DATE(date, '%Y-%m-%d') AS DAYS, ORDER_ID, TIME
    FROM ORDERS) 
	SELECT 
	EXTRACT(MONTH FROM DAYS) AS MONTH, COUNT(ORDER_ID) AS TOTAL_ORDERS
    FROM CTE 
    GROUP BY 1
    ORDER BY 2 DESC;

	-- CS5 : ORDER BY TIME OF A DAY (MORNING, AFTERNOON, EVENING)
    
    WITH CTE AS (
    SELECT HOUR(STR_TO_DATE(TIME, '%H:%i:%s')) AS TIMESS, ORDER_ID
    FROM ORDERS)
    SELECT 
    CASE
		WHEN TIMESS BETWEEN 0 AND 11 THEN 'MORNING'
        WHEN TIMESS BETWEEN 12 AND 17 THEN 'AFTERNOON'
        WHEN TIMESS BETWEEN 18 AND 23 THEN 'EVENING'
	END AS TIME_OF_THE_DAY,
    COUNT(ORDER_ID) AS TOTAL_ORDERS
    FROM CTE
    GROUP BY 1
    ORDER BY 2 DESC;
    
SELECT * FROM ORDERS
    

	

-- E1:  Unknown column 'PRICE' in 'field list' - Your desire column not present in the from table
-- E2: Column 'PIZZA_ID' in field list is ambiguous (You have specify the column from it should appear)
-- E3: In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'pizza_sales_analysis.P.size'; this is incompatible with sql_mode=only_full_group_by (MUST USE GROUP BY)

    

