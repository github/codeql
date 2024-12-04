import pytest
import json
import commands
import pathlib


@pytest.fixture
def cargo(cwd):
    assert (cwd / "Cargo.toml").exists()
    (cwd / "rust-project.json").unlink(missing_ok=True)

@pytest.fixture(scope="session")
def rust_sysroot_src() -> str:
    rust_sysroot = pathlib.Path(commands.run("rustc --print sysroot", _capture=True))
    ret = rust_sysroot.joinpath("lib", "rustlib", "src", "rust", "library")
    assert ret.exists()
    return str(ret)

@pytest.fixture
def rust_project(cwd, rust_sysroot_src):
    project_file = cwd / "rust-project.json"
    assert project_file.exists()
    project = json.loads(project_file.read_text())
    project["sysroot_src"] = rust_sysroot_src
    project_file.write_text(json.dumps(project, indent=4))
    (cwd / "Cargo.toml").unlink(missing_ok=True)

@pytest.fixture
def rust_check_diagnostics(check_diagnostics):
    check_diagnostics.redact += [
        "attributes.durations.*.ms",
        "attributes.durations.*.pretty",
    ]
    return check_diagnostics
