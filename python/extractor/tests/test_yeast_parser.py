from pathlib import Path

import pytest

from semmle.python.parser import yeast_parser
from semmle.python.parser.tokenizer import encoding_from_source


class Logger:
    def debug(self, *_args, **_kwargs):
        pass


def test_non_utf8_source_is_passed_as_utf8(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_EXTRACTOR_PYTHON_ROOT", raising=False)
    path = (Path(__file__).parent / "tokenizer" / "latin.py").resolve()
    encoding, source = encoding_from_source(path.read_bytes())
    source = source.decode(encoding)
    process = mocker.Mock(returncode=0)
    process.communicate.return_value = (b'{"status":"not_parsed"}', b"")
    popen = mocker.patch(
        "semmle.python.parser.yeast_parser.subprocess.Popen",
        return_value=process,
    )

    assert yeast_parser.parse(str(path), source, Logger()) is None
    command, command_separator, cwd = yeast_parser._parser_command()
    popen.assert_called_once_with(
        command + command_separator + [str(path)],
        cwd=cwd,
        stdin=yeast_parser.subprocess.PIPE,
        stdout=yeast_parser.subprocess.PIPE,
        stderr=yeast_parser.subprocess.PIPE,
    )
    process.communicate.assert_called_once_with(source.encode("utf-8"))


def test_packaged_command_accepts_supported_platform(tmp_path):
    expected = tmp_path / "tools" / "linux64" / "yeast-python"

    assert yeast_parser._packaged_command(str(tmp_path), "linux64") == [
        str(expected)
    ]


def test_packaged_command_rejects_unsupported_platform(tmp_path):
    with pytest.raises(ValueError, match="Unsupported CodeQL platform"):
        yeast_parser._packaged_command(str(tmp_path), "../linux64")


def test_packaged_command_rejects_tools_symlink_escape(tmp_path):
    outside = tmp_path / "outside"
    outside.mkdir()
    tools = tmp_path / "tools"
    tools.mkdir()
    (tools / "linux64").symlink_to(outside, target_is_directory=True)

    with pytest.raises(ValueError, match="escapes extractor tools root"):
        yeast_parser._packaged_command(str(tmp_path), "linux64")


def test_packaged_command_rejects_executable_symlink_escape(tmp_path):
    outside = tmp_path / "outside"
    outside.touch()
    tools = tmp_path / "tools" / "linux64"
    tools.mkdir(parents=True)
    (tools / "yeast-python").symlink_to(outside)

    with pytest.raises(ValueError, match="escapes platform tools directory"):
        yeast_parser._packaged_command(str(tmp_path), "linux64")


def test_packaged_command_validation_is_deferred(monkeypatch, tmp_path):
    monkeypatch.setenv("CODEQL_EXTRACTOR_PYTHON_ROOT", str(tmp_path))
    monkeypatch.setenv("CODEQL_PLATFORM", "../linux64")

    with pytest.raises(ValueError, match="Unsupported CodeQL platform"):
        yeast_parser._parser_command()
