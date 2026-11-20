# Functions used for parsing Python files with YEAST.

import json
import os
import subprocess


if "CODEQL_EXTRACTOR_PYTHON_ROOT" in os.environ:
    platform = os.environ["CODEQL_PLATFORM"]
    ext = ".exe" if platform == "win64" else ""
    tools = os.path.join(os.environ["CODEQL_EXTRACTOR_PYTHON_ROOT"], "tools", platform)
    command = [os.path.join(tools, "yeast-python" + ext)]
    command_separator = []
else:
    script_path = os.path.dirname(os.path.realpath(__file__))
    yeast_python_path = os.path.join(script_path, "../../../yeast-python")
    cargo_file = os.path.join(yeast_python_path, "Cargo.toml")
    command = [
        "cargo",
        "run",
        "--quiet",
        "--release",
        "--manifest-path=" + cargo_file,
    ]
    command_separator = ["--"]


def parse(path, source, _logger):
    command_args = command + command_separator + [path]
    process = subprocess.Popen(
        command_args,
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
