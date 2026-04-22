"""Generate a typemodel.yml file from a CodeQL BQRS query result."""

import argparse
import csv
import subprocess
import sys
import tempfile
from pathlib import Path

HEADER = """\
# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
extensions:
  - addsTo:
      pack: microsoft/powershell-all
      extensible: typeModel
    data:
"""


def generate_type_models(output: str, codeql: str, db: str) -> None:
    """Decode a BQRS file to CSV and convert it into a typemodel YAML file."""
    with tempfile.TemporaryDirectory() as tmpdir:
        bqrs_path = Path(tmpdir) / "out.bqrs"
        query_path = Path(codeql) / "powershell" / "misc" / "GenerateFromDB.ql"
        subprocess.run(
            [
                "codeql", "query", "run", str(query_path),
                "--additional-packs", str(codeql),
                "-d", str(db),
                "-o", str(bqrs_path),
            ],
            check=True,
        )

        csv_path = Path(tmpdir) / "results.csv"
        subprocess.run(
            [
                "codeql", "bqrs", "decode",
                str(bqrs_path),
                "--no-titles",
                "--format=csv",
                "-o", str(csv_path),
            ],
            check=True,
        )

        rows = _read_csv(csv_path)

    output_path = Path(output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    lines = [
        f'      - ["{t}", "{d}", "Method[{m}].ReturnValue"]'
        for t, d, m in rows
    ]
    content = (HEADER + "\n".join(lines) + "\n") if lines else HEADER
    output_path.write_text(content, newline="\n")

def _read_csv(path: Path) -> list[tuple[str, str, str]]:
    """Read the decoded CSV and return valid (type, declaring_type, member) triples."""
    with path.open(newline="") as f:
        rows = []
        for row in csv.reader(f):
            if len(row) != 3:
                print(f"Skipping malformed row: {row}", file=sys.stderr)
                continue
            rows.append(tuple(row))
        return rows


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a typemodel.yml from a CodeQL BQRS file."
    )
    parser.add_argument("codeql", help="Path to the CodeQL checkout")
    parser.add_argument("output", help="Output path")
    parser.add_argument("db", help="Path to the CodeQL database")
    args = parser.parse_args()

    generate_type_models(args.output, args.codeql, args.db)


if __name__ == "__main__":
    main()
