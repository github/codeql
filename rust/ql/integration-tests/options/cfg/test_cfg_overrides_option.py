import pytest
import platform
import os


def test_default(codeql, rust):
    codeql.database.create()


@pytest.mark.ql_test(expected=".override.expected")
def test_cfg_overrides(codeql, rust):
    overrides = ",".join((
        "cfg_flag",
        "cfg_key=value",
        "-target_pointer_width=64",
        "target_pointer_width=32",
        "-test",
    ))
    codeql.database.create(extractor_option=f"cargo_cfg_overrides={overrides}")

@pytest.mark.ql_test(expected=".override.expected")
def test_duplicate_cfg_overrides(codeql, rust):
    overrides = ",".join((
        "cfg_flag",
        "cfg_key=value",
        "-cfg_flag",
        "target_pointer_width=32",
        "-target_pointer_width=64",
        "cfg_flag",
        "cfg_flag",
        "target_pointer_width=32",
        "-test",
        "-test",
        "test",
        "-test",
    ))
    codeql.database.create(extractor_option=f"cargo_cfg_overrides={overrides}")
