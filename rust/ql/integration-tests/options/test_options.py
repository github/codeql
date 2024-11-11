import pytest
import platform
import os


@pytest.mark.ql_test("arch_functions.ql", expected=f".{platform.system()}.expected")
def test_default(codeql, rust):
    codeql.database.create()

@pytest.mark.ql_test("arch_functions.ql", expected=".Windows.expected")
def test_target_windows(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=x86_64-pc-windows-msvc")

@pytest.mark.ql_test("arch_functions.ql", expected=".Darwin.expected")
def test_target_macos(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=aarch64-apple-darwin")

@pytest.mark.ql_test("arch_functions.ql", expected=".Linux.expected")
def test_target_linux(codeql, rust):
    codeql.database.create(extractor_option="cargo_target=x86_64-unknown-linux-gnu")

@pytest.mark.ql_test("cfg_functions.ql", expected=".override.expected")
@pytest.mark.ql_test("arch_functions.ql", expected=f".{platform.system()}.expected")
def test_cfg_override(codeql, rust):
    overrides = ",".join((
        "cfg_flag",
        "cfg_key=value",
        "-target_pointer_width=64",
        "target_pointer_width=32",
        "test",
    ))
    codeql.database.create(extractor_option=f"cargo_cfg_overrides={overrides}")

@pytest.mark.ql_test("arch_functions.ql", expected=f".{platform.system()}.expected")
@pytest.mark.parametrize("features",
                         [
                             pytest.param(p,
                                          marks=pytest.mark.ql_test("feature_functions.ql", expected=f".{e}.expected"),
                                          id=id)
                             for p, e, id in (
                                 ("foo", "foo", "foo"),
                                 ("bar", "bar", "bar"),
                                 # as long as the integration test runner does not sanitize filenames we must
                                 # replace `*` and `,` in the parameter id
                                 ("*", "all", "all"),
                                 ("foo,bar", "all", "foo+bar"))
                         ])
def test_features(codeql, rust, features):
    codeql.database.create(extractor_option=f"cargo_features={features}")
