# This script is for debugging purposes for the flow test case generator.
# Some dummy tests are created and executed.
# It requites that `--search-path /path/to/semmle-code/ql` is added to `~/.config/codeql/config`

# Usage: python3 test.py

import subprocess

# Generate test cases
print('Generating test cases...')
if subprocess.check_call(["../../../src/utils/flowtestcasegenerator/GenerateFlowTestCase.py", "specs.csv", "pom.xml", "--force", "."]):
    print("Failed to generate test cases.")
    exit(1)

# Run test cases.
print('Running test cases...')
subprocess.call(["codeql", "test", "run", "test.ql"])