import json
import os
import yaml
from reportlab.lib.pagesizes import landscape, A4
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, PageBreak
)
from reportlab.lib.styles import getSampleStyleSheet

# === Paths (edit these if needed) ===
DBT_PROJECT_PATH = "dbt_project.yml"
CATALOG_PATH = "target/catalog.json"
OUTPUT_PDF = "Data_Dictionary.pdf"

# === Load dbt_project.yml for alias map ===
with open(DBT_PROJECT_PATH, "r", encoding="utf-8") as f:
    dbt_project = yaml.safe_load(f)

alias_map = dbt_project.get("vars", {}).get("column_alias_map", {})

# === Load dbt catalog.json ===
if not os.path.exists(CATALOG_PATH):
    raise FileNotFoundError("❌ Run `dbt docs generate` first to create target/catalog.json")

with open(CATALOG_PATH, "r", encoding="utf-8") as f:
    catalog = json.load(f)

# === Prepare PDF elements ===
styles = getSampleStyleSheet()
doc = SimpleDocTemplate(OUTPUT_PDF, pagesize=landscape(A4))
elements = []

title = Paragraph("📘 DBT Data Dictionary", styles["Title"])
elements.append(title)
elements.append(Spacer(1, 0.2 * inch))

# === Loop through each model in catalog.json ===
for model_name, model_data in catalog["nodes"].items():
    # Only include models in your project (skip seeds/sources)
    if model_name not in alias_map:
        continue

    model_title = Paragraph(f"🧱 Model: {model_name}", styles["Heading2"])
    elements.append(model_title)
    elements.append(Spacer(1, 0.1 * inch))

    columns = model_data.get("columns", {})
    rows = [["Field (DB Name)", "Business Name", "Description", "Data Type"]]

    for col, col_info in columns.items():
        business_name = alias_map[model_name].get(col, col)
        description = col_info.get("description", "")
        dtype = col_info.get("type", "")
        rows.append([col, business_name, description, dtype])

    table = Table(rows, repeatRows=1, hAlign='LEFT')
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#003366")),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 8),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('GRID', (0, 0), (-1, -1), 0.25, colors.grey),
        ('BACKGROUND', (0, 1), (-1, -1), colors.whitesmoke),
    ]))

    elements.append(table)
    elements.append(Spacer(1, 0.2 * inch))
    elements.append(PageBreak())

doc.build(elements)
print(f"✅ Data Dictionary PDF created successfully: {os.path.abspath(OUTPUT_PDF)}")
