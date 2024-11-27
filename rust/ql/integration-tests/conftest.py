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
        ("Cargo.toml|rust-project.json", "<manifest-file>"),
    ]
    check_diagnostics.redact += [
        "attributes.summary.durations.*.ms",
        "attributes.summary.durations.*.pretty",
        "attributes.steps.ms",
    ]
    check_diagnostics.sort = True  # the order of the steps is not stable
    return check_diagnostics
