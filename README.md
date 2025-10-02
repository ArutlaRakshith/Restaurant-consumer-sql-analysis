# 🍴 Restaurant & Consumer SQL Analysis

## 📌 Project Overview
This project analyzes **restaurant and consumer behavior data** using SQL.  
It demonstrates database design, writing complex queries, and deriving business insights through **joins, subqueries, CTEs, window functions, views, and stored procedures**.  

The goal is to practice **real-world SQL problem solving** and showcase skills relevant for **Data Analyst / Data Science roles**.

---

## 🗂 Repository Contents
- **`RESTAURANT AND CONSUMER ANALYSIS.sql`** → complete SQL script (DDL + queries).  
- **`ER_Diagram.png`** → Entity Relationship Diagram of the database.  
- **`Project_Presentation.pptx`** → presentation explaining schema, queries, and insights.  
- **Datasets (CSV)**  
- **`README.md`** → this file, documentation for the project.  

---

## 🛠 Database Schema
The database consists of 5 tables:

- **Consumers** – demographic details (age, city, budget, occupation, habits).  
- **Restaurants** – restaurant attributes (location, alcohol service, parking, franchise, pricing).  
- **Ratings** – ratings given by consumers (overall, food, service).  
- **Consumer_Preferences** – cuisines preferred by each consumer.  
- **Restaurant_Cuisines** – cuisines offered by each restaurant.  

📌 ER Diagram included in this repo for visualization.  

---

## 🔍 Key SQL Features Demonstrated
✔️ **DDL & DML** – creating and managing relational tables.  
✔️ **Filtering & Aggregation** – `WHERE`, `GROUP BY`, `HAVING`, averages.  
✔️ **Joins & Subqueries** – combining datasets and deriving insights.  
✔️ **CTEs (Common Table Expressions)** – cleaner and reusable query logic.  
✔️ **Window Functions** – `ROW_NUMBER`, `RANK`, `LEAD`, `AVG OVER`.  
✔️ **Views** – reusable query definitions.  
✔️ **Stored Procedures** – parameterized queries for business scenarios.  

---

## 📊 Sample Business Questions Solved
- List highly rated Mexican restaurants in each city.  
- Find consumers who prefer Mexican cuisine but haven’t rated highly-rated Mexican restaurants.  
- Identify students with low budgets and extract their top 3 preferred cuisines.  
- Compare consumer ratings against restaurant averages and flag performance (Above/At/Below Average).  
- Rank restaurant ratings within each city using window functions.  
- Retrieve restaurant ratings above a given threshold using stored procedures.  

---

## 🚀 How to Run the Project
1. Install **MySQL 8+** (or MariaDB).  
2. Create a database:  
   ```sql
   CREATE DATABASE PROJECT;
   USE PROJECT;
3. Copy and run the script from **`RESTAURANT AND CONSUMER ANALYSIS.sql`** into your SQL client (MySQL 8+ recommended).
4. Explore queries step by step:
   - **Section A:** Basic filters (`WHERE`)
   - **Section B:** Joins & Subqueries
   - **Section C:** Aggregations & Order of Execution (`GROUP BY`, `HAVING`)
   - **Section D:** Advanced SQL (CTEs, Window Functions, Views, Stored Procedures)
   
