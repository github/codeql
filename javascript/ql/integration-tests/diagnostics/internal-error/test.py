import os


def test(codeql, javascript, cwd):
    os.environ["NODE_OPTIONS"] = f'--require "{cwd / "fail-native.cjs"}"'
    codeql.database.create(source_root="src", _assert_failure=True)
