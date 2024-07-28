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

[assembly: AssemblyTitle("{opts.name}")]
[assembly: AssemblyProduct("CodeQL")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
[assembly: AssemblyCompany("GitHub")]
[assembly: AssemblyCopyright("Copyright © 2024 GitHub")]

[assembly: System.Runtime.Versioning.TargetFramework(".NETCoreApp,Version=v8.0", FrameworkDisplayName = ".NET 8.0")]

"""
output_file.write_text(output_file_contents)
