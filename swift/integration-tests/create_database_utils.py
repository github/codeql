"""
Simplified version of internal `create_database_utils.py` used to run the tests locally, with
minimal and swift-specialized functionality
TODO unify integration testing code across the public and private repositories
"""
import subprocess
import pathlib
import sys
import shutil


def runSuccessfully(cmd):
    res = subprocess.run(cmd)
    if res.returncode:
        print("FAILED", file=sys.stderr)
        print(" ", *cmd, f"(exit code {res.returncode})", file=sys.stderr)
        sys.exit(res.returncode)

def runUnsuccessfully(cmd):
    res = subprocess.run(cmd)
    if res.returncode == 0:
        print("FAILED", file=sys.stderr)
        print(" ", *cmd, f"(exit code 0, expected to fail)", file=sys.stderr)
        sys.exit(1)


def run_codeql_database_create(cmds, lang, keep_trap=True, db=None, runFunction=runSuccessfully):
    """ db parameter is here solely for compatibility with the internal test runner """
    assert lang == 'swift'
    codeql_root = pathlib.Path(__file__).parents[2]
    shutil.rmtree("db", ignore_errors=True)
    cmd = [
        "codeql", "database", "create",
        "-s", ".", "-l", "swift", "--internal-use-lua-tracing", f"--search-path={codeql_root}", "--no-cleanup",
    ]
    if keep_trap:
        cmd.append("--keep-trap")
    for c in cmds:
        cmd += ["-c", c]
    cmd.append("db")
    runFunction(cmd)
