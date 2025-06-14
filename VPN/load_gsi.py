import re
import pandas as pd
import argparse
from pathlib import Path

def parse_gsi_file(file_path: Path) -> pd.DataFrame:
    lines = file_path.read_text(encoding="utf-8", errors="ignore").splitlines()

    records = []
    current_point = None
    current_distance = None

    # Patterns
    re_point = re.compile(r"11\d{4}\+0*(\d+)")
    re_dist = re.compile(r"33(?:5168|6168|2108)\+(\d{8})")
    re_read = re.compile(r"32\.\.00\+(\d{8})")

    for line in lines:
        line = line.strip()

        # Point code
        if (match := re_point.match(line)):
            current_point = int(match.group(1))

        # Distance in mm → m
        if (match := re_dist.search(line)):
            current_distance = int(match.group(1)) / 10000.0

        # Readings in 0.01 mm → m
        for match in re_read.finditer(line):
            value_m = int(match.group(1)) / 10000.0
            records.append({
                "bod": current_point,
                "odecet_m": value_m,
                "vzdalenost_m": current_distance
            })

    return pd.DataFrame(records)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parse GSI level file and export to CSV.")
    parser.add_argument("--input", type=Path, required=True, help="Input GSI .TXT file")
    parser.add_argument("--output", type=Path, required=True, help="Output CSV path")
    args = parser.parse_args()

    df = parse_gsi_file(args.input)
    df.to_csv(args.output, index=False, encoding="utf-8")
    print(f"✅ Exported {len(df)} records to {args.output}")
