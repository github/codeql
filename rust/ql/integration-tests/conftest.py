import textwrap

import pytest
import json
import commands
import pathlib
import tomllib

# Last known Rust version that doesn't cause integration test failures.
# TODO: remove this pinning once we figure out what's going wrong with newer versions.
_PINNED_TOOLCHAIN = "1.94.1"


@pytest.fixture(autouse=True)
def _pin_rust_toolchain(cwd):
    """Pin the Rust toolchain for integration tests.

    Integration tests run from temporary directories, so they don't pick up
    rust-toolchain.toml via rustup's file-based resolution. Writing the file
    into the test's working directory ensures a consistent toolchain version
    regardless of what is pre-installed on the runner image.

    The toolchain must be pre-installed by the CI prepare action to avoid
    concurrent rustup installs from parallel pytest-xdist workers.
    """
    (cwd / "rust-toolchain.toml").write_text(textwrap.dedent(f"""\
        [toolchain]
        channel = "{_PINNED_TOOLCHAIN}"
        components = ["rust-src"]
    """))


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
    rust_sysroot = pathlib.Path(commands.run(f"rustc +{_PINNED_TOOLCHAIN} --print sysroot", _capture=True))
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
