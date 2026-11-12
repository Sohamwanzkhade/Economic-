# E-commerce Business Intelligence & Customer Analytics

Advanced end-to-end analytics portfolio project using the Olist Brazilian E-Commerce Public Dataset, PostgreSQL, Python and Power BI.

> Current status: repository scaffold and initial SQL/Python implementation. Dataset loading, analysis, DAX measures and dashboard are still to be completed and validated.

## Business questions
- How do revenue, order volume and average order value change over time?
- Which categories and sellers drive merchandise sales?
- What percentage of unique customers return to purchase?
- Which RFM customer segments can be identified?
- How do delivery delays relate to review scores?
- What are the cancellation and payment patterns?

## Stack
PostgreSQL · SQL · Python · pandas · NumPy · SQLAlchemy · Jupyter · Power BI

## Dataset
Download the [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Extract the CSV files into `data/raw/`.

Expected files: customers, orders, order_items, order_payments, order_reviews, products, sellers, geolocation and product_category_name_translation.

Dataset is licensed CC BY-NC-SA 4.0. Attribute Olist and observe non-commercial/share-alike terms. Do not redistribute raw files without checking the license.

## Setup
1. Install Python 3.11+ and PostgreSQL 15+.
2. Create a virtual environment and install dependencies:
   ```bash
   python -m venv .venv
   # Windows: .venv\\Scripts\\Activate.ps1
   # macOS/Linux: source .venv/bin/activate
   pip install -r requirements.txt
   ```
3. Copy `.env.example` to `.env` and set your PostgreSQL credentials.
4. Create database `ecommerce_bi`.
5. Run `psql -U postgres -d ecommerce_bi -f sql/01_schema.sql`.
6. Put the downloaded CSVs in `data/raw/`.
7. Run `python -m src.load_data`.

## Analytical model
Raw data lands in PostgreSQL schema `staging`. The next phase builds a dimensional model with a line-item sales fact, order-level delivery/review facts, and customer/product/seller/date dimensions. Separate fact grains prevent double-counting when joining one-to-many tables.

## Metric definitions
- Merchandise sales = sum of item price; report freight separately.
- Order count = distinct order IDs, never order-item rows.
- Unique customers / repeat purchase analysis = `customer_unique_id`, not `customer_id`.
- Late delivery = actual delivery after estimated delivery, only when both dates exist.
- Do not call sales or payment value profit: full cost/margin data is not provided.

## Project roadmap
- [x] Repository scaffold, staging schema, loader and initial SQL
- [ ] Download and validate source dataset
- [ ] Load and quality-check PostgreSQL tables
- [ ] Build dimensional model and advanced SQL analysis
- [ ] Python EDA, RFM and cohort analysis
- [ ] Power BI semantic model, DAX and interactive report
- [ ] Screenshots, tests, findings and interview documentation

## Resume integrity
Only publish measured KPIs and conclusions after executing and validating the pipeline. This is a historical public-dataset portfolio project, not a live production platform.
