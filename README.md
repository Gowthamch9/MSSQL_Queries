# 🗄️ MSSQL_Queries  

This repository contains **SQL practice queries and complex business use case queries** written in **Microsoft SQL Server (MSSQL)** using the **AdventureWorks2019 sample database**.  

It showcases my ability to write optimized SQL queries for data analysis, reporting, and business decision-making.  

---

## 📂 Repository Structure  

- **`SQL Practice Files.`** → Contains basic to intermediate queries for practice (SELECT, WHERE, GROUP BY, ORDER BY, etc.).  
- **`Complex Queries`** → Contains advanced SQL queries solving real-world business scenarios.  

---

## 🛠️ Key SQL Concepts Demonstrated  

 ### 📘 Basic to Intermediate  
- Filtering with `WHERE` and sorting with `ORDER BY`  
- Aggregations: `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`  
- Joins: `INNER`, `LEFT`, `RIGHT`, `FULL OUTER`  
- Subqueries & Common Table Expressions (CTEs)  

### 📗 Advanced SQL Functions & Keywords  

- **Window Functions**:  
  `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`, `LAG()`, `LEAD()`, Running Totals  

- **Recursive CTEs**:  
  Useful for hierarchical data like org charts and category trees.  

- **CROSS APPLY / OUTER APPLY**:  
  Joining with subqueries or table-valued functions.  

- **PIVOT & UNPIVOT**:  
  Transforming rows into columns and vice versa.  

- **String & Date Functions**:  
  `STRING_AGG()`, `FORMAT()`, `DATEPART()`, `DATENAME()`  

- **Stored Procedures, Views & Functions**:  
  Encapsulating business logic into reusable modules.

 ### 💾 **Advanced Use Cases**  
  - Identifying Products Sales Status
  - Identifying Top 3 sales in each territory
  - Identifying Top 3 avg monthly quantity sold in each territory
