import sys

import commands
import runs_on


def test(codeql, python, cwd):
    # make venv with some package in it (so we show that our ignore logic is correct)
    venv_dir = cwd / "repo_dir" / "venv"
    commands.run([sys.executable, "-m", "venv", venv_dir])
    venv_python = venv_dir / ("Scripts/python.exe" if runs_on.windows else "bin/python")
    commands.run([venv_python, "-m", "pip", "install", "flask"])

    codeql.database.create(
        "normal-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE": ""},
    )
    codeql.database.create(
        "no-venv-ignore-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE": "1"},
    )

    extracted_normal = sum(
        path.is_file() for path in (cwd / "normal-db" / "src").rglob("*")
    )
    extracted_no_venv_ignore = sum(
        path.is_file() for path in (cwd / "no-venv-ignore-db" / "src").rglob("*")
    )
    assert extracted_normal < extracted_no_venv_ignore
