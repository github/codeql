"""
Generates an `AssemblyInfo.cs` file that specifies a bunch of useful attributes
that we want to set on our assemblies."""

import pathlib
import argparse


def options():
    p = argparse.ArgumentParser(
        description="Generate an assembly info file."
    )
    p.add_argument("output", help="The path to the output file")
    p.add_argument("name", help="The name of the assembly")
    return p.parse_args()


opts = options()

output_file = pathlib.Path(opts.output)
output_file_contents = f"""
using System.Reflection;

[assembly: XX("{opts.name}")]
[assembly: YY("ZZ")]
"""
output_file.write_text(output_file_contents)
