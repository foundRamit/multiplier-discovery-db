import os
import json
from jsonschema import validate

def validate_arch_files():
    schema_path = 'data/architectures/schema.json'
    arch_dir = 'data/architectures/'
    
    with open(schema_path, 'r') as f:
        schema = json.load(f)

    for filename in os.listdir(arch_dir):
        if filename.endswith('.json') and filename != 'schema.json':
            with open(os.path.join(arch_dir, filename), 'r') as f:
                instance = json.load(f)
                try:
                    validate(instance=instance, schema=schema)
                    print(f"✅ {filename} is valid.")
                except Exception as e:
                    print(f"❌ {filename} failed: {e}")

if __name__ == "__main__":
    validate_arch_files()