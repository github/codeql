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
        (r'"ms"\s*:\s*[0-9]+', '"ms": "REDACTED"'),
        (r'"pretty"\s*:\s*"[0-9]+:[0-9]{2}:[0-9]{2}.[0-9]{3}"', '"pretty": "REDACTED"'),
        (r'Cargo.toml|rust-project.json', "<manifest>"),
    ]
    return check_diagnostics
