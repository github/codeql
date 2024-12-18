"""
Generates an `GitAssemblyInfo.cs` file that specifies the `AssemblyInformationalVersion` attribute.

This attribute is set to the git version string of the repository."""

import pathlib
import argparse


def options():
    p = argparse.ArgumentParser(
        description="Generate the git assembly info file that contains the git SHA and branch name"
    )
    p.add_argument("output", help="The path to the output file")
    p.add_argument("gitinfo_files", nargs="+", help="The path to the gitinfo files")
    return p.parse_args()


opts = options()

gitfiles = dict()
for file in map(pathlib.Path, opts.gitinfo_files):
    gitfiles[file.name] = file

version_string = gitfiles["git-ql-describe-all.log"].read_text().strip()
if version_string == "no-git":
    version_string = gitfiles["git-describe-all.log"].read_text().strip()
version_string += f" ({gitfiles['git-ql-rev-parse.log'].read_text().strip()})"

output_file = pathlib.Path(opts.output)
output_file_contents = f"""
using System.Reflection;

[assembly: AssemblyInformationalVersion("{version_string}")]
"""
output_file.write_text(output_file_contents)
