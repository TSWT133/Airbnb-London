# 1. Checking for errors
SELECT * FROM `airbnb-data-cleaning.London_data.Listings` LIMIT 1000

## 2. By performing a join operation between the Listings and Reviews tables, I resolved import errors in the 'last review date' field. This allowed me to accurately populate the table with the correct dates and cross-reference them against the original data
SELECT 
    listings.*,
    MAX(reviews.date) AS latest_reviews_date 
FROM 
    `airbnb-data-cleaning.London_data.Listings` AS listings
JOIN 
    `airbnb-data-cleaning.London_data.Reviews` AS reviews
ON 
    reviews.listing_id = listings.id
GROUP BY 
    listings.id, 
    listings.name, 
    listings.host_id, 
    listings.host_name, 
    listings.neighbourhood_group, 
    listings.neighbourhood, 
    listings.latitude, 
    listings.longitude, 
    listings.room_type,  
    listings.price, 
    listings.minimum_nights, 
    listings.number_of_reviews,  
    listings.last_review, 
    listings.reviews_per_month,  
    listings.calculated_host_listings_count, 
    listings.availability_365, 
    listings.number_of_reviews_ltm, 
    listings.license



## 3. Condensed values in the 'name' column of the Listings table were split apart for clearer analysis, allowing each value to have its own dedicated column.
SELECT 
    name,
    SPLIT(name, ' · ')[SAFE_OFFSET(0)] AS property_type,
    SPLIT(name, ' · ')[SAFE_OFFSET(1)] AS rating, -- Number extracted at a later stage due to multiple value types
    CAST(REGEXP_EXTRACT(COALESCE(SPLIT(name, ' · ')[SAFE_OFFSET(2)], ''), r'(\d+)') AS INT64) AS bedrooms,
    CAST(REGEXP_EXTRACT(COALESCE(SPLIT(name, ' · ')[SAFE_OFFSET(3)], ''), r'(\d+)') AS INT64) AS beds,
    SPLIT(COALESCE(SPLIT(name, ' · ')[SAFE_OFFSET(4)], ''), ' ')[OFFSET(0)] AS bath,-- Number extracted at a later stage due to multiple value types
    id, 
    host_id, 
    host_name, 
    neighbourhood, 
    latitude, 
    longitude, 
    room_type, 
    price, 
    minimum_nights, 
    number_of_reviews, 
    last_review, 
    reviews_per_month, 
    calculated_host_listings_count, 
    availability_365, 
    number_of_reviews_ltm
FROM 
    `airbnb-data-cleaning.London_data.populated_listings`

## 4. Converted data type

SELECT 
    name,
    property_type,
    CASE 
        WHEN rating = '★New' THEN NULL
        ELSE CAST(REGEXP_REPLACE(rating, '★', '') AS FLOAT64)
    END AS rating,
    bedrooms,
    beds,
    CASE 
        WHEN bath = 'shared' OR bath = 'private' THEN 0
        ELSE CAST(bath AS FLOAT64)
    END AS bath,
    id, 
    host_id, 
    host_name, 
    neighbourhood, 
    latitude, 
    longitude, 
    room_type, 
    price, 
    minimum_nights, 
    number_of_reviews, 
    last_review, 
    reviews_per_month, 
    calculated_host_listings_count, 
    availability_365, 
    number_of_reviews_ltm
FROM 
    `airbnb-data-cleaning.London_data.split_listings`



