import os
import sys

import commands
import runs_on


def test(codeql, python, cwd, monkeypatch):
    num_python_files = len(list((cwd / "repo_dir" / "src").rglob("*.py")))
    commands.run([sys.executable, "-m", "venv", "venv"])
    venv_dir = cwd / "venv"
    venv_bin = venv_dir / ("Scripts" if runs_on.windows else "bin")
    monkeypatch.setenv("PATH", str(venv_bin) + os.pathsep + os.environ["PATH"])
    monkeypatch.setenv("VIRTUAL_ENV", str(venv_dir))
    commands.run(["python", "-m", "pip", "install", "--upgrade", "pip>=21.3"])
    commands.run(["python", "-m", "pip", "install", "."], _cwd="repo_dir")

    codeql.database.create(
        "normal-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE": ""},
    )
    codeql.database.create(
        "with-build-dir-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE": "1"},
    )

    extracted_normal = sum(
        path.is_file() for path in (cwd / "normal-db" / "src").rglob("*")
    )
    extracted_with_build = sum(
        path.is_file() for path in (cwd / "with-build-dir-db" / "src").rglob("*")
    )
    assert extracted_normal + num_python_files == extracted_with_build
