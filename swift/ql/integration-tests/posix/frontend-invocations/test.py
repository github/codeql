from hashlib import sha256
from pathlib import Path
import runs_on
import pytest


@runs_on.posix
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift, expected_files):
    codeql.database.create(command="./build.sh")
    with open("hashes.expected", "w") as expected:
        for f in sorted(Path().glob("*.swiftmodule")):
            with open(f, "rb") as module:
                print(f.name, sha256(module.read()).hexdigest(), file=expected)

    with open("hashes.actual", "w") as actual:
        hashes = [
            (s.name, s.resolve().name)
            for s in Path("test-db/working/swift-extraction-artifacts/store").iterdir()
        ]
        hashes.sort()
        for module, hash in hashes:
            print(module, hash, file=actual)
    expected_files.add("hashes.expected")
