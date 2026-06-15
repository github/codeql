#!/usr/bin/env python3

import errno
import json
import os
import os.path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile

if any(s == "--help" for s in sys.argv):
    print("""Usage:
GenerateFlowTestCase.py specsToTest projectPom.xml outdir [--force]

This generates test cases exercising function model specifications found in specsToTest
producing files Test.java, test.ql, test.ext.yml and test.expected in outdir.

specsToTest should either be a .csv file, a .yml file, or a directory of .yml files, containing the
model specifications to test.

projectPom.xml should be a Maven pom sufficient to resolve the classes named in specsToTest.csv.
Typically this means supplying a skeleton POM <dependencies> section that retrieves whatever jars
contain the needed classes.

If --force is present, existing files may be overwritten.

Requirements:
 - `mvn` and `codeql` should both appear on your path.
 - `--additional-packs /path/to/semmle-code/ql` should be added to your `.config/codeql/config` file.

After test generation completes, any lines in specsToTest.csv that didn't produce tests are output.
If this happens, check the spelling of class and method names, and the syntax of input and output specifications.
""")
    sys.exit(0)

force = False
if "--force" in sys.argv:
    sys.argv.remove("--force")
    force = True

if len(sys.argv) != 4:
    print(
        "Usage: GenerateFlowTestCase.py specsToTest projectPom.xml outdir [--force]", file=sys.stderr)
    print("specsToTest should contain CSV rows or YAML models describing method taint-propagation specifications to test", file=sys.stderr)
    print("projectPom.xml should import dependencies sufficient to resolve the types used in specsToTest", file=sys.stderr)
    print("\nRun with --help for more details.", file=sys.stderr)
    sys.exit(1)

try:
    os.makedirs(sys.argv[3])
except OSError as e:
    if e.errno != errno.EEXIST:
        print("Failed to create output directory %s: %s" % (sys.argv[3], e))
        sys.exit(1)

resultJava = os.path.join(sys.argv[3], "Test.java")
resultQl = os.path.join(sys.argv[3], "test.ql")
resultYml = os.path.join(sys.argv[3], "test.ext.yml")

if not force and (os.path.exists(resultJava) or os.path.exists(resultQl) or os.path.exists(resultYml)):
    print("Won't overwrite existing files '%s', '%s' or '%s'." %
          (resultJava, resultQl, resultYml), file=sys.stderr)
    sys.exit(1)

workDir = tempfile.mkdtemp()

# Make a database that touches all types whose methods we want to test:
print("Creating Maven project")
projectDir = os.path.join(workDir, "mavenProject")
os.makedirs(projectDir)

try:
    shutil.copyfile(sys.argv[2], os.path.join(projectDir, "pom.xml"))
except Exception as e:
    print("Failed to read project POM %s: %s" %
          (sys.argv[2], e), file=sys.stderr)
    sys.exit(1)

commentRegex = re.compile(r"^\s*(//|#)")


def isComment(s):
    return commentRegex.match(s) is not None


def readCsv(file):
    try:
        with open(file, "r") as f:
            specs = [l.strip() for l in f if not isComment(l)]
    except Exception as e:
        print("Failed to open %s: %s\n" % (file, e))
        sys.exit(1)

    specs = [row.split(";") for row in specs]
    return specs


def readYml(file):
    try:
        import yaml
        with open(file, "r") as f:
            doc = yaml.load(f.read(), yaml.Loader)
        specs = []
        for ext in doc['extensions']:
            if ext['addsTo']['extensible'] == 'summaryModel':
                for row in ext['data']:
                    if isinstance(row[2], bool):
                        row[2] = str(row[2]).lower()
                    specs.append(row)
        return specs
    except ImportError:
        print("PyYAML not found - try \n    pip install pyyaml")
        sys.exit(1)
    except ValueError as e:
        print("Invalid yaml model in %s: %s\n" % (file, e))
        sys.exit(1)
    except OSError as e:
        print("Failed to open %s: %s\n" % (file, e))
        sys.exit(1)


def readYmlDir(dirname):
    specs = []
    for f in os.listdir(dirname):
        if f.endswith('.yml'):
            specs += readYml(f"{dirname}/{f}")
    return specs


specsFile = sys.argv[1]
if os.path.isdir(specsFile):
    specs = readYmlDir(specsFile)
elif specsFile.endswith(".yml") or specsFile.endswith(".yaml"):
    specs = readYml(specsFile)
elif specsFile.endswith(".csv"):
    specs = readCsv(specsFile)
else:
    print(f"Invalid specs {specsFile}. Must be a csv file, a yml file, or a directory of yml files.")
    sys.exit(1)


projectTestPkgDir = os.path.join(projectDir, "src", "main", "java", "test")
projectTestFile = os.path.join(projectTestPkgDir, "Test.java")

os.makedirs(projectTestPkgDir)


def qualifiedOuterNameFromRow(row):
    if len(row) < 2:
        return None
    return row[0] + "." + row[1].replace("$", ".")


with open(projectTestFile, "w") as testJava:
    testJava.write("package test;\n\npublic class Test {\n\n")

    for i, spec in enumerate(specs):
        outerName = qualifiedOuterNameFromRow(spec)
        if outerName is None:
            print("A taint specification has the wrong format: should be 'package;classname;methodname....'", file=sys.stderr)
            print("Mis-formatted row: " + spec, file=sys.stderr)
            sys.exit(1)
        testJava.write("\t%s obj%d = null;\n" % (outerName, i))

    testJava.write("}")

