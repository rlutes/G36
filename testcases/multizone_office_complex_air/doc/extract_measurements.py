import re
import pandas as pd

file_path = "measurements.txt"  # Replace with the actual file path

data = []
with open(file_path, "r") as file:
    lines = file.readlines()

    for line in lines:
        # Removing leading and trailing whitespace
        line = line.strip()

        # Extracting variable names
        variable_name = re.findall(r'\b\w+\b', line)[4]

        # Extracting description
        description = re.findall(r'"([^"]*)"', line)[-1]

        # Extracting unit
        unit_match = re.search(r'unit="([^"]*)"', line)
        unit = unit_match.group(1) if unit_match else  "Boolean"

        # Extracting range
        range_str = None
        min_value_match = re.search(r'min=([0-9.]+)', line)
        min_value = min_value_match.group(1) if min_value_match else None
        max_value_match = re.search(r'max=([0-9.]+)', line)
        max_value = max_value_match.group(1) if max_value_match else None
        if min_value and max_value:
            range_str = f"{min_value}-{max_value}"
        else:
            range_str = "[0,1]"

        data.append([variable_name, description, unit, range_str])

# Create a pandas DataFrame
df = pd.DataFrame(data, columns=['Variable names', 'Description', 'Unit', 'Range'])
