 # 📌 **Project Overview**

This project involves a comprehensive analysis of a retail dataset containing over 125,000 transactions. I developed a full data pipeline—starting with raw data cleaning in Python, moving to complex business logic in SQL, and finishing with interactive and static visualizations in Python.

The goal was to transform raw transactional data into actionable insights regarding sales growth, seasonality, and customer loyalty.

# 🛠️ **Tech Stack**

Data Cleaning: Python (Pandas)

Database & Analysis: SQL (Window Functions, CTEs, Views)

Visualization: Python (Seaborn, Matplotlib, Plotly)

Environment: Jupyter Notebook / SQL Workbench

# 🧹 **Phase 1: Data Cleaning & Pre-processing (Python)**

Before analysis, I handled the "messy" aspects of the raw dataset using Pandas:

Handling Missing Values: Cleaned null records to ensure 100% data integrity.

Data Type Standardization: Converted date strings into datetime objects, enabling precise time-series analysis.

Outlier Removal: Filtered anomalies in transaction amounts to prevent skewed results in RFM scoring.

Feature Engineering: Prepared the dataset for SQL import by ensuring consistent categorical naming conventions.

# **📊 Phase 2: Business Logic & Deep Dive (SQL)**

I wrote 10-15 specialized SQL queries to address critical business questions:

## 📈 Growth & Performance
MOM (Month-Over-Month) Analysis: Tracked monthly revenue fluctuations to pinpoint growth surges.

YOY (Year-Over-Year) Analysis: Compared annual performance metrics to assess long-term health.

Quarterly Analysis: Aggregated data into Q1-Q4 buckets to identify high-performing seasons.

## **🕒 Time & Seasonality**

Day-by-Day Total Spend: Analyzed daily revenue to identify peak shopping days.

Time Analysis: Explored hourly/periodical sales patterns to understand customer shopping windows.

Weekday Trends: Identified which days of the week generate the most volume.

## **👥 Customer Insights**

Top 5 Customers: Identified highest-spending users based on total monetary value.

RFM Modeling: Utilized NTILE and CTE logic to score customers on Recency, Frequency, and Monetary value.

# **🎨 Phase 3: Visualizations & Insights (Python)**

I converted the SQL outputs into a visual dashboard to communicate findings:

RFM Segment Distribution: A countplot showing the size of each customer segment (Champions, At Risk, etc.) with value labels.

Growth Trends: Line charts showing the velocity of MOM and YOY growth.

Customer Rankings: Bar charts identifying the Top 5 customers.

## **💡 Key Business Findings**

**Retention Alert:** The RFM analysis flagged that [18.2]% of customers fall into the "At Risk" category, highlighting a need for re-engagement.

**Peak Performance:** Sales peak significantly on [Insert Day/Quarter], allowing for better inventory planning.



## 🛠️ Challenges Overcome:

* **Data Consistency:** The raw dataset had mixed date formats and null values. I used Python's `to_datetime` and `dropna` functions to ensure the time-series analysis was accurate.
* **Logic Alignment:** Initially, the RFM scores were inverted (recent customers getting low scores). I adjusted the SQL `NTILE` ordering and `CASE` statements to ensure "Champions" correctly represented our most valuable users.
* **Large Scale Aggregation:** Joining and aggregating 125,000+ rows required optimized SQL CTEs (Common Table Expressions) to maintain performance.
.
