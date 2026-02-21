#!/bin/env python3

"""
usage: test_upgrade.py [-h] [--learn] [--accept] [--verbose] [DIR ...]

Run upgrade/downgrade scripts unit tests

positional arguments:
  DIR            directories to look for upgrade/downgrade scripts in

options:
  -h, --help     show this help message and exit
  --learn        write down test results in expected files
  --accept       accept actual results
  --verbose, -v  print codeql output

Tests must be contained within a `test` directory directly within the upgrade/downgrade script directory, and
take the form of a `<name>.trap` file containing the initial data of the DB and `<name>.expected` containing a
form of difference between the database before and after the upgrade/downgrade is applied, similar to the format
of `codeql database diff`. It is required and checked that the initial data is consistent with `old.dbscheme`, and
it is then checked that final data is consistent with the new dbscheme.

Behavior is similar to `codeql test run`: if the test fails, a `<name>.actual` file is created, and `--accept`
can be later used to accept the test result. `--learn` can be used to directly write the result in the
`<name>.expected` file.
"""

import argparse
import pathlib
import subprocess
import sys
import typing
import shutil
import difflib

class Error(Exception):
    def __str__(self):
        return f">>> {super().__str__()}"

verbose = False

def codeql(*args, quiet=False, **kwargs) -> str:
    cmd = ["codeql"]
    cmd.extend(args)
    for k, v in kwargs.items():
        k = k.replace('_', '-')
        cmd.append(f"--{k}" if v is True else f"--{k}={v}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if not quiet and verbose:
        sys.stderr.write(result.stderr)
    if result.returncode:
        cmd = " ".join(str(arg) for arg in cmd)
        out = (result.stderr + result.stdout).strip()
        raise Error(f"FAILURE running {cmd}:\n{out}")
    return result.stdout


def options() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run upgrade/downgrade scripts unit tests")
    parser.add_argument("--learn", action="store_true", help="write down test results in expected files")
    parser.add_argument("--accept", action="store_true", help="accept actual results")
    parser.add_argument("--verbose", "-v", action="store_true", help="print codeql output")
    parser.add_argument("script_dirs", nargs="*", type=pathlib.Path, default=[pathlib.Path()],
                        metavar="DIR", help="directories to look for upgrade/downgrade scripts in")
    return parser.parse_args()


def collect_tests(dirs: typing.Iterable[pathlib.Path]) -> typing.Iterable[typing.Tuple[pathlib.Path, str]]:
    for dir in dirs:
        for script in dir.rglob("upgrade.properties"):
            if not (script.parent / "test").is_dir():
                continue
            script_kind = script.parents[1].name
            if script_kind == "upgrades":
                pack = script.parents[4]
            elif script_kind == "downgrades":
                pack = script.parents[2]
            else:
                raise Error(f"{script} is not within a standard upgrades or downgrades directory")
            if pack.name == "extractor-pack":
                # do not run tests within extractor packs!
                continue
            for test in script.parent.glob("test/*.trap"):
                yield test, pack.name


def extract_tuples(db: pathlib.Path, lang: str, dbschemename: str):
    """
    Slightly hacky workaround to get all tuples of a DB in the format of `database diff --no-resolve-tuples`, by
    running the diff against an empty DB with the same dbscheme and parsing the result.
    """
    empty = db.with_suffix(".empty")
    shutil.rmtree(empty, ignore_errors=True)
    codeql("database", "init", empty, source_root=".", language=lang)
    (empty / "src").mkdir()
    codeql("database", "finalize", empty, dbscheme=db / f"db-{lang}" / dbschemename)

    diff_lines = codeql("database", "diff", empty, db, no_resolve_tuples=True, mode="tables", quiet=True).splitlines(keepends=True)
    shutil.rmtree(empty)

    tables = {}
    for line in diff_lines:
        if line.startswith("+++"):
            table = pathlib.Path(line[4:].strip()).name
        elif line.startswith("+"):
            tables.setdefault(table, []).append(line[1:])
    return tables

def run_test(test: pathlib.Path, lang: str, learn: bool):
    print(">>>", test, end=" " if not verbose else "\n")
    sys.stdout.flush()

    upgrade_scrip_dir = test.parents[1]
    dbschemename = next(f for f in upgrade_scrip_dir.glob("*.dbscheme") if f.stem != "old").name
    working_dir = test.with_suffix(".testproj")
    working_dir.mkdir(exist_ok=True)
    shutil.copy(upgrade_scrip_dir / "old.dbscheme", working_dir / dbschemename)

    # create old version of database
    olddb = working_dir / "old-db"
    olddataset = olddb / f"db-{lang}"
    shutil.rmtree(olddb, ignore_errors=True)
    codeql("database", "init", olddb, source_root=".", language=lang)
    (olddb / "src").mkdir()  # make sure codeql does not complain about non extracted sources
    (olddb / "trap" / lang).mkdir(parents=True)
    shutil.copy(test, olddb / "trap" / lang)
    codeql("database", "finalize", olddb, dbscheme=working_dir / dbschemename)
    with open(olddataset / f"{dbschemename}.stats", "w") as stats:
        print("<dbstats><typesizes /><stats /></dbstats>", file=stats)
    codeql("dataset", "check", olddataset)

    # perform upgrade
    newdb = working_dir / "new-db"
    newdataset = newdb / f"db-{lang}"
    shutil.rmtree(newdb, ignore_errors=True)
    shutil.copytree(olddb, newdb)
    codeql("execute", "upgrades", newdataset, upgrade_scrip_dir)
    # sometimes the above generates a stats file in the script dir, let's clean it up
    for stat in upgrade_scrip_dir.glob("*.stats"):
        stat.unlink()
    codeql("dataset", "check", newdataset)

    # compare tables
    # as `codeql database diff` does not allow comparing DBs with different dbschemes, we just
    # do the diff ourselves
    tuples = extract_tuples(olddb, lang, dbschemename)
    new_tuples = extract_tuples(newdb, lang, dbschemename)

    for table in tuples:
        tuples[table] = (tuples[table], new_tuples.pop(table, None))

    for table, value in new_tuples.items():
        tuples[table] = (None, value)

    actual_lines = []
    for table, (old, new) in sorted(tuples.items()):
        size = len(actual_lines)
        actual_lines.extend(difflib.unified_diff(
            old or [],
            new or [],
            fromfile=f"old/{table}" if old is not None else "<created>",
            tofile=f"new/{table}" if new is not None else "<deleted>",
            n=0))
        if len(actual_lines) > size:
            actual_lines.append("\n")

    # for this unified diff line numbers @@-lines are just noise
    actual_lines[:] = [l for l in actual_lines if not l.startswith("@@")]

    # manage .actual/.expected interactions
    actual = test.with_suffix(".actual")
    actual.unlink(missing_ok=True)
    expected = test.with_suffix(".expected")
    if not learn:
        with open(expected) as expectedin:
            expected_lines = expectedin.readlines()

        diff = list(difflib.unified_diff(expected_lines, actual_lines, fromfile=str(expected), tofile=str(actual)))
        if diff:
            with open(actual, "w") as actualout:
                actualout.writelines(actual_lines)
            print("FAILURE")
            raise Error(f"{test} FAILURE:\n{''.join(diff)}")
        else:
            print("SUCCESS")
    else:
        with open(expected, "w") as expectedout:
            expectedout.writelines(actual_lines)
        print("SUCCESS (results learned)")


def accept_test_results(test: pathlib.Path):
    actual = test.with_suffix(".actual")
    if actual.is_file():
        actual.rename(test.with_suffix(".expected"))
        print(f"=== {test} results accepted ===")

def main(opts: argparse.Namespace):
    global verbose
    verbose = opts.verbose
    errors = []
    for dir in opts.script_dirs:
        if (dir / "upgrade.properties").is_file() and not (dir / "test").is_dir():
            errors.append(Error(
                f"testing of {dir.relative_to(dir.parents[1])} explicitly requested, but no test directory found"))
    tests = collect_tests(opts.script_dirs)
    if opts.accept:
        for test, _ in tests:
            accept_test_results(test)
    else:
        for test, lang in tests:
            try:
                run_test(test, lang, opts.learn)
            except Error as e:
                errors.append(e)
    if errors:
        for e in errors:
            print(e, file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main(options())
