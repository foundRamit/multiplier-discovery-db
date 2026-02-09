import re
import csv

def parse_synthesis_report(report_file):
    with open(report_file, 'r') as f:
        content = f.read()
        
    # Example Regex to find Area and Power in a standard report
    area = re.search(r'Total cell area:\s+([\d.]+)', content)
    power = re.search(r'Total dynamic power:\s+([\d.]+)', content)
    
    return {
        "area": area.group(1) if area else "N/A",
        "power": power.group(1) if power else "N/A"
    }

# This allows you to scale to 50+ entries easily later