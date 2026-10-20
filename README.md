# Enterprise Data Warehouse

**Advanced SQL | PostgreSQL | Dimensional Modeling | Data Quality | CI/CD**

## Overview

This project demonstrates the design and validation of an enterprise-style Data Warehouse using PostgreSQL and a dimensional star schema.

It uses synthetic banking transactions to illustrate analytical data modeling, SQL-based reporting, data integrity, and automated testing.

The solution is designed as a reproducible technical portfolio project, with a focus on maintainability, data quality, and analytical correctness.

## Architecture

The Data Warehouse follows a **star schema** consisting of one fact table and three dimensions.

| Table | Purpose |
|---|---|
| `fact_transactions` | Stores banking transactions, amounts, statuses, and dimensional references |
| `dim_customer` | Stores customer attributes, segments, and regions |
| `dim_account` | Stores account types and currency information |
| `dim_date` | Provides calendar attributes for time-based analysis |

The schema uses surrogate keys, primary and foreign key constraints, uniqueness checks, and indexes for common query patterns.

## Technologies

- **PostgreSQL 16** — Relational database and analytical SQL
- **SQL** — Joins, aggregations, common table expressions (CTEs), and window functions
- **GitHub Actions** — Automated SQL validation
- **Docker-based PostgreSQL service** — Isolated test database within GitHub Actions
- **Dimensional Modeling** — Star schema design for analytical workloads

## Project Structure

```text
enterprise-data-warehouse/
├── 01_create_schema.sql
├── 02_insert_sample_data.sql
├── 03_advanced_analytics.sql
├── 04_data_quality_checks.sql
├── README.md
└── .github/
    └── workflows/
        └── sql-tests.yml
```

### 1. Schema Creation

`01_create_schema.sql`

Defines the dimensional model, including:

- Customer, account, and date dimensions
- Transaction fact table
- Primary and foreign keys
- Data integrity constraints
- Indexes supporting common access patterns

### 2. Synthetic Data Loading

`02_insert_sample_data.sql`

Loads fictional customer, account, date, and transaction records.

The dataset includes completed, failed, and pending transactions across ARS and USD accounts.

No real customer information is used.

### 3. Advanced SQL Analytics

`03_advanced_analytics.sql`

Includes analytical queries demonstrating:

- Completed transaction totals by customer and currency
- Monthly transaction summaries
- Customer rankings using `DENSE_RANK()`
- Running totals using window functions
- Transaction completion rates
- CTEs, joins, aggregations, and conditional filtering

**Financial correctness:** Transaction amounts are analyzed separately by currency to avoid combining ARS and USD without an exchange-rate conversion.

### 4. Data Quality Validation

`04_data_quality_checks.sql`

Contains checks for:

- Duplicate transaction identifiers
- Invalid or missing transaction amounts
- Invalid transaction statuses
- Missing dimensional references
- Invalid currency codes
- Inconsistent date attributes

Each query is designed to return zero rows when no issues are detected.

## Automated Testing with GitHub Actions

The repository includes a PostgreSQL-based CI workflow:

`.github/workflows/sql-tests.yml`

On supported workflow events, GitHub Actions:

1. Starts a temporary PostgreSQL 16 database.
2. Creates the dimensional schema.
3. Loads synthetic sample data.
4. Executes analytical SQL queries.
5. Runs data quality checks.
6. Validates expected record counts and completed transaction totals.

The workflow fails if a SQL execution error occurs, a data quality check returns results, or an expected aggregate does not match.

## Running Locally

**Prerequisite:** PostgreSQL with a database created for the project.

Execute the scripts in the following order:

```bash
psql -v ON_ERROR_STOP=1 -d warehouse -f 01_create_schema.sql
psql -v ON_ERROR_STOP=1 -d warehouse -f 02_insert_sample_data.sql
psql -v ON_ERROR_STOP=1 -d warehouse -f 03_advanced_analytics.sql
psql -v ON_ERROR_STOP=1 -d warehouse -f 04_data_quality_checks.sql
```

These commands assume that the `warehouse` database already exists and that PostgreSQL connection credentials are configured.

## Engineering Considerations

This project illustrates several practices relevant to enterprise data platforms:

- Separation of business identifiers and surrogate keys
- Referential integrity between facts and dimensions
- Reproducible schema and sample data initialization
- Explicit data quality validation
- Currency-aware financial aggregation
- Automated testing through CI

**Scope:** This is a small synthetic demonstration, not a production banking platform. Performance improvements from indexes have not been benchmarked against large datasets.

## Potential Extensions

Future enhancements could include:

- Incremental data loading
- Slowly Changing Dimensions (SCD Type 2)
- Query execution plan analysis with `EXPLAIN ANALYZE`
- Partitioning strategies for large fact tables
- Additional automated regression tests
- Cloud Data Warehouse deployment

---

**Victor Andres Costa Molina**

Senior Data Engineer | BI & Data Architecture

[GitHub Profile](https://github.com/vacm1973)
