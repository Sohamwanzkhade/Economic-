from pathlib import Path
import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
FILES = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "product_category_name_translation": "product_category_name_translation.csv",
    "geolocation": "olist_geolocation_dataset.csv",
}

def make_engine():
    load_dotenv(ROOT / ".env")
    keys = ["DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD"]
    missing = [k for k in keys if not os.getenv(k)]
    if missing:
        raise RuntimeError(f"Missing .env settings: {', '.join(missing)}")
    url = (f"postgresql+psycopg2://{os.environ['DB_USER']}:{os.environ['DB_PASSWORD']}"
           f"@{os.environ['DB_HOST']}:{os.environ['DB_PORT']}/{os.environ['DB_NAME']}")
    return create_engine(url, pool_pre_ping=True)

def main():
    engine = make_engine()
    with engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS staging"))
    for table, filename in FILES.items():
        path = RAW / filename
        if not path.exists():
            print(f"Missing {path.name}; skipping {table}")
            continue
        print(f"Loading {filename}")
        # For a fresh staging load, execute once; avoid rerunning into populated tables.
        for chunk in pd.read_csv(path, chunksize=20000):
            chunk.to_sql(table, engine, schema="staging", if_exists="append",
                         index=False, method="multi", chunksize=2000)
        print(f"Loaded staging.{table}")

if __name__ == "__main__":
    main()
