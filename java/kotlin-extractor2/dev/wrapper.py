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


file_template = "kotlin-compiler-{version}.zip"
url_template = "https://github.com/JetBrains/kotlin/releases/download/v{version}/kotlin-compiler-{version}.zip"
this_dir = pathlib.Path(__file__).resolve().parent
version_file = this_dir / ".kotlinc_version"
install_dir = this_dir / ".kotlinc_installed"
zips_dir = this_dir / ".kotlinc_zips"
windows_ripunzip = (
    this_dir.parents[4] / "resources" / "lib" / "windows" / "ripunzip" / "ripunzip.exe"
)


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
    file = file_template.format(version=version)
    url = url_template.format(version=version)
    if install_dir.exists():
        shutil.rmtree(install_dir)
    install_dir.mkdir()
    zips_dir.mkdir(exist_ok=True)
    zip = zips_dir / file

    if not zip.exists():
        info(f"downloading {url}")
        tmp_zip = zip.with_suffix(".tmp")
        with open(tmp_zip, "wb") as out, urllib.request.urlopen(url) as response:
            shutil.copyfileobj(response, out)
        tmp_zip.rename(zip)
    ripunzip = shutil.which("ripunzip")
    if (
        ripunzip is None
        and platform.system() == "Windows"
        and windows_ripunzip.exists()
    ):
        ripunzip = windows_ripunzip
    if ripunzip:
        info(f"extracting {zip} using ripunzip")
        subprocess.run(
            [ripunzip, "unzip-file", zip],
            stdout=info_out,
            stderr=info_out,
            cwd=install_dir,
            check=True,
        )
    else:
        info(f"extracting {zip}")
        with ZipFilePreservingPermissions(zip) as archive:
            archive.extractall(install_dir)


def forward(tool, forwarded_opts):
    tool = install_dir / "kotlinc" / "bin" / tool
    if platform.system() == "Windows":
        tool = tool.with_suffix(".bat")
    assert tool.exists(), f"{tool} not found"
    cmd = [tool] + forwarded_opts
    if platform.system() == "Windows":
        # kotlin bat script is pretty sensible to unquoted args on windows
        ret = subprocess.run(" ".join(f'"{a}"' for a in cmd)).returncode
        sys.exit(ret)
    else:
        os.execv(cmd[0], cmd)


def clear():
    if install_dir.exists():
        print(f"removing {install_dir}", file=sys.stderr)
        shutil.rmtree(install_dir)
    if version_file.exists():
        print(f"removing {version_file}", file=sys.stderr)
        version_file.unlink()
    if zips_dir.exists():
        print(f"removing {zips_dir}", file=sys.stderr)
        shutil.rmtree(zips_dir)


def main(opts, forwarded_opts):
    if opts.clear:
        clear()
        return
    current_version = get_version()
    if opts.select == "default":
        selected_version = DEFAULT_VERSION
    elif opts.select is not None:
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
            print(
                f"info: kotlinc-jvm {selected_version} (codeql dev wrapper)",
                file=sys.stderr,
            )
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
