import pytest
import platform


@pytest.mark.ql_test(expected=f".{platform.system()}.expected")
def test_default(codeql, rust):
    codeql.database.create()

@pytest.mark.ql_test(expected=".Windows.expected")
def test_target_windows(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=x86_64-pc-windows-msvc")

@pytest.mark.ql_test(expected=".Darwin.expected")
def test_target_macos(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=aarch64-apple-darwin")

@pytest.mark.ql_test(expected=".Linux.expected")
def test_target_linux(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=x86_64-unknown-linux-gnu")
