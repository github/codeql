#!/usr/bin/env python3

"""
Wrapper script that manages kotlin versions.
Usage: add this directory to your PATH, then
* `kotlin* --select x.y.z` will select the version for the next invocations, checking it actually exists
* `kotlin* --clear` will remove any state of the wrapper (deselecting a previous version selection)
* `kotlinc -version` will print the selected version information. It will not print `JRE` information as a normal
  `kotlinc` invocation would do though. In exchange, the invocation incurs no overhead.
* Any other invocation will forward to the selected kotlin tool version, downloading it if necessary. If no version was
  previously selected with `--select`, a default will be used (see `DEFAULT_VERSION` below)

In order to install kotlin, ripunzip will be used if installed, or if running on Windows within `semmle-code` (ripunzip
is available in `resources/lib/windows/ripunzip` then).
"""

import pathlib
import urllib
import urllib.request
import urllib.error
import argparse
import sys
import platform
import subprocess
import zipfile
import shutil
import io
import os

DEFAULT_VERSION = "2.0.0"

def options():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("tool")
    parser.add_argument("--select")
    parser.add_argument("--clear", action="store_true")
    parser.add_argument("-version", action="store_true")
    return parser.parse_known_args()


url_template = 'https://github.com/JetBrains/kotlin/releases/download/v{version}/kotlin-compiler-{version}.zip'
this_dir = pathlib.Path(__file__).resolve().parent
version_file = this_dir / ".kotlinc_version"
install_dir = this_dir / ".kotlinc_installed"
windows_ripunzip = this_dir.parents[4] / "resources" / "lib" / "windows" / "ripunzip" / "ripunzip.exe"


class Error(Exception):
    pass


class ZipFilePreservingPermissions(zipfile.ZipFile):
    def _extract_member(self, member, targetpath, pwd):
        if not isinstance(member, zipfile.ZipInfo):
            member = self.getinfo(member)

        targetpath = super()._extract_member(member, targetpath, pwd)

        attr = member.external_attr >> 16
        if attr != 0:
            os.chmod(targetpath, attr)
        return targetpath


def check_version(version: str):
    try:
        with urllib.request.urlopen(url_template.format(version=version)) as response:
            pass
    except urllib.error.HTTPError as e:
        if e.code == 404:
            raise Error(f"Version {version} not found in github.com/JetBrains/kotlin/releases") from e
        raise


def get_version():
    try:
        return version_file.read_text()
    except FileNotFoundError:
        return None


def install(version: str, quiet: bool):
    if quiet:
        info_out = subprocess.DEVNULL
        info = lambda *args: None
    else:
        info_out = sys.stderr
        info = lambda *args: print(*args, file=sys.stderr)
    url = url_template.format(version=version)
    if install_dir.exists():
        shutil.rmtree(install_dir)
    install_dir.mkdir()
    ripunzip = shutil.which("ripunzip")
    if ripunzip is None and platform.system() == "Windows" and windows_ripunzip.exists():
        ripunzip = windows_ripunzip
    if ripunzip:
        info(f"downloading and extracting {url} using ripunzip")
        subprocess.run([ripunzip, "unzip-uri", url], stdout=info_out, stderr=info_out, cwd=install_dir,
                       check=True)
        return
    with io.BytesIO() as buffer:
        info(f"downloading {url}")
        with urllib.request.urlopen(url) as response:
            while True:
                bytes = response.read()
                if not bytes:
                    break
                buffer.write(bytes)
        buffer.seek(0)
        info(f"extracting kotlin-compiler-{version}.zip")
        with ZipFilePreservingPermissions(buffer) as archive:
            archive.extractall(install_dir)


def forward(tool, forwarded_opts):
    tool = install_dir / "kotlinc" / "bin" / tool
    if platform.system() == "Windows":
        tool = tool.with_suffix(".bat")
    assert tool.exists(), f"{tool} not found"
    args = [tool]
    args.extend(forwarded_opts)
    ret = subprocess.run(args).returncode
    sys.exit(ret)


def clear():
    if install_dir.exists():
        print(f"removing {install_dir}", file=sys.stderr)
        shutil.rmtree(install_dir)
    if version_file.exists():
        print(f"removing {version_file}", file=sys.stderr)
        version_file.unlink()


def main(opts, forwarded_opts):
    if opts.clear:
        clear()
        return
    current_version = get_version()
    if opts.select == "default":
        selected_version = DEFAULT_VERSION
    elif opts.select is not None:
        check_version(opts.select)
        selected_version = opts.select
    else:
        selected_version = current_version or DEFAULT_VERSION
    if selected_version != current_version:
        # don't print information about install procedure unless explicitly using --select
        install(selected_version, quiet=opts.select is None)
        version_file.write_text(selected_version)
    if opts.select and not forwarded_opts and not opts.version:
        print(f"selected {selected_version}")
        return
    if opts.version:
        if opts.tool == "kotlinc":
            print(f"info: kotlinc-jvm {selected_version} (codeql dev wrapper)", file=sys.stderr)
            return
        forwarded_opts.append("-version")

    forward(opts.tool, forwarded_opts)


if __name__ == "__main__":
    try:
        main(*options())
    except Error as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)
