import csv
import json
import os

# Define the taxonomy map to fill in the details automatically
taxonomy_map = {
    "MULT_00": {"category": "Array", "method": "Ripple Carry", "paper": "Parhami"},
    "MULT_01": {"category": "Tree", "method": "Dadda Reduction", "paper": "Dadda (1965)"} 
    # Logic: You can expand this based on your IDs
}

csv_file = 'data/performance/master_benchmarks.csv'
output_dir = 'data/architectures/'

with open(csv_file, 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        arch_id = row['arch_id']
        bit_width = int(row['bit_width'])
        
        # Skip if file already exists
        if os.path.exists(f"{output_dir}/{arch_id}.json"):
            print(f"Skipping {arch_id} (exists)")
            continue

        # Determine type based on ID ranges (Simple Heuristic for your 15 items)
        if int(arch_id.split('_')[1]) <= 3:
            cat, method, paper = "Array", "Ripple Carry", "Parhami"
        elif int(arch_id.split('_')[1]) <= 7:
            cat, method, paper = "Booth", "Radix-4", "Booth (1951)"
        elif int(arch_id.split('_')[1]) <= 11:
            cat, method, paper = "Tree", "Wallace", "Wallace (1964)"
        else:
            cat, method, paper = "Tree", "Dadda", "Dadda (1965)"

        data = {
            "arch_id": arch_id,
            "design_name": f"{method} {bit_width}-bit",
            "bit_width": bit_width,
            "taxonomy": { "category": cat, "radix": 2, "reduction_method": method },
            "metadata": { "source_paper": paper, "rtl_language": "Verilog" }
        }

        with open(f"{output_dir}/{arch_id}.json", 'w') as out:
            json.dump(data, out, indent=2)
            print(f"✅ Generated {arch_id}.json")