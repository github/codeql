#!/usr/bin/python3

# This script generates a data extensions model for a given library in codeql database form
# Currently only typeModels are generated

import sys
import argparse
import subprocess
from pathlib import Path
import tempfile
import json


def parse_args():
    parser = argparse.ArgumentParser(
        description="Generates a data extensions model from a Ruby CodeQL database"
    )
    parser.add_argument("database_path", help="filepath to a Ruby CodeQL database")
    parser.add_argument(
        "-o",
        "--output",
        required=False,
        metavar="output_file",
        help="if provided, the model will be written to this file",
    )
    parser.add_argument(
        "-c",
        "--codeql",
        required=False,
        metavar="codeql_command",
        default="codeql",
        help="if provided, use this command to invoke codeql",
    )
    parser.add_argument(
        "-w",
        "--overwrite",
        action="store_true",
        help="if provided, use this command to invoke codeql",
    )
    return parser.parse_args()


def die(msg):
    sys.stderr.write("Error: " + msg + "\n")
    sys.exit(1)


def main():
    args = parse_args()

    output_path = args.output
    check_output_path(output_path, args.overwrite)

    database_path = Path(args.database_path).absolute()
    check_database_exists(database_path)

    codeql_command = args.codeql.split(" ")
    with tempfile.NamedTemporaryFile() as json_file:
        run_codeql_query(codeql_command, database_path, json_file)
        generate_output(json_file, output_path)


def check_output_path(output_path, overwrite):
    if output_path == None:
        return  # STDOUT
    p = Path(output_path).absolute()
    if p.is_file() and not overwrite:
        die("file already exists at: " + str(p))
    elif p.is_dir():
        die("specified output path is a directory: " + str(p))


def check_database_exists(database_path):
    if not database_path.exists():
        die("database not found at: " + str(database_path))
    elif not database_path.is_dir():
        die("database not found at: " + str(database_path) + " - not a directory")
    elif not database_path.joinpath("db-ruby").exists():
        die("directory: " + str(database_path) + " doesn't look like a Ruby database")


def run_codeql_query(codeql_command, database_path, json_file):
    query_path = (
        Path(__file__)
        .parent.parent.joinpath("ql/src/queries/modeling/GenerateModel.ql")
        .absolute()
    )
    with tempfile.NamedTemporaryFile() as bqrs_file:
        subprocess.run(
            codeql_command
            + ["query", "run", "-d", database_path, "-o", bqrs_file.name, query_path]
        )
        subprocess.run(
            codeql_command
            + [
                "bqrs",
                "decode",
                "--format",
                "json",
                "--output",
                json_file.name,
                bqrs_file.name,
            ]
        )


def generate_output(json_file, output_path):
    output_string = format_query_output(json_file)
    if not output_path == None:
        Path(output_path).write_text(output_string)
    else:
        print(output_string)

def model_kinds():
    return ["typeModel", "sourceModel", "sinkModel", "summaryModel", "typeVariableModel"]

# TODO: replace all of this formatting code
def format_query_output(json_file):
    result = "extensions:"
    parsed_json = json.load(json_file)
    for extensible_type in model_kinds():
        if not extensible_type in parsed_json:
            continue
        tuples = parsed_json[extensible_type]["tuples"]
        result += "\n".join([format_entry(extensible_type, tuple) for tuple in tuples])
    return result + "\n"


def format_tuple(tuple):
    return "\n".join([f'          "{data}",' for data in tuple])


def format_entry(extensible_type, tuple):
    return """
  - addsTo:
      pack: codeql/ruby-all
      extensible: {extensible_type}
    data:
      - [
{tuple_data}
        ]""".format(
        extensible_type=extensible_type, tuple_data=format_tuple(tuple)
    )


main()
