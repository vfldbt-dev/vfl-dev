import json
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
import os

# --- Step 1: Load catalog.json ---
catalog_path = r"C:\Users\satyabrata.mishra\Downloads\dbt_project\catalog.json"

with open(catalog_path, "r", encoding="utf-8") as f:
    catalog = json.load(f)

# --- Step 2: Prepare the PDF document ---
output_path = os.path.join(os.path.dirname(catalog_path), "data_dictionary.pdf")
doc = SimpleDocTemplate(output_path, pagesize=A4)
elements = []
styles = getSampleStyleSheet()

# --- Step 3: Iterate through models safely ---
nodes = catalog.get("nodes", {})

for model_name, model_data in nodes.items():
    # dbt Cloud catalogs may not have 'resource_type' → check for 'columns'
    if "columns" not in model_data:
        continue

    table_data = [["Column Name", "Alias (Business Name)", "Description", "Data Type"]]
    for col_name, col_data in model_data["columns"].items():
        alias = ""
        if "meta" in col_data and isinstance(col_data["meta"], dict):
            alias = col_data["meta"].get("alias", "")
        description = col_data.get("description", "")
        dtype = col_data.get("type", "")
        table_data.append([col_name, alias, description, dtype])

    elements.append(Paragraph(f"<b>Model: {model_name}</b>", styles["Heading2"]))
    elements.append(Spacer(1, 6))

    table = Table(table_data, colWidths=[100, 120, 200, 80])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#2E8B57")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("ALIGN", (0, 0), (-1, -1), "LEFT"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, 0), 9),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 6),
        ("GRID", (0, 0), (-1, -1), 0.25, colors.grey),
    ]))

    elements.append(table)
    elements.append(Spacer(1, 12))

# --- Step 4: Build the PDF ---
if elements:
    doc.build(elements)
    print(f"✅ Data dictionary generated successfully: {output_path}")
else:
    print("⚠️ No model data found in catalog.json — please verify dbt docs generation.")
