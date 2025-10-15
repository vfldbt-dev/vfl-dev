import json
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer

# === Load catalog.json ===
with open("target/catalog.json", "r", encoding="utf-8") as f:
    catalog = json.load(f)

# === List of models to explicitly generate PDF for ===
models_to_include = ["dm_site", "dm_item"]

# === Prepare PDF ===
doc = SimpleDocTemplate("Data_Dictionary.pdf", pagesize=A4)
styles = getSampleStyleSheet()
elements = []

elements.append(Paragraph("<b>Data Dictionary</b>", styles["Title"]))
elements.append(Spacer(1, 12))

# === Loop through nodes in catalog.json ===
for table_key, table_data in catalog.get("nodes", {}).items():
    if table_data.get("resource_type") != "model":
        continue

    table_name = table_data["name"]
    if table_name not in models_to_include:
        continue

    elements.append(Paragraph(f"<b>Table:</b> {table_name}", styles["Heading2"]))

    data = [["Column Name", "Description"]]
    columns = table_data.get("columns", {})
    for col_name, col_info in columns.items():
        desc = col_info.get("description", "—")
        data.append([col_name, desc])

    table = Table(data, colWidths=[200, 300])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#dce6f1")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.black),
        ("ALIGN", (0, 0), (-1, -1), "LEFT"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 8),
        ("BACKGROUND", (0, 1), (-1, -1), colors.white),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
    ]))
    elements.append(table)
    elements.append(Spacer(1, 12))

# === Build PDF ===
doc.build(elements)
print("✅ PDF generated successfully: Data_Dictionary.pdf")
