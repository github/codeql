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

if len(sys.argv) != 4:
  print("Usage: GenerateFlowTestCase.py specsToTest.ssv projectPom.xml outdir", file=sys.stderr)
  print("specsToTest.ssv should contain SSV rows describing method taint-propagation specifications to test", file=sys.stderr)
  print("projectPom.xml should import dependencies sufficient to resolve the types used in specsToTest.ssv", file=sys.stderr)
  sys.exit(1)

try:
  os.makedirs(sys.argv[3])
except Exception as e:
  if e.errno != errno.EEXIST:
    print("Failed to create output directory %s: %s" % (sys.argv[3], e))
    sys.exit(1)

resultJava = os.path.join(sys.argv[3], "Test.java")
resultQl = os.path.join(sys.argv[3], "test.ql")

if os.path.exists(resultJava) or os.path.exists(resultQl):
  print("Won't overwrite existing files '%s' or '%s'" % (resultJava, resultQl), file = sys.stderr)
  sys.exit(1)

workDir = tempfile.mkdtemp()

# Make a database that touches all types whose methods we want to test:
print("Creating Maven project")
projectDir = os.path.join(workDir, "mavenProject")
os.makedirs(projectDir)

try:
  shutil.copyfile(sys.argv[2], os.path.join(projectDir, "pom.xml"))
except Exception as e:
  print("Failed to read project POM %s: %s" % (sys.argv[2], e), file = sys.stderr)
  sys.exit(1)

commentRegex = re.compile("^\s*(//|#)")
def isComment(s):
  return commentRegex.match(s) is not None

try:
  with open(sys.argv[1], "r") as f:
    specs = [l for l in f if not isComment(l)]
except Exception as e:
  print("Failed to open %s: %s\n" % (sys.argv[1], e))
  sys.exit(1)

projectTestPkgDir = os.path.join(projectDir, "src", "main", "java", "test")
projectTestFile = os.path.join(projectTestPkgDir, "Test.java")

os.makedirs(projectTestPkgDir)

def qualifiedOuterNameFromSsvRow(row):
  cells = row.split(";")
  if len(cells) < 2:
    return None
  return cells[0] + "." + cells[1].replace("$", ".")

with open(projectTestFile, "w") as testJava:
  testJava.write("package test;\n\npublic class Test {\n\n")

  for i, spec in enumerate(specs):
    outerName = qualifiedOuterNameFromSsvRow(spec)
    if outerName is None:
      print("A taint specification has the wrong format: should be 'package;classname;methodname....'", file = sys.stderr)
      print("Mis-formatted row: " + spec, file = sys.stderr)
      sys.exit(1)
    testJava.write("\t%s obj%d = null;\n" % (outerName, i))

  testJava.write("}")

print("Creating project database")
cmd = ["codeql", "database", "create", "--language=java", "db"]
ret = subprocess.call(cmd, cwd = projectDir)
if ret != 0:
  print("Failed to create project database. Check that '%s' is a valid POM that pulls in all necessary dependencies, and '%s' specifies valid classes and methods." % (sys.argv[2], sys.argv[1]), file = sys.stderr)
  print("Failed command was: %s (cwd: %s)" % (shlex.join(cmd), projectDir), file = sys.stderr)
  sys.exit(1)

print("Creating test-generation query")
queryDir = os.path.join(workDir, "query")
os.makedirs(queryDir)
qlFile = os.path.join(queryDir, "gen.ql")
with open(os.path.join(queryDir, "qlpack.yml"), "w") as f:
  f.write("name: test-generation-query\nversion: 0.0.0\nlibraryPathDependencies: codeql-java")
with open(qlFile, "w") as f:
  f.write("import java\nimport utils.GenerateFlowTestCase\n\nclass GenRow extends CsvRow {\n\n\tGenRow() {\n\t\tthis = [\n")
  f.write(",\n".join('\t\t\t"%s"' % spec.strip() for spec in specs))
  f.write("\n\t\t]\n\t}\n}\n")
  f.write("""
query string getAFailedRow() {
  result = any(GenRow row | not exists(RowTestSnippet r | exists(r.getATestSnippetForRow(row))) | row)
}
  """)

print("Generating tests")
generatedBqrs = os.path.join(queryDir, "out.bqrs")
cmd = ['codeql', 'query', 'run', qlFile, '--database', os.path.join(projectDir, "db"), '--output', generatedBqrs]
ret = subprocess.call(cmd)
if ret != 0:
  print("Failed to generate tests. Failed command was: " + shlex.join(cmd))
  sys.exit(1)

generatedJson = os.path.join(queryDir, "out.json")
cmd = ['codeql', 'bqrs', 'decode', generatedBqrs, '--format=json', '--output', generatedJson]
ret = subprocess.call(cmd)
if ret != 0:
  print("Failed to decode BQRS. Failed command was: " + shlex.join(cmd))
  sys.exit(1)

def getTuples(queryName, jsonResult, fname):
  if queryName not in jsonResult or "tuples" not in jsonResult[queryName]:
    print("Failed to read generated tests: expected key '%s' with a 'tuples' subkey in file '%s'" % (queryName, fname), file = sys.stderr)
    sys.exit(1)
  return jsonResult[queryName]["tuples"]

with open(generatedJson, "r") as f:
  generateOutput = json.load(f)
  testCaseRows = getTuples("getTestCase", generateOutput, generatedJson)
  supportModelRows = getTuples("getASupportMethodModel", generateOutput, generatedJson)
  failedRows = getTuples("getAFailedRow", generateOutput, generatedJson)
  if len(testCaseRows) != 1 or len(testCaseRows[0]) != 1:
    print("Expected exactly one getTestCase result with one column (got: %s)" % json.dumps(testCaseRows), file = sys.stderr)
  if any(len(row) != 1 for row in supportModelRows):
    print("Expected exactly one column in getASupportMethodModel relation (got: %s)" % json.dumps(supportModelRows), file = sys.stderr)
  if any(len(row) != 1 for row in failedRows):
    print("Expected exactly one column in getAFailedRow relation (got: %s)" % json.dumps(failedRows), file = sys.stderr)
  if len(failedRows) != 0:
    print("The following rows failed to generate any test case. Check package, class and method name spelling, and argument and result specifications:\n%s" % "\n".join(r[0] for r in failedRows), file = sys.stderr)

with open(resultJava, "w") as f:
  f.write(generateOutput["getTestCase"]["tuples"][0][0])

scriptPath = os.path.dirname(sys.argv[0])

with open(resultQl, "w") as f:
  with open(os.path.join(scriptPath, "testHeader.qlfrag"), "r") as header:
    shutil.copyfileobj(header, f)
  f.write(", ".join('"%s"' % modelSpecRow[0].strip() for modelSpecRow in supportModelRows))
  with open(os.path.join(scriptPath, "testFooter.qlfrag"), "r") as header:
    shutil.copyfileobj(header, f)

# Make an empty .expected file, since this is an inline-exectations test
with open(os.path.join(sys.argv[3], "test.expected")):
  pass

cmd = ['codeql', 'query', 'format', '-qq', '-i', resultQl]
subprocess.call(cmd)

shutil.rmtree(workDir)