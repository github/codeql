import pytest
import json
import commands
import pathlib


@pytest.fixture
def cargo(cwd):
    assert (cwd / "Cargo.toml").exists()
    (cwd / "rust-project.json").unlink(missing_ok=True)


@pytest.fixture
def rust_project(cwd):
    project_file = cwd / "rust-project.json"
    assert project_file.exists()
    rust_sysroot = pathlib.Path(commands.run("rustc --print sysroot", _capture=True))
    project = json.loads(project_file.read_text())
    project["sysroot_src"] = str(rust_sysroot.joinpath("lib", "rustlib", "src", "rust", "library"))
    project_file.write_text(json.dumps(project, indent=4))
    (cwd / "Cargo.toml").unlink(missing_ok=True)
