# Tool to generate data extensions files based on the existing models.
# Usage:
# python3 ConvertExtensions.py
# (1) A folder named `java/ql/lib/ext` will be created, if it doesn't already exist.
# (2) The converted models will be written to `java/ql/lib/ext`. One file for each namespace.

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
language = "java"
workDir = tempfile.mkdtemp()
projectDir = os.path.join(workDir, "project")
emptyFile = os.path.join(workDir, "Empty.java") 
dbDir = os.path.join(workDir, "db")

# Make dummy project
with open(emptyFile, "w") as f:
    f.write("class Empty {}")
helpers.run_cmd(['codeql', 'database', 'create', f'--language={language}', '-c', f'javac {emptyFile}', dbDir], "Failed to create dummy database.")

print('Converting data extensions for Java.')
extensions.Converter(language, dbDir).run()

print('Cleanup.')
# Cleanup - delete database.
helpers.remove_dir(dbDir)
print('Done.')