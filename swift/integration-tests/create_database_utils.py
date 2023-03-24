"""
recreation of internal `create_database_utils.py` to run the tests locally, with minimal
and swift-specialized functionality
"""
import subprocess
import pathlib
import sys


def run_codeql_database_create(cmds, lang, keep_trap=True):
    assert lang == 'swift'
    codeql_root = pathlib.Path(__file__).parents[2]
    cmd = [
        "codeql", "database", "create",
        "-s", ".", "-l", "swift", "--internal-use-lua-tracing", f"--search-path={codeql_root}", "--no-cleanup",
    ]
    if keep_trap:
        cmd.append("--keep-trap")
    for c in cmds:
        cmd += ["-c", c]
    cmd.append("db")
    res = subprocess.run(cmd)
    if res.returncode:
        print("FAILED", file=sys.stderr)
        print(" ", *cmd, file=sys.stderr)
        sys.exit(res.returncode)
