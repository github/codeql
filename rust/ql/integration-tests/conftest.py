import pytest
import json
import commands
import pathlib
import tomllib


@pytest.fixture(params=[2018, 2021, 2024])
def rust_edition(request):
    return request.param


@pytest.fixture
def cargo(cwd, rust_edition):
    manifest_file = cwd / "Cargo.toml"
    assert manifest_file.exists()
    (cwd / "rust-project.json").unlink(missing_ok=True)

    def update(file):
        contents = file.read_text()
        m = tomllib.loads(contents)
        if 'package' in m:
            # tomllib does not support writing, and we don't want to use further dependencies
            # so we just do a dumb search and replace
            contents = contents.replace(f'edition = "{m["package"]["edition"]}"', f'edition = "{rust_edition}"')
            file.write_text(contents)
        if 'members' in m.get('workspace', ()):
            for member in m['workspace']['members']:
                update(file.parent / member / "Cargo.toml")

    update(manifest_file)


@pytest.fixture(scope="session")
def rust_sysroot_src() -> str:
    rust_sysroot = pathlib.Path(commands.run("rustc --print sysroot", _capture=True))
    ret = rust_sysroot.joinpath("lib", "rustlib", "src", "rust", "library")
    assert ret.exists()
    return str(ret)


@pytest.fixture
def rust_project(cwd, rust_sysroot_src, rust_edition):
    project_file = cwd / "rust-project.json"
    assert project_file.exists()
    project = json.loads(project_file.read_text())
    project["sysroot_src"] = rust_sysroot_src
    for c in project["crates"]:
        c["edition"] = str(rust_edition)
    project_file.write_text(json.dumps(project, indent=4))
    (cwd / "Cargo.toml").unlink(missing_ok=True)


@pytest.fixture
def rust_check_diagnostics(check_diagnostics):
    check_diagnostics.redact += [
        "attributes.durations.*.ms",
        "attributes.durations.*.pretty",
    ]
    return check_diagnostics
