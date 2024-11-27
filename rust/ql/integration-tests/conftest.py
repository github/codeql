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
    check_diagnostics.redact += [
        "attributes.durations.*.ms",
        "attributes.durations.*.pretty",
    ]
    return check_diagnostics
