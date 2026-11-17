#!/usr/bin/env python3
"""Time production extraction only; never create or import a CodeQL database."""

import argparse
import json
import os
from pathlib import Path
import platform
import shlex
import shutil
import subprocess
import sys


MARKER = ".swift-parser-extractor-bench"
OUTPUTS = ("scratch", "trap", "archive")


def work_path(value):
    path = Path(os.path.abspath(value))
    if path != path.resolve():
        raise ValueError("work directory and its parents must not be symlinks")
    if path == Path.home() or path in Path(__file__).resolve().parents:
        raise ValueError("work directory must be a dedicated benchmark directory")
    return path


def prepare(work):
    """Only reset named outputs beneath a directory created and marked here."""
    expected = json.dumps({"purpose": MARKER, "path": str(work)}) + "\n"
    if not work.exists():
        work.mkdir()
        (work / MARKER).write_text(expected)
    marker = work / MARKER
    if marker.is_symlink() or not marker.is_file() or marker.read_text() != expected:
        raise ValueError(f"refusing unowned work directory: {work}")
    if set(p.name for p in work.iterdir()) - {MARKER, *OUTPUTS}:
        raise ValueError(f"unexpected contents in work directory: {work}")
    for name in OUTPUTS:
        path = work / name
        if path.is_symlink() or (path.exists() and not path.is_dir()):
            raise ValueError(f"refusing non-directory output: {path}")
    for name in OUTPUTS:
        path = work / name
        if path.exists():
            shutil.rmtree(path)
        path.mkdir()


def positive(value):
    number = int(value)
    if number < 1:
        raise argparse.ArgumentTypeError("must be positive")
    return number


def bench(options):
    work = work_path(options.work_dir)
    file_list = options.file_list.resolve(strict=True)
    lines = file_list.read_text(encoding="utf-8").splitlines()
    if not lines or any(not line or not Path(line).is_absolute() for line in lines):
        raise ValueError("file list must contain nonempty absolute source paths")
    if any(not Path(line).is_file() for line in lines):
        raise ValueError("file list contains a missing source file")
    output = options.export_json.resolve()
    packs = [pack.resolve(strict=True) for pack in options.pack]
    # Never reset an ancestor of inputs, results, packs, or this checkout.
    protected = [file_list, output, Path.cwd().resolve(), *packs]
    protected.extend(Path(line).resolve() for line in lines)
    if any(path == work or work in path.parents for path in protected):
        raise ValueError("work directory must not contain inputs, packs, or results")
    host = {"Darwin": "osx64", "Linux": "linux64"}.get(platform.system())
    if host is None:
        raise ValueError("only macOS and Linux extractor packs are supported")
    commands = []
    for pack in packs:
        binary = pack / "tools" / host / "extractor"
        with binary.open("rb") as stream:
            if stream.read(2) == b"#!":
                raise ValueError(f"expected a production binary, not a wrapper: {binary}")
        if not (pack / "tools" / "builtins").is_dir():
            raise ValueError(f"missing pack builtins: {pack}")
        commands.append(
            shlex.join(
                [
                    "env",
                    f"CODEQL_EXTRACTOR_UNIFIED_ROOT={pack}",
                    f"CODEQL_EXTRACTOR_UNIFIED_SCRATCH_DIR={work / 'scratch'}",
                    f"CODEQL_THREADS={options.threads}",
                    f"RAYON_NUM_THREADS={options.threads}",
                    "CODEQL_EXTRACTOR_UNIFIED_OPTION_TRAP_COMPRESSION=gzip",
                    str(binary),
                    "extract",
                    "--file-list",
                    str(file_list),
                    "--output-dir",
                    str(work / "trap"),
                    "--source-archive-dir",
                    str(work / "archive"),
                ]
            )
        )
    prepare(work)
    preparation = shlex.join(
        [sys.executable, str(Path(__file__).resolve()), "prepare", "--work-dir", str(work)]
    )
    subprocess.run(
        [
            options.hyperfine,
            "--shell=none",
            "--warmup",
            str(options.warmup),
            "--runs",
            str(options.runs),
            "--prepare",
            preparation,
            "--export-json",
            str(output),
            *commands,
        ],
        check=True,
    )


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog=(
            "Build release Rust-parser packs independently before timing. "
            "Use --pack BEFORE --pack AFTER in that order, with the same absolute "
            "file list. Includes process startup, source reads, parsing, AST/desugaring, "
            "TRAP (gzip) and source archive writes, plus pack builtins. "
            "Does not isolate parsing. Output reset runs in hyperfine --prepare, "
            "outside timing; OS caches are not cleared. No shell redirections needed."
        ),
    )
    commands = parser.add_subparsers(dest="command", required=True)
    reset = commands.add_parser("prepare", help="create/reset owned benchmark outputs only")
    reset.add_argument("--work-dir", required=True, help="dedicated directory, initially absent")
    measure = commands.add_parser(
        "bench", help="hyperfine one baseline pack or two independently built before/after packs"
    )
    measure.add_argument("--pack", type=Path, action="append", required=True)
    measure.add_argument("--file-list", type=Path, required=True)
    measure.add_argument("--work-dir", required=True, help="dedicated directory, initially absent")
    measure.add_argument("--export-json", type=Path, required=True)
    measure.add_argument("--hyperfine", default="hyperfine")
    measure.add_argument("--threads", type=positive, default=2)
    measure.add_argument("--warmup", type=positive, default=3)
    measure.add_argument("--runs", type=positive, default=10)
    options = parser.parse_args()
    try:
        if options.command == "prepare":
            prepare(work_path(options.work_dir))
        else:
            if len(options.pack) > 2:
                raise ValueError("use one baseline pack or two before/after packs")
            bench(options)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"error: {error}\n")


if __name__ == "__main__":
    main()
