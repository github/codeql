#!/usr/bin/env python3

import base64
import hashlib
import json
import re
import shlex
import subprocess
import sys
import tomllib
import urllib.request
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
MODULE_BAZEL = REPO_ROOT / "MODULE.bazel"
RUST_EXTRACTOR_MANIFEST = REPO_ROOT / "rust/extractor/Cargo.toml"

# The files that mention the fixed Rust toolchain version
TOOLCHAIN_RS = REPO_ROOT / "rust/extractor/src/toolchain.rs"
INTEGRATION_TEST_CONFTEST = REPO_ROOT / "rust/ql/integration-tests/conftest.py"
QL_TEST_SETUP = REPO_ROOT / "rust/ql/test/setup.sh"


def print_step(number: int, description: str) -> None:
    print(f"\nStep {number}: {description}", flush=True)


def run(*command: str) -> None:
    print(f"+ {shlex.join(command)}", flush=True)
    subprocess.run(command, cwd=REPO_ROOT, check=True)


def run_codegen() -> None:
    try:
        run("bazel", "run", "//rust/codegen")
    except subprocess.CalledProcessError as error:
        print(
            "\nCodegen failed. Carry out the instructions from step 5 in rust/updating-rust-analyzer.md manually.",
            file=sys.stderr,
            flush=True,
        )
        raise SystemExit(error.returncode) from None


def get_min_rust_analyzer_version(manifest: str) -> str:
    """Get the minimum version of all ra_ap dependencies from `Cargo.toml`."""
    dependencies = tomllib.loads(manifest)["dependencies"]
    return min(
        (
            version
            for name, version in dependencies.items()
            if name.startswith("ra_ap_")
        ),
        key=lambda value: tuple(map(int, value.split("."))),
    )


def fetch(url: str) -> bytes:
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "github/codeql rust-analyzer updater"},
    )
    with urllib.request.urlopen(request) as response:
        return response.read()


def get_rust_analyzer_release_date(rust_analyzer_version: str) -> str:
    """Get the release date of a rust-analyzer crate version."""
    crate_url = f"https://crates.io/api/v1/crates/ra_ap_syntax/{rust_analyzer_version}"
    crate = json.loads(fetch(crate_url))
    return crate["version"]["created_at"].split("T")[0]


def update_rust_analyzer_sources(rust_analyzer_version: str) -> None:
    """
    Update the rust-analyzer source archive used by the AST generator.

    Concretly, this updates `RUST_ANALYZER_SRC_TAG` and
    `RUST_ANALYZER_SRC_INTEGRITY` in the MODULE.bazel file.
    """

    release_date = get_rust_analyzer_release_date(rust_analyzer_version)
    archive_url = (
        "https://github.com/rust-lang/rust-analyzer/archive/refs/tags/"
        f"{release_date}.tar.gz"
    )
    archive = fetch(archive_url)
    integrity = "sha256-" + base64.b64encode(hashlib.sha256(archive).digest()).decode()

    module = MODULE_BAZEL.read_text()
    module = re.sub(
        r'RUST_ANALYZER_SRC_TAG = "[^"]+"',
        f'RUST_ANALYZER_SRC_TAG = "{release_date}"',
        module,
        count=1,
    )
    module = re.sub(
        r'RUST_ANALYZER_SRC_INTEGRITY = "[^"]+"',
        f'RUST_ANALYZER_SRC_INTEGRITY = "{integrity}"',
        module,
        count=1,
    )
    MODULE_BAZEL.write_text(module)


def get_compatible_rust_toolchain(rust_analyzer_version: str) -> str:
    """Get the latest Rust toolchain released no later than rust-analyzer."""
    rust_analyzer_release = get_rust_analyzer_release_date(rust_analyzer_version)

    # `manifests.txt` is a list of all toolchains. The one we're interested in looks like
    # ```
    # static.rust-lang.org/dist/YYYY-MM-DD/channel-rust-stable.toml
    # ```
    # where `YYYY-MM-DD` is no later than the rust-analyzer release date.
    manifests = (
        fetch("https://static.rust-lang.org/manifests.txt").decode().splitlines()
    )
    rust_manifest = next(
        manifest
        for manifest in reversed(manifests)
        if manifest.endswith("/channel-rust-stable.toml")
        and manifest.split("/")[2] <= rust_analyzer_release
    )
    manifest = tomllib.loads(fetch(f"https://{rust_manifest}").decode())
    # The version looks like `version = "0.99.0 (797e8a9bc 2026-08-05)"` - we only want the first part.
    return manifest["pkg"]["rust"]["version"].split()[0]


