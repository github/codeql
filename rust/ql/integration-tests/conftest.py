import pytest
import shutil

class _Manifests:
    def __init__(self, cwd):
        self.dir = cwd / "manifests"

    def select(self, name: str):
        (self.dir / name).rename(name)
        shutil.rmtree(self.dir)


@pytest.fixture
def manifests(cwd):
    return _Manifests(cwd)

@pytest.fixture
def rust_check_diagnostics(check_diagnostics):
    check_diagnostics.replacements += [
        (r'"ms"\s*:\s*[0-9]+', '"ms": "__REDACTED__"'),
        (r'"pretty"\s*:\s*"[^"]*"', '"pretty": "__REDACTED__"'),
    ]
    check_diagnostics.skip += [
        "attributes.steps",  # the order of the steps is not stable
    ]
    return check_diagnostics
