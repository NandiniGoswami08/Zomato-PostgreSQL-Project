 # Zomato Sales & Delivery Analytics Project (PostgreSQL + Power BI)

## Overview

This project analyzes simulated Zomato-style food delivery data using PostgreSQL for querying and Power BI for creating an interactive multi-page dashboard. It provides business insights into customer behavior, restaurant performance, delivery logistics, and sales trends.


## Project Structure

### Data Source

The data was imported into PostgreSQL, and then visualized using Power BI. Key tables include:

- Customers – Customer IDs and names.

- Orders – Includes order ID, customer ID, order date, total amount, dish, and a simulated rating.

- Delivery – Contains order ID, delivery ID, rider ID, delivery status, and delivery time.

- Restaurant – Restaurant names, types, and city information.

- Riders – Rider names and IDs.


### Tools Used

- PostgreSQL for data cleaning and transformation.

- Power BI for dashboard creation and visual insights.

- DAX for calculated measures and KPIs.


## SQL Query Insights

Here are 20 key queries and DAX logic used in the project:

1. Total number of customers


2. Total orders placed


3. Average order value


4. High-value customer count (> 1000 total spend)


5. Customer segmentation (Gold/Silver based on AOV)


6. Top 5 dishes ordered by "James Ruiz"


7. Monthly sales trend


8. Customer lifetime value (CLV)


9. Churned customers (2024, not active in 2025)


10. Order frequency by time slot


11. Monthly growth ratio


12. Orders without delivery


13. Restaurant revenue by city


14. Most popular dish by city


15. Monthly restaurant growth


16. Cancellation rate comparison (2024 vs 2025)


17. Peak order day by restaurant


18. Rider earnings by month


19. Rider rating distribution (simulated)


20. Order item popularity by veg/non-veg category


## Power BI Dashboard Pages

### Page 1: Dashboard Home

KPI Cards: Total Customers, Orders, AOV, High-Value Customers

Donut Chart: Customer Segmentation (Gold/Silver)

Bar Chart: Top 5 Dishes by James Ruiz

![zomato d1](https://github.com/user-attachments/assets/c0dffaee-0798-4252-92cb-d5c371a17168)


### Page 2: Customer & Order Overview

Bar Chart: CLV per Customer

Line Chart: Order Frequency by Time Slot

Column Chart: Monthly Sales Trend

Column Chart: Rider Ratings

Slicers: Customer Name, Namorder_date.

![zomato d2](https://github.com/user-attachments/assets/6ea19b7d-ec8a-4c5a-a2f5-e5857bcd0c46)


### Page 3: Order & Time Analysis

Stacked Column: Orders Without Delivery

Matrix Table: Restaurant Revenue by City

Table: Rider Monthly Earnings

![zomato d3](https://github.com/user-attachments/assets/efed94d6-b0c5-43e6-8ba1-cba4230b1de1)


### Page 4: Restaurant Analysis

Column Chart: Cancellation Rate (2024 vs 2025)

Line Chart: Monthly Revenue & Previous Month Revenue

Matrix: Restaurant Revenue Ranking

![zomato d4](https://github.com/user-attachments/assets/9ade8538-434c-4691-959d-d2a14b96c969)


### Page 5: Rider Performance & Deep Dives

Bar Chart: Popular item by season.

Treemap: Most Popular Dish by City

Stacked Bar: Rider Earnings Monthly

Heatmap: Peak Order Day by Restaurant


![zomato d5](https://github.com/user-attachments/assets/af5222e1-8358-48cb-81bc-f2015da72597)



## Conclusion

This project combines SQL data modeling and Power BI visualization to extract real-world insights from a simulated Zomato dataset. It showcases:

- Deep customer behavior analysis

- Restaurant and order performance tracking

- Rider operational insights

- Effective use of DAX, filtering, KPIs, and interactive visuals


The dashboard is dynamic, segmented by slicers (year, customer segment, restaurant), and allows for smart drilldowns across time and geography.
