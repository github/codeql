import pytest


@pytest.mark.parametrize("rust_edition", [2024])
@pytest.mark.parametrize("extra_args", [None, "--offline", "--ignore-rust-version"])
def test_rust_version(codeql, rust, cargo, extra_args):
    env = {}
    if extra_args is not None:
        env["CODEQL_EXTRACTOR_RUST_OPTION_CARGO_EXTRA_ARGS"] = extra_args
    codeql.database.create(_env=env)
