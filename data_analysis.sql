-- Exploratory Data Analysis

SELECT * 
FROM zepto_product_listings.inventory
LIMIT 100;

-- Check for Null Values
SELECT *
FROM zepto_product_listings.inventory
WHERE 
category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

-- No Nulls returned

-- Different Product Categories
SELECT DISTINCT(category)
FROM zepto_product_listings.inventory
ORDER BY category;

-- Product Stock Availability
SELECT outofstock, count(sku_id)
FROM zepto_product_listings.inventory
GROUP BY outofstock;

-- Duplicate Product Names
SELECT name, count(name)
FROM zepto_product_listings.inventory
GROUP BY name
HAVING count(name) > 1
ORDER BY count(name) DESC;

-- Data Cleaning

-- Product with Price = 0
SELECT *
FROM zepto_product_listings.inventory
WHERE mrp = 0 OR discountedsellingprice = 0;

-- found 1 row with price 0, which should not happen and is not possible. For now we will delete that row.
DELETE  FROM zepto_product_listings.inventory
WHERE mrp = 0 AND sku_id = 3603;


-- Convert price to rupees from paisa
UPDATE zepto_product_listings.inventory
SET 
	mrp = mrp/100,
	discountedsellingprice = discountedsellingprice/100
WHERE sku_id > 0; 

SELECT * 
FROM zepto_product_listings.inventory
Limit 100;

-- Data Analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT Distinct(name), mrp, discountpercent
FROM zepto_product_listings.inventory
ORDER BY discountpercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT distinct(name), mrp
FROM zepto_product_listings.inventory
WHERE outofstock = 'TRUE'
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category, SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto_product_listings.inventory
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT(name), mrp, discountpercent
FROM zepto_product_listings.inventory
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, AVG(discountpercent) AS avg_discount_percent
FROM zepto_product_listings.inventory
GROUP BY category
ORDER BY avg_discount_percent DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT(name), ((mrp * 1)/weightingms) AS price_per_gm
FROM zepto_product_listings.inventory
WHERE weightingms > 100
ORDER BY price_per_gm DESC;

-- Q7.Group the products into categories like Low, Medium, Bulk based on their weight.
SELECT distinct(name), weightingms,
CASE 
	WHEN weightingms < 1000 THEN 'LOW'
	WHEN weightingms < 5000 THEN 'Medium'
    ELSE 'Bulk'
	END AS weight_category
FROM zepto_product_listings.inventory;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category, sum(availablequantity * weightingms) AS total_category_wt
FROM zepto_product_listings.inventory
GROUP BY category
ORDER BY total_category_wt DESC;
