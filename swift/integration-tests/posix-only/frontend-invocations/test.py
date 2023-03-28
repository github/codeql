from create_database_utils import *
from subprocess import check_call
from hashlib import sha256
from pathlib import Path

run_codeql_database_create([
    './build.sh',
], lang='swift')

with open('hashes.expected', 'w') as expected:
    for f in sorted(Path().glob("*.swiftmodule")):
        with open(f, 'rb') as module:
            print(f.name, sha256(module.read()).hexdigest(), file=expected)

with open('hashes.actual', 'w') as actual:
    hashes = [(s.name, s.resolve().name) for s in Path("db/working/swift-extraction-artifacts/store").iterdir()]
    hashes.sort()
    for module, hash in hashes:
        print(module, hash, file=actual)

check_call(['diff', '-u', 'hashes.expected', 'hashes.actual'])