def update_fixed_rust_toolchain_versions(version: str) -> None:
    """Change the fixed toolchain in the places where it's hardcoded"""
    toolchain_rs = TOOLCHAIN_RS.read_text()
    prefix = 'const FIXED_RUST_TOOLCHAIN: &str = "'
    old_version = toolchain_rs.split(prefix, 1)[1].split('"', 1)[0]
    TOOLCHAIN_RS.write_text(
        toolchain_rs.replace(
            f'{prefix}{old_version}"',
            f'{prefix}{version}"',
        )
    )

    for test_setup in (INTEGRATION_TEST_CONFTEST, QL_TEST_SETUP):
        contents = test_setup.read_text()
        test_setup.write_text(
            contents.replace(
                f"rustup toolchain install {old_version} ",
                f"rustup toolchain install {version} ",
            )
        )


def align_rust_analyzer_versions(manifest: str) -> tuple[str, bool]:
    """Align ra_ap dependency versions in a Cargo manifest.

    rust-analyzer crates may be published gradually, so this selects the newest
    version that is available for every ra_ap dependency.
    """
    dependencies = {
        name: version
        for name, version in tomllib.loads(manifest)["dependencies"].items()
        if name.startswith("ra_ap_")
    }
    if len(set(dependencies.values())) == 1:
        # All the `ra_ap_` dependencies agree
        return manifest, False

    version = get_min_rust_analyzer_version(manifest)

    for name, old_version in dependencies.items():
        manifest = manifest.replace(
            f'{name} = "{old_version}"',
            f'{name} = "{version}"',
        )
    return manifest, True


def commit_all(title: str) -> None:
    run("git", "add", "--all")
    run("git", "commit", "--no-verify", "--allow-empty", "-m", title)


def main() -> None:
    status = subprocess.run(
        ["git", "status", "--porcelain"],
        cwd=REPO_ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    if status:
        raise RuntimeError("the working tree must be clean")

    print_step(1, "Update dependencies")
    manifest = RUST_EXTRACTOR_MANIFEST.read_text()
    old_rust_analyzer_version = get_min_rust_analyzer_version(manifest)
    run("cargo", "upgrade", "--incompatible", "--pinned")
    # Re-read the (potentially) changed manifest
    manifest = RUST_EXTRACTOR_MANIFEST.read_text()
    new_rust_analyzer_version = get_min_rust_analyzer_version(manifest)
    if new_rust_analyzer_version == old_rust_analyzer_version:
        run("git", "restore", ".")
        print("No new rust-analyzer version available.")
        return

    aligned_manifest, manifest_changed = align_rust_analyzer_versions(manifest)
    if manifest_changed:
        RUST_EXTRACTOR_MANIFEST.write_text(aligned_manifest)
        run("cargo", "update")
    commit_all("Cargo: Upgrade dependencies")

    print_step(2, "Update the rust-analyzer sources used by the AST generator")
    update_rust_analyzer_sources(new_rust_analyzer_version)
    commit_all("Rust: Update rust-analyzer sources")

    print_step(3, "Update the fixed Rust toolchain used by the extractor")
    rust_toolchain = get_compatible_rust_toolchain(new_rust_analyzer_version)
    update_fixed_rust_toolchain_versions(rust_toolchain)
    commit_all("Rust: Update fixed toolchain")

    print_step(4, "Regenerate vendored bazel files")
    run("misc/bazel/3rdparty/update_tree_sitter_extractors_deps.sh")
    commit_all("Bazel: Regenerate vendored cargo dependencies")

    print_step(5, "Run codegen")
    run_codegen()
    commit_all("Rust: Run codegen")

    print_step(6, "Try compiling")
    run("bazel", "run", "//rust:install")


if __name__ == "__main__":
    main()
