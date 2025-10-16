import os
import json
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer

# === Step 1: Define target models ===
models_to_include = ["dm_site", "dm_item"]

# === Step 2: Validate that catalog.json exists ===
catalog_path = "target/catalog.json"
if not os.path.exists(catalog_path):
    print("❌ catalog.json not found! Please run 'dbt docs generate' or download it from dbt Cloud artifacts.")
    exit(1)

# === Step 3: Load catalog.json ===
with open(catalog_path, "r", encoding="utf-8") as f:
    catalog = json.load(f)

nodes = catalog.get("nodes", {})

# === Step 4: Get available models ===
available_models = [v["name"] for v in nodes.values() if v.get("resource_type") == "model"]

# === Step 5: Check for missing models ===
missing_models = [m for m in models_to_include if m not in available_models]

if missing_models:
    print("⚠️ The following models were NOT found in catalog.json:", missing_models)
    print("📄 Models available in catalog:", available_models)
    print("\nTip: Ensure your dbt Cloud job runs these models and includes 'dbt docs generate'.")
    # Continue but skip missing ones
else:
    print("✅ All target models found:", models_to_include)

# === Step 6: Prepare PDF ===
doc = SimpleDocTemplate("Data_Dictionary.pdf", pagesize=A4)
styles = getSampleStyleSheet()
elements = []

elements.append(Paragraph("<b>Data Dictionary</b>", styles["Title"]))
elements.append(Spacer(1, 12))

found_any = False

# === Step 7: Loop through models and add to PDF ===
for table_key, table_data in nodes.items():
    if table_data.get("resource_type") != "model":
        continue

    table_name = table_data["name"]
    if table_name not in models_to_include:
        continue

    found_any = True
    elements.append(Paragraph(f"<b>Table:</b> {table_name}", styles["Heading2"]))

    data = [["Column Name", "Description"]]
    columns = table_data.get("columns", {})
    for col_name, col_info in columns.items():
        desc = col_info.get("comment") or col_info.get("description") or "—"
        data.append([col_name, desc])

    table = Table(data, colWidths=[200, 300])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#dce6f1")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.black),
        ("ALIGN", (0, 0), (-1, -1), "LEFT"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 8),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
    ]))
    elements.append(table)
    elements.append(Spacer(1, 12))

if not found_any:
    print("⚠️ No matching models were found in catalog.json, so the PDF will be empty.")
else:
    doc.build(elements)
    print("✅ PDF generated successfully: Data_Dictionary.pdf")
