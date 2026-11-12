from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]

def test_core_files_exist():
    for path in ["README.md","requirements.txt","sql/01_schema.sql",
                 "sql/02_data_quality.sql","sql/03_sales_analysis.sql","src/load_data.py"]:
        assert (ROOT/path).exists()
