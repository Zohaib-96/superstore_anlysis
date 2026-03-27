# 🛒 Superstore Sales Analysis — MySQL + Excel Dashboard

A complete sales analysis project combining **MySQL** for data cleaning
and analysis, and **Microsoft Excel** for an interactive dashboard.
The goal was to clean the raw data, answer business questions using SQL,
and then visualise the key findings in Excel.

---

## 📊 Dashboard Preview

<img width="581" height="485" alt="Screenshot 2026-03-06 at 12 17 31 AM" src="https://github.com/user-attachments/assets/5422f9a7-8156-45f5-9f6b-a14006eb8ced" />


### What the Dashboard Shows

The Excel dashboard has 4 charts and a summary scorecard:

| Section | Chart Type | What it shows |
|---------|-----------|---------------|
| **Summary** | KPI Cards | Total Sales: $2,261,537 · Total Orders: 9,801 |
| **Region Sale** | Bar Chart | Sales by region — West is highest, South is lowest |
| **Sale Trend Over Time** | Line Chart | Monthly sales from 2015 to 2018 — upward trend with peak in late 2018 |
| **Product Category Sale** | Pie Chart | Technology is the top revenue category |
| **Top 5 Locations Sales** | Bar Chart | California leads by far, followed by Arizona, Colorado, Alabama, Arkansas |

---

## 📁 Files in This Repo

| File | What it is |
|------|-----------|
| `superstore_analysis.xlsx` | Original dataset + Excel dashboard with pivot charts |
| `superstore_analysis.sql` | All SQL queries — cleaning, analysis, views, procedures |
| `README.md` | This file |

---

## 📋 Dataset Info

- **Name:** Sample Superstore
- **Source:** [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Rows:** 9,994 orders
- **Time Period:** 2015 – 2018
- **Country:** United States
- **Categories:** Furniture · Technology · Office Supplies

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| MySQL 8.0 | Data cleaning and all SQL analysis |
| MySQL Workbench | Writing and running queries |
| Microsoft Excel | Dashboard with pivot tables and charts |
| GitHub | Storing and sharing the project |

---

## 🧹 Step 1 — Data Cleaning & Setup (MySQL)

Before any analysis, I cleaned the raw data:

- Created a new database called `superstore`
- Renamed all columns to remove spaces
  *(example: `Order ID` → `order_id`, `Sub-Category` → `sub_category`)*
- Converted date columns from text to proper DATE format
  using `STR_TO_DATE()`
- Set `row_id` as the **Primary Key**
- Checked for NULL values across all important columns
- Checked distinct values for region, state, city, category,
  sub-category, ship mode, and country
- Found and **deleted duplicate rows** using a self-join

---

## 🔍 Step 2 — Exploratory Analysis (Queries 1–14)

- Total rows, orders, customers, and products
- Average order value and overall profit margin
- Orders per customer
- Checked for NULL values in all key columns
- Distinct values for every important column
- Duplicate row detection and removal

---

## 📈 Step 3 — Business Aggregations (Queries 15–24)

- **Overall scorecard** — revenue, profit, margin, avg discount
- **By Category** — which of the 3 categories makes the most profit?
- **By Sub-Category** — ranked by profit, including loss-makers
  *(found using `HAVING total_profit <= 0`)*
- **By Region** — which region performs best?
- **Category within Region** — cross-analysis
- **Top 5 and Bottom 5 states** by profit
- **By Customer Segment** — Consumer vs Corporate vs Home Office
- **Segment × Category** — which segment buys which category?
- **Discount Impact** — how high discounts destroy profit margin

---

## 📅 Step 4 — Date-Based Analysis (Queries 25–32)

- **Year-over-Year growth** using `LAG()` window function
- **Month-over-Month growth** using `LAG()` on monthly CTEs
- **Sales by month name** — which months are consistently busiest?
- **Quarterly seasonality** using `QUARTER()`
- **Shipping delay** — avg, min, max days per ship mode
  using `DATEDIFF(ship_date, order_date)`
- **Delivery speed buckets** — Same Day / 1–2 Days / 3–4 Days / 7+ Days
- **Running cumulative sales** using `SUM() OVER (ORDER BY ym)`

---

## 👥 Step 5 — Customer Analysis (Queries 33–35)

- **Order frequency** — how many customers ordered 1, 2, 3+ times?
- **Average orders per customer** by segment
- **RFM Scoring** — scored every customer on:
  - **R (Recency)** — days since last order
  - **F (Frequency)** — number of orders placed
  - **M (Monetary)** — total money spent
- Used `NTILE(5)` to score customers in 5 groups
- Labelled each customer as:

| Label | Meaning |
|-------|---------|
| 🏆 Champions | Ordered recently, very often, high spend |
| ⭐ Loyal Customers | Order regularly and spend well |
| 🌱 Potential Loyalists | Recent buyers with growing habit |
| ⚠️ At Risk | Used to buy often but not recently |
| ❌ Lost Customers | Have not ordered in a long time |

---

## 👁️ Step 6 — Views & Stored Procedures (Queries 37–38)

**Views — saved queries you can use like a table:**

| View Name | What it shows |
|-----------|---------------|
| `vw_business_kpis` | Revenue, profit, margin, customers, orders |
| `vw_category_performance` | Sales and profit by category/sub-category |
| `vw_region_performance` | Sales and profit by region and state |
| `vw_monthly_trend` | Month-by-month orders, sales, and profit |

**Stored Procedure — run with one line:**

```sql
CALL getSaleByRegion('West');    -- results for West region
CALL getSaleByRegion('East');    -- results for East region
CALL getSaleByRegion('Central'); -- results for Central region
CALL getSaleByRegion('South');   -- results for South region
```

---

## 💡 Key Findings

- 🌍 **West region** generates the highest sales; South is the lowest
- 📦 **Tables, Bookcases, and Supplies** lose money
  despite having decent sales volume
- 💸 **Discounts above 30%** almost always result in a loss
- 📅 **Sales trend is upward** from 2015 to 2018,
  with the biggest spike in late 2018
- 🏆 **Technology** is the top revenue category
- 📍 **California** generates far more sales than any other state

---

## ▶️ How to Run This Project

1. Download `superstore_analysis.xlsx` from this repo
2. Import the data sheet into MySQL as `superstore_orders`
3. Open `superstore_analysis.sql` in MySQL Workbench
4. Run queries from top to bottom
5. Open the Excel file to view the dashboard directly

---

## 👨‍💻 About Me

Master's student in Computer Science and Data Analytics (UK).
This is part of my data analyst portfolio.

**Skills used:**
`MySQL` · `Data Cleaning` · `Aggregations` · `Window Functions`
`CTEs` · `Date Functions` · `Views` · `Stored Procedures` · `Excel Dashboard`
