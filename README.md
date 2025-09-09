# **Best Buy Mini Data Warehouse — README**

This project is the final deliverable for **Advanced SQL**. It implements a **mini data warehouse** for a Best Buy–style electronics retailer, with OLTP schema (3NF), OLAP star schema, queries, views, materialized view simulation, stored procedure for transactions, concurrency demo, and performance tuning with indexes.

---

## **✅ Prerequisites**

* **MySQL Server**: version **8.0.x** (tested on 8.0.30+).

* **MySQL Workbench**: version **8.x** (running on Windows 11).

* **Engine**: all tables use **InnoDB** (required for transactions and row-level locking).

* **User Privileges**: ability to `CREATE`, `ALTER`, `DROP`, `CREATE VIEW`, `CREATE ROUTINE`, `EVENT`, `INDEX`.

---

## **📁 Project Files**

bestbuy\_dw/

├─ 00\_env.sql                   \# Create database \+ set modes

├─ 01\_schema\_oltp.sql           \# OLTP schema (3NF, PK/FK, constraints)

├─ 02\_seed.sql                  \# Sample/mock data inserts

├─ 03\_views.sql                 \# Regular views

├─ 04\_matview.sql               \# Materialized view (simulated) \+ refresh proc

├─ 05\_proc\_place\_order\_single.sql  \# Stored procedure (transactions, ACID demo)

├─ 06\_core\_queries.sql          \# 10+ representative queries

├─ 07\_perf\_indexes.sql          \# Indexes \+ before/after EXPLAIN tests

├─ 08\_concurrency\_demo.sql      \# Two-session concurrency test

└─ 09\_cleanup.sql               \# (optional) reset/cleanup

---

## **▶️ Run Order (Workbench on Windows 11\)**

1. **00\_env.sql**

   * Creates database (`bestbuy_dw`) and sets safe SQL mode.

2. **01\_schema\_oltp.sql**

   * Defines all OLTP tables in 3NF with constraints and indexes.

3. **02\_seed.sql**

   * Inserts ≥500 rows of demo data across Customers, Products, Orders, etc.

4. **03\_views.sql**

   * Creates useful reporting views (e.g., `ProductSalesSummary`, `LowStockProducts`).

5. **04\_matview.sql**

   * Builds materialized summary table \+ refresh procedure.

6. **05\_proc\_place\_order\_single.sql**

   * Installs stored procedure for safe order placement with row locks and rollback.

7. **06\_core\_queries.sql**

   * Runs at least 10 queries demonstrating JOINs, GROUP BY, subqueries, functions.

8. **07\_perf\_indexes.sql**

   * Shows before/after EXPLAIN results and creates performance indexes.

9. **08\_concurrency\_demo.sql**

   * Run in **two Workbench tabs** to show row lock blocking and transaction isolation.

10. **09\_cleanup.sql** (optional)

* Drops database or truncates tables for a clean reset.

---

## **🧪 What to Expect**

* **Views & Mat View** → quick reporting queries without repeating logic.

* **Stored Procedure** → ACID behavior, stock validation, rollback on errors.

* **Concurrency Demo** → one session blocks another until commit (no overselling).

* **Performance Demo** → queries run faster after indexes, fewer rows scanned.

---

## **📏 Grading Checklist**

* OLTP schema (3NF) with PKs, FKs, constraints.

* ≥500 rows of sample data.

* OLAP star schema \+ ETL (included in notes or scripts).

* 10+ core queries (JOINs, aggregations, functions, subqueries/CTEs).

* 2 regular views \+ 1 materialized view simulation.

* Transactional stored procedure \+ concurrency demo.

* ≥3 helpful indexes incl. composite/covering.

* EXPLAIN before/after proof of performance improvement.

