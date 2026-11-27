# Functions used for parsing Python files with YEAST.

import json
import os
import subprocess


_SUPPORTED_PLATFORMS = frozenset(("linux64", "linux-arm64", "osx64", "win64"))


def _is_within(path, root):
    try:
        return os.path.commonpath((root, path)) == root
    except ValueError:
        return False


def _packaged_command(extractor_root, platform):
    if platform not in _SUPPORTED_PLATFORMS:
        raise ValueError("Unsupported CodeQL platform {!r}".format(platform))

    tools_root = os.path.realpath(os.path.join(extractor_root, "tools"))
    tools = os.path.realpath(os.path.join(tools_root, platform))
    if not _is_within(tools, tools_root):
        raise ValueError("Platform tools directory escapes extractor tools root")

    ext = ".exe" if platform == "win64" else ""
    executable = os.path.realpath(os.path.join(tools, "yeast-python" + ext))
    if not _is_within(executable, tools):
        raise ValueError("Parser executable escapes platform tools directory")
    return [executable]


_SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
_SOURCE_TREE_ROOT = os.path.realpath(
    os.path.join(_SCRIPT_PATH, "../../../yeast-python")
)
_SOURCE_TREE_COMMAND = [
    "cargo",
    "run",
    "--quiet",
    "--release",
    "--manifest-path=" + os.path.join(_SOURCE_TREE_ROOT, "Cargo.toml"),
]


def _parser_command():
    if "CODEQL_EXTRACTOR_PYTHON_ROOT" in os.environ:
        return (
            _packaged_command(
                os.environ["CODEQL_EXTRACTOR_PYTHON_ROOT"],
                os.environ["CODEQL_PLATFORM"],
            ),
            [],
            None,
        )
    return (
        _SOURCE_TREE_COMMAND,
        ["--"],
        _SOURCE_TREE_ROOT,
    )


def parse(path, source, _logger):
    command, command_separator, cwd = _parser_command()
    command_args = command + command_separator + [os.path.abspath(path)]
    process = subprocess.Popen(
        command_args,
        cwd=cwd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = process.communicate(source.encode("utf-8"))
    if process.returncode:
        raise subprocess.CalledProcessError(
            process.returncode, command_args, stdout, stderr
        )

    result = json.loads(stdout)
    if result == {"status": "not_parsed"}:
        return None
    raise ValueError("Unsupported yeast parser response {!r}".format(result))