print("Creating project database")
cmd = ["codeql", "database", "create", "--language=java", "db"]
ret = subprocess.call(cmd, cwd=projectDir)
if ret != 0:
    print("Failed to create project database. Check that '%s' is a valid POM that pulls in all necessary dependencies, and '%s' specifies valid classes and methods." % (
        sys.argv[2], sys.argv[1]), file=sys.stderr)
    print("Failed command was: %s (cwd: %s)" %
          (shlex.join(cmd), projectDir), file=sys.stderr)
    sys.exit(1)

print("Creating test-generation query")
queryDir = os.path.join(workDir, "query")
os.makedirs(queryDir)
qlFile = os.path.join(queryDir, "gen.ql")
with open(os.path.join(queryDir, "qlpack.yml"), "w") as f:
    f.write("""name: test-generation-query
version: 0.0.0
dependencies:
  codeql/java-all: '*'
  codeql/java-queries: '*'
""")

with open(qlFile, "w") as f:
    f.write(
        "import java\nimport utils.flowtestcasegenerator.GenerateFlowTestCase\n\nclass GenRow extends TargetSummaryModelCsv {\n\n\toverride predicate row(string r) {\n\t\tr = [\n")
    f.write(",\n".join('\t\t\t"%s"' % ';'.join(spec) for spec in specs))
    f.write("\n\t\t]\n\t}\n}\n")

print("Generating tests")
generatedBqrs = os.path.join(queryDir, "out.bqrs")
cmd = ['codeql', 'query', 'run', qlFile, '--database',
       os.path.join(projectDir, "db"), '--output', generatedBqrs]
ret = subprocess.call(cmd)
if ret != 0:
    print("Failed to generate tests. Failed command was: " + shlex.join(cmd))
    sys.exit(1)

generatedJson = os.path.join(queryDir, "out.json")
cmd = ['codeql', 'bqrs', 'decode', generatedBqrs,
       '--format=json', '--output', generatedJson]
ret = subprocess.call(cmd)
if ret != 0:
    print("Failed to decode BQRS. Failed command was: " + shlex.join(cmd))
    sys.exit(1)


def getTuples(queryName, jsonResult, fname):
    if queryName not in jsonResult or "tuples" not in jsonResult[queryName]:
        print("Failed to read generated tests: expected key '%s' with a 'tuples' subkey in file '%s'" % (
            queryName, fname), file=sys.stderr)
        sys.exit(1)
    return jsonResult[queryName]["tuples"]


with open(generatedJson, "r") as f:
    generateOutput = json.load(f)
    expectedTables = ("getTestCase", "getASupportMethodModel",
                      "missingSummaryModel", "getAParseFailure", "noTestCaseGenerated")

    testCaseRows, supportModelRows, missingSummaryModelRows, parseFailureRows, noTestCaseGeneratedRows = \
        tuple([getTuples(k, generateOutput, generatedJson)
               for k in expectedTables])

    if len(testCaseRows) != 1 or len(testCaseRows[0]) != 1:
        print("Expected exactly one getTestCase result with one column (got: %s)" %
              json.dumps(testCaseRows), file=sys.stderr)
    if any(len(row) != 1 for row in supportModelRows):
        print("Expected exactly one column in getASupportMethodModel relation (got: %s)" %
              json.dumps(supportModelRows), file=sys.stderr)
    if any(len(row) != 2 for row in parseFailureRows):
        print("Expected exactly two columns in parseFailureRows relation (got: %s)" %
              json.dumps(parseFailureRows), file=sys.stderr)
    if any(len(row) != 1 for row in noTestCaseGeneratedRows):
        print("Expected exactly one column in noTestCaseGenerated relation (got: %s)" %
              json.dumps(noTestCaseGeneratedRows), file=sys.stderr)

    if len(missingSummaryModelRows) != 0:
        print("Tests for some CSV rows were requested that were not in scope (a summary doesn't already exist):\n" +
              "\n".join(r[0] for r in missingSummaryModelRows))
        sys.exit(1)
    if len(parseFailureRows) != 0:
        print("The following rows failed to generate any test case. Check package, class and method name spelling, and argument and result specifications:\n%s" %
              "\n".join(r[0] + ": " + r[1] for r in parseFailureRows), file=sys.stderr)
        sys.exit(1)
    if len(noTestCaseGeneratedRows) != 0:
        print("The following CSV rows failed to generate any test case due to a limitation of the query. Other test cases will still be generated:\n" +
              "\n".join(r[0] for r in noTestCaseGeneratedRows))

with open(resultJava, "w") as f:
    f.write(generateOutput["getTestCase"]["tuples"][0][0])

scriptPath = os.path.dirname(sys.argv[0])


def copyfile(fromName, toFileHandle):
    with open(os.path.join(scriptPath, fromName), "r") as fromFileHandle:
        shutil.copyfileobj(fromFileHandle, toFileHandle)


with open(resultQl, "w") as f:
    copyfile("testHeader.qlfrag", f)

if len(supportModelRows) != 0:
    # Make a test extension file
    with open(resultYml, "w") as f:
        models = "\n".join('      - [%s]' %
                           modelSpecRow[0].strip() for modelSpecRow in supportModelRows)
        dataextensions = f"""extensions:
  - addsTo:
      pack: codeql/java-all
      extensible: summaryModel
    data:
{models}
"""
        f.write(dataextensions)

# Make an empty .expected file, since this is an inline-exectations test
with open(os.path.join(sys.argv[3], "test.expected"), "w"):
    pass

cmd = ['codeql', 'query', 'format', '-qq', '-i', resultQl]
subprocess.call(cmd)

shutil.rmtree(workDir)
