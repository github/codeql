#!/usr/bin/env python3

import os
import sys
import argparse
import subprocess
import xml.etree.ElementTree as ET

def run_codeql_analysis(codeql_path, database_path, query_path, output_dir):
    """Runs the CodeQL analysis and generates a DGML file."""
    os.makedirs(output_dir, exist_ok=True)
    command = [
        codeql_path, "database", "analyze", database_path, query_path,
        "--rerun", "--format=dgml", "--output", output_dir
    ]
    
    print(f"Running CodeQL analysis: {' '.join(command)}")
    result = subprocess.run(command, capture_output=True, text=True)

    if result.returncode == 0:
        print("Analysis completed successfully.")
    else:
        print("Analysis failed.")
        print(result.stderr)
        sys.exit(1)

    return result.returncode


def convert_dgml_to_dot(dgml_file, dot_file):
    """Converts the DGML file to DOT format using the exact original implementation."""
    print(f"Processing DGML file: {dgml_file}")

    # Read source DGML
    with open(dgml_file, "r", encoding="utf-8") as f:
        xml_content = f.read()

    root = ET.fromstring(xml_content)

    # Form dot element sequence
    body_l = ["digraph cbom {",
              "node [shape=box];"
    ]

    # Process nodes
    for node in root.find("{http://schemas.microsoft.com/vs/2009/dgml}Nodes"):
        att = node.attrib
        node_id = att['Id']
        label_parts = []
        for key, value in att.items():
            if key == 'Id':
                continue
            elif key == 'Label':
                label_parts.append(value)
            else:
                label_parts.append(f"{key}={value}")
        label = "\\n".join(label_parts)
        # Escape forward slashes and double quotes
        label = label.replace("/", "\\/")
        label = label.replace("\"", "\\\"")
        prop_l = [f'label="{label}"']
        node_s = f'nd_{node_id} [{", ".join(prop_l)}];'
        body_l.append(node_s)

    # Process edges
    for edge in root.find("{http://schemas.microsoft.com/vs/2009/dgml}Links"):
        att = edge.attrib
        edge_label = att.get("Label", "")
        edge_label = edge_label.replace("/", "\\/")
        edge_label = edge_label.replace("\"", "\\\"")
        edge_s = 'nd_{} -> nd_{} [label="{}"];'.format(
            att["Source"], att["Target"], edge_label)
        body_l.append(edge_s)

    body_l.append("}")

    # Write DOT output
    with open(dot_file, "w", encoding="utf-8") as f:
        f.write("\n".join(body_l))

    print(f"DGML file successfully converted to DOT format: {dot_file}")


def main():
    parser = argparse.ArgumentParser(description="Run CodeQL analysis and convert DGML to DOT.")
    parser.add_argument("-c", "--codeql", required=True, help="Path to CodeQL CLI executable.")
    parser.add_argument("-d", "--database", required=True, help="Path to the CodeQL database.")
    parser.add_argument("-q", "--query", required=True, help="Path to the .ql query file.")
    parser.add_argument("-o", "--output", required=True, help="Output directory for analysis results.")
    
    args = parser.parse_args()

    # Run CodeQL analysis
    run_codeql_analysis(args.codeql, args.database, args.query, args.output)

    # Locate DGML file
    dgml_file = os.path.join(args.output, "java", "print-cbom-graph.dgml")
    dot_file = dgml_file.replace(".dgml", ".dot")

    if os.path.exists(dgml_file):
        # Convert DGML to DOT
        convert_dgml_to_dot(dgml_file, dot_file)
    else:
        print(f"No DGML file found in {args.output}.")
        sys.exit(1)


if __name__ == "__main__":
    main()
