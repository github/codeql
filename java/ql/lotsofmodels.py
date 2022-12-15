# Tool to run queries from different packs each containing lots of data extensions.
# Usage:
# python3 lotsofmodels.py <path to codeql repo>

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

print('Executing script to run dummy queries that loads lots of extensions files.')
print('Making a dummy database.')

# Configuration
workDir = tempfile.mkdtemp()
projectDir = os.path.join(workDir, "project")
emptyFile = os.path.join(workDir, "Empty.java") 
dbDir = os.path.join(workDir, "db")

# Make dummy project
with open(emptyFile, "w") as f:
    f.write("class Empty {}")
helpers.run_cmd(['codeql', 'database', 'create', f'--language=java', '-c', f'javac {emptyFile}', dbDir], "Failed to create dummy database.")

# Run dummy queries
helpers.run_cmd (['codeql', 'database', 'analyze', '--format=csv', '--output=myoutput', '-vvvv', '--additional-packs', sys.argv[1], '--', dbDir, 'p1/p1.ql', 'p2/p2.ql', 'p3/p3.ql', 'p4/p4.ql', 'p5/p5.ql'])