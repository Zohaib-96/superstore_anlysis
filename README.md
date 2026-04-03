# Superstore Sales Analysis — MySQL + Tableau + Excel

This is a sales analysis project I did on the Sample Superstore dataset.
I used MySQL to clean the data and answer business questions, Excel for
a basic dashboard, and Tableau for the final interactive dashboard.

---
## Dashboard Preview
### Tableau Dashboard
![Sale Dashboard](Tabluea/Sale%20Dashboard.png)

🔗 [View Live Tableau Dashboard](https://public.tableau.com/app/profile/zohaib.aslam/viz/Superstore_sales_dashboard_17752577200780/SaleDashboard?publish=yes)

### Excel Dashboard
<img width="581" height="485" alt="Screenshot 2026-03-06 at 12 17 31 AM" src="https://github.com/user-attachments/assets/5422f9a7-8156-45f5-9f6b-a14006eb8ced" />

---

## What the Dashboard Shows

| Section | Chart Type | What it shows |
|---------|-----------|---------------|
| Summary | KPI Cards | Total Sales: $2,261,537 · Total Orders: 9,801 |
| Region Sale | Bar Chart | West is highest, South is lowest |
| Sale Trend | Line Chart | Sales going up from 2015 to 2018 |
| Category Sale | Pie Chart | Technology makes the most money |
| Top 5 Locations | Bar Chart | California is way ahead of other states |

---

## Files in This Repo

| File | What it is |
|------|-----------|
| `Sql_analysis/superstore_analysis.sql` | All MySQL queries I wrote |
| `xlsx/superstore_analysis.xlsx` | Dataset and Excel dashboard |
| `Tabluea/Superstore_sales_dashboard.twbx` | Tableau workbook |
| `Tabluea/Sale Dashboard.png` | Dashboard screenshot |
| `README.md` | This file |

---

## Dataset

- Name: Sample Superstore
- Source: [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- Rows: 9,994 orders
- Years: 2015 to 2018
- Country: United States
- Categories: Furniture, Technology, Office Supplies

---

## Tools I Used

| Tool | What I used it for |
|------|---------|
| MySQL 8.0 | Cleaning data and writing all queries |
| MySQL Workbench | Running the queries |
| Microsoft Excel | First dashboard with pivot charts |
| Tableau Desktop | Final interactive dashboard |
| GitHub | Saving and sharing the project |

---

## Step 1 — Cleaning the Data

- Made a new database called superstore
- Renamed columns to remove spaces (example: Order ID became order_id)
- Changed date columns from text to proper date format
- Set row_id as the primary key
- Checked for NULL values
- Found and removed duplicate rows

---

## Step 2 — Exploratory Queries

- Total rows, orders, customers, products
- Average order value and profit margin
- Checked all columns for NULLs and duplicates

---

## Step 3 — Business Questions

- Which category makes the most profit?
- Which sub-categories are losing money?
- Which region performs best?
- How does giving discounts affect profit?
- Top 5 and bottom 5 states by profit

---

## Step 4 — Date Analysis

- Year over year growth using LAG()
- Month over month growth
- Which months are busiest
- Shipping delays using DATEDIFF()
- Running total of sales over time

---

## Step 5 — Customer Analysis

- How many times do customers order
- RFM scoring — scored every customer on:
  - Recency (how recently they ordered)
  - Frequency (how often they order)
  - Monetary (how much they spend)

| Label | Meaning |
|-------|---------|
| Champions | Buy often, recently, and spend a lot |
| Loyal Customers | Buy regularly and spend well |
| Potential Loyalists | New buyers who are coming back |
| At Risk | Used to buy but stopped recently |
| Lost Customers | Have not ordered in a long time |

---

## Step 6 — Views and Stored Procedures

Saved useful queries as views so I can reuse them easily.
Also made a stored procedure to get sales by region:

```sql
CALL getSaleByRegion('West');
CALL getSaleByRegion('East');
```

---

## Key Findings

- West region has the highest sales, South has the lowest
- Tables, Bookcases, and Supplies lose money even though sales look ok
- Discounts above 30% almost always result in a loss
- Sales went up every year from 2015 to 2018
- Technology is the top category for revenue
- California makes far more sales than any other state

---

## How to Run

1. Download superstore_analysis.xlsx from this repo
2. Import the data into MySQL as superstore_orders
3. Open superstore_analysis.sql in MySQL Workbench
4. Run queries from top to bottom
5. Open the Tableau file or view the live dashboard link above

---

## About Me

I am studying for a Master's in Computer Science and Data Analytics in the UK.
This project is part of my data analyst portfolio.

Skills used:
MySQL · Data Cleaning · Aggregations · Window Functions · CTEs ·
Date Functions · Views · Stored Procedures · Excel · Tableau
