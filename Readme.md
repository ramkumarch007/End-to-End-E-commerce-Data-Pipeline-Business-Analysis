# 📊 End-to-End E-commerce Data Pipeline & Business Analysis

## 🚀 Project Overview
This project demonstrates an end-to-end data pipeline built to transform raw API data into structured business insights. The goal is to process unstructured data and enable data-driven decision-making through analysis and visualization.

---

## 🎯 Business Problem
Businesses often collect data from APIs, but this data is raw, unstructured, and not directly usable for analysis.  
This project solves that problem by converting raw data into structured insights to understand:

- Product performance  
- Regional sales trends  
- Impact of discount strategies on revenue  

---

## 🛠️ Tech Stack
- **Python** (Pandas, Requests)
- **SQL (MySQL)** for data analysis
- **Power BI** for data visualization
- **REST API** (DummyJSON)

---

## ⚙️ Project Workflow (ETL Pipeline)

### 🔹 1. Extract
- Data extracted from REST APIs using `requests`
- Handled pagination to fetch complete datasets

### 🔹 2. Transform
- Cleaned and processed data using Pandas
- Flattened nested JSON structures
- Handled missing values and duplicates
- Renamed and structured columns for analysis

### 🔹 3. Load
- Loaded cleaned datasets into CSV files
- Further used data in SQL and Power BI for analysis

---

## 📂 Project Structure

Project/
│
├── python/
│   └── ETL.py                      # ETL pipeline Script
│
├── products.csv
├── users.csv
├── orders.csv
│
├── sql_queries/                    # SQL analysis queries
│
├── Ecommerce_Project.pbix          # Power BI report file
│
├── PowerBi reports/
│   ├── Overview.png
│   └── Product & Price Analysis.png
│
└── README.md
---

## 📊 Power BI Dashboard

The dashboard provides insights into:

- 💰 Total Revenue & Key KPIs  
- 📦 Product Performance  
- 🏷️ Category-wise Revenue Distribution  
- 🌍 Regional Sales (City & State)  
- 📉 Discount Impact on Revenue  

---

## 📊 Dashboard Preview

### Executive Overview
![Overview](PowerBi report/Overview.png)

### Product & Pricing Analysis
![Product](PowerBi report/Product & Price Analysis.png)

## 🔍 Key Insights

- Revenue is highly concentrated in specific product categories  
- Top-performing products contribute the majority of sales  
- Higher discounts do not consistently improve revenue  
- Regional performance varies significantly across locations  

---

## 🧠 Learnings

- Built an end-to-end ETL pipeline using Python  
- Gained hands-on experience with API data extraction  
- Improved data cleaning and transformation skills  
- Learned how to convert raw data into actionable business insights  
- Developed interactive dashboards for decision-making  

---

## 🚀 Future Improvements

- Add time-based analysis (trend & seasonality)  
- Automate pipeline scheduling (cron jobs / Airflow)  
- Integrate direct database loading instead of CSV  

---

## 👤 Author
**Ram Kumar Cheekati**  
