from create_database_utils import *

run_codeql_database_create([
    "swiftc -enable-bare-slash-regex regex.swift -o /dev/null",
], lang="swift")
