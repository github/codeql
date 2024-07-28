import sys
import pathlib
import subprocess
import os
import itertools
import inspect


def _absolute_path(*path: str) -> str:
    return str(pathlib.Path(*path).absolute())


qltest = pathlib.Path(sys.argv[1]).absolute()
script_dir = pathlib.Path(__file__).parent.absolute()
execution_log = pathlib.Path("execution.log").absolute()

swift_root = "dummy_root"
platform = "dummy_plat"

def _get_test_dir():
    frame = inspect.stack()[2]
    module = inspect.getmodule(frame[0])
    return pathlib.Path(module.__file__).parent

def set_dummy_extractor(*cmds):
    extractor = _get_test_dir() / swift_root / "tools" / platform / "extractor"
    extractor.parent.mkdir(parents=True, exist_ok=True)
    execution_log.unlink(missing_ok=True)
    with open(extractor, "w") as extractor_out:
        print("#!/bin/bash", file=extractor_out)
        print(f'echo "$@" >> {execution_log}', file=extractor_out)
        for cmd in cmds:
            print(cmd, file=extractor_out)
    os.chmod(extractor, 0o777)


def run_qltest(expected_returncode=0):
    current_dir = _absolute_path()
    test_dir = _get_test_dir()

    env = {
        "CODEQL_EXTRACTOR_SWIFT_LOG_DIR": ".",
        "CODEQL_EXTRACTOR_SWIFT_ROOT": swift_root,
        "CODEQL_PLATFORM": platform,
        "CODEQL_EXTRACTOR_SWIFT_TRAP_DIR": "traps",
    }

    qltest_returncode = subprocess.run([str(qltest)], env=env, cwd=str(test_dir),
                                       stdout=subprocess.DEVNULL).returncode

    if qltest_returncode != expected_returncode:
        print(f"qltest returned with exit status {qltest_returncode}, expecting {expected_returncode}")
        with open(test_dir / "qltest.log", "r") as log:
            sys.stdout.write(log.read())
        sys.exit(1)


def assert_extractor_executed_with(*flags):
    with open(execution_log) as execution:
        for actual, expected in itertools.zip_longest(execution, flags):
            if actual:
                actual = actual.strip()
                expected_prefix = f"-resource-dir {swift_root}/resource-dir/{platform} -c -primary-file "
                assert actual.startswith(expected_prefix), f"correct options not found in\n{actual}"
                actual = actual[len(expected_prefix):]
            assert actual, f"\nnot encountered: {expected}"
            assert expected, f"\nunexpected: {actual}"
            assert actual == expected, f"\nexpecting: {expected}\ngot:       {actual}"
