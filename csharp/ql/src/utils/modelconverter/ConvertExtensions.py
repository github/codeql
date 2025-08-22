# Tool to generate data extensions files based on the existing models.
# Usage:
# python3 ConvertExtensions.py
# (1) A folder named `csharp/ql/lib/ext` will be created, if it doesn't already exist.
# (2) The converted models will be written to `csharp/ql/lib/ext`. One file for each namespace.

import os
import subprocess
import sys
import tempfile

# Add Models as Data script directory to sys.path.
gitroot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
madpath = os.path.join(gitroot, "misc/scripts/models-as-data/")
sys.path.append(madpath)

import helpers
import convert_extensions as extensions

print('Running script to generate data extensions files from the existing MaD models.')
print('Making a dummy database.')

# Configuration
language = "csharp"
workDir = tempfile.mkdtemp()
projectDir = os.path.join(workDir, "project")
dbDir = os.path.join(workDir, "db")

# Make dummy project
helpers.run_cmd(['dotnet', 'new', 'webapp', '-o', projectDir], "Failed to create dummy project.")
# Add nuget packages for all packages where we have models
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'Newtonsoft.Json'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'Microsoft.EntityFrameworkCore'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'Microsoft.EntityFrameworkCore.Relational'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'Dapper'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'ServiceStack'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'ServiceStack.OrmLite'])
helpers.run_cmd(['dotnet', 'add', projectDir, 'package', 'System.Collections.Immutable'])
helpers.run_cmd(['codeql', 'database', 'create', f'--language={language}', '-c', f'dotnet build {projectDir}', dbDir], "Failed to create dummy database.")

print('Converting data extensions for C#.')
extensions.Converter(language, dbDir).run()

print('Cleanup.')
# Cleanup - delete database.
helpers.remove_dir(dbDir)
print('Done.')