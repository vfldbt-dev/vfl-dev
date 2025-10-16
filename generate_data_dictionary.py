import json
import os
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet

# === Path to catalog.json ===
catalog_path = r"C:\Users\satyabrata.mishra\Downloads\dbt_project\catalog.json"
output_path = os.path.join(os.path.dirname(catalog_path), "data_dictionary.pdf")

# === Load JSON data ===
with open(catalog_path, "r", encoding="utf-8") as f:
    catalog = json.load(f)

nodes = catalog.get("nodes", {})
styles = getSampleStyleSheet()
elements = []

# === Iterate over models ===
for model_name, model_data in nodes.items():
    columns = model_data.get("columns", {})
    if not columns:
        continue

    # Heading
    elements.append(Paragraph(f"<b>{model_name}</b>", styles["Heading2"]))
    elements.append(Spacer(1, 8))

    # Table header
    table_data = [["Field Name", "Data Type", "Short Name", "Description"]]

    # Table rows
    for col, col_info in columns.items():
        col_type = col_info.get("type", "")
        col_name = col_info.get("name", "")
        col_comment = col_info.get("comment", "")
        table_data.append([col, col_type, col_name, col_comment])

    # Create table
    table = Table(table_data, colWidths=[120, 100, 150, 150])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#2E8B57")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("ALIGN", (0, 0), (-1, -1), "LEFT"),
        ("FONTSIZE", (0, 0), (-1, 0), 9),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 6),
        ("GRID", (0, 0), (-1, -1), 0.25, colors.grey),
    ]))

    elements.append(table)
    elements.append(Spacer(1, 15))

# === Build PDF ===
if elements:
    doc = SimpleDocTemplate(output_path, pagesize=A4)
    doc.build(elements)
    print(f"✅ Data dictionary generated successfully: {output_path}")
else:
    print("⚠️ No column data found in catalog.json.")
