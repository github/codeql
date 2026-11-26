import platform

from semmle import logging
from semmle import util
from semmle import worker
from semmle.python.modules import PythonSourceModule


def test_extractor_telemetry_message(mocker):
    mocker.patch("semmle.logging.get_analysis_version", return_value="3.13")

    message = logging.extractor_telemetry_message(["colorize", "p"]).to_dict()
    message.pop("timestamp")

    assert message == {
        "source": {
            "id": "py/extractor/summary",
            "name": "Python extractor telemetry",
            "extractorName": "python",
        },
        "severity": "note",
        "markdownMessage": "Internal telemetry for the Python extractor.\n\nNo action needed.",
        "visibility": {
            "statusPage": False,
            "cliSummaryTable": False,
            "telemetry": True,
        },
        "attributes": {
            "python_analysis_version": "3.13",
            "python_runtime_version": platform.python_version(),
            "extractor_version": util.VERSION,
            "extractor_flags": "colorize p",
        },
    }


def test_parser_statistics_telemetry_message():
    message = logging.parser_statistics_telemetry_message(
        old_parser_file_count=12, tree_sitter_parser_file_count=3
    ).to_dict()
    message.pop("timestamp")

    assert message == {
        "source": {
            "id": "py/extractor/parser-statistics",
            "name": "Python parser statistics",
            "extractorName": "python",
        },
        "severity": "note",
        "markdownMessage": "Internal parser telemetry for the Python extractor.\n\nNo action needed.",
        "visibility": {
            "statusPage": False,
            "cliSummaryTable": False,
            "telemetry": True,
        },
        "attributes": {
            "old_parser_file_count": 12,
            "tree_sitter_parser_file_count": 3,
        },
    }


def test_extractor_telemetry_message_includes_empty_flags():
    message = logging.extractor_telemetry_message([]).to_dict()

    assert message["attributes"]["extractor_flags"] == "default"


def test_write_extractor_telemetry(mocker):
    diagnostics_writer = mocker.Mock()
    logger = mocker.Mock()

    worker._write_extractor_telemetry(diagnostics_writer, logger, ["quiet"])

    diagnostics_writer.write.assert_called_once()
    assert diagnostics_writer.write.call_args.args[0].to_dict()["attributes"] == {
        "python_analysis_version": util.get_analysis_version(),
        "python_runtime_version": platform.python_version(),
        "extractor_version": util.VERSION,
        "extractor_flags": "quiet",
    }
    logger.warning.assert_not_called()


def test_write_extractor_telemetry_handles_io_error(mocker):
    diagnostics_writer = mocker.Mock()
    diagnostics_writer.write.side_effect = OSError("write failed")
    logger = mocker.Mock()

    worker._write_extractor_telemetry(diagnostics_writer, logger, [])

    logger.warning.assert_called_once_with(
        "Failed to write extractor telemetry: %s", diagnostics_writer.write.side_effect
    )


def test_write_parser_statistics_telemetry(mocker):
    diagnostics_writer = mocker.Mock()
    diagnostics_writer.parser_statistics.return_value = (1, 1)
    logger = mocker.Mock()

    worker._write_parser_statistics_telemetry(diagnostics_writer, logger)

    diagnostics_writer.write.assert_called_once()
    assert diagnostics_writer.write.call_args.args[0].to_dict()["attributes"] == {
        "old_parser_file_count": 1,
        "tree_sitter_parser_file_count": 1,
    }
    logger.warning.assert_not_called()


def test_does_not_write_empty_parser_statistics_telemetry(mocker):
    diagnostics_writer = mocker.Mock()
    diagnostics_writer.parser_statistics.return_value = (0, 0)
    logger = mocker.Mock()

    worker._write_parser_statistics_telemetry(diagnostics_writer, logger)

    diagnostics_writer.write.assert_not_called()
    logger.warning.assert_not_called()


def test_records_old_parser_usage_once(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    old_ast = object()
    mocker.patch("semmle.python.parser.yeast_parser.parse", return_value=None)
    mocker.patch("semmle.python.parser.parse", return_value=old_ast)
    diagnostics_writer = worker.DiagnosticsWriter(1)
    module = PythonSourceModule(
        None,
        "test.py",
        mocker.Mock(),
        diagnostics_writer,
        bytes_source=b"x = 1\n",
    )

    parsed_ast = module.py_ast
    # Access the cached AST again to verify that it is not counted twice.
    _ = module.py_ast

    assert parsed_ast is old_ast
    assert diagnostics_writer.parser_statistics() == (1, 0)


def test_tries_yeast_parser_before_old_parser(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_YEAST_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    calls = []
    old_ast = object()
    mocker.patch(
        "semmle.python.parser.yeast_parser.parse",
        side_effect=lambda *_args: calls.append("yeast"),
    )
    mocker.patch(
        "semmle.python.parser.parse",
        side_effect=lambda *_args: calls.append("old") or old_ast,
    )
    diagnostics_writer = worker.DiagnosticsWriter(1)
    module = PythonSourceModule(
        None,
        "test.py",
        mocker.Mock(),
        diagnostics_writer,
        bytes_source=b"x = 1\n",
    )

    assert module.py_ast is old_ast
    assert calls == ["yeast", "old"]
    assert diagnostics_writer.parser_statistics() == (1, 0)


def test_can_disable_yeast_parser(mocker, monkeypatch):
    monkeypatch.setenv("CODEQL_PYTHON_DISABLE_YEAST_PARSER", "1")
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    old_ast = object()
    yeast_parse = mocker.patch("semmle.python.parser.yeast_parser.parse")
    mocker.patch("semmle.python.parser.parse", return_value=old_ast)
    diagnostics_writer = worker.DiagnosticsWriter(1)
    module = PythonSourceModule(
        None,
        "test.py",
        mocker.Mock(),
        diagnostics_writer,
        bytes_source=b"x = 1\n",
    )

    assert module.py_ast is old_ast
    yeast_parse.assert_not_called()
    assert diagnostics_writer.parser_statistics() == (1, 0)


def test_passes_decoded_non_utf8_source_to_yeast_parser(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_YEAST_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    old_ast = object()
    yeast_parse = mocker.patch(
        "semmle.python.parser.yeast_parser.parse", return_value=None
    )
    mocker.patch("semmle.python.parser.parse", return_value=old_ast)
    diagnostics_writer = worker.DiagnosticsWriter(1)
    logger = mocker.Mock()
    module = PythonSourceModule(
        None,
        "test.py",
        logger,
        diagnostics_writer,
        bytes_source=b"# coding: latin-1\nvalue = '\xe9'\n",
    )

    assert module.py_ast is old_ast
    yeast_parse.assert_called_once_with(
        "test.py", "# coding: latin-1\nvalue = '\xe9'\n", logger
    )
    assert diagnostics_writer.parser_statistics() == (1, 0)


def test_falls_back_when_yeast_parser_fails(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_YEAST_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    old_ast = object()
    mocker.patch(
        "semmle.python.parser.yeast_parser.parse",
        side_effect=ValueError("unsupported input"),
    )
    mocker.patch("semmle.python.parser.parse", return_value=old_ast)
    diagnostics_writer = worker.DiagnosticsWriter(1)
    module = PythonSourceModule(
        None,
        "test.py",
        mocker.Mock(),
        diagnostics_writer,
        bytes_source=b"x = 1\n",
    )

    assert module.py_ast is old_ast
    assert diagnostics_writer.parser_statistics() == (1, 0)


def test_records_tree_sitter_parser_usage_once(mocker, monkeypatch):
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_YEAST_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_OLD_PARSER", raising=False)
    monkeypatch.delenv("CODEQL_PYTHON_DISABLE_TSG_PARSER", raising=False)
    tree_sitter_ast = object()
    mocker.patch("semmle.python.parser.yeast_parser.parse", return_value=None)
    mocker.patch("semmle.python.parser.parse", side_effect=SyntaxError("old parser failed"))
    mocker.patch(
        "semmle.python.parser.tsg_parser.parse", return_value=tree_sitter_ast
    )
    diagnostics_writer = worker.DiagnosticsWriter(1)
    module = PythonSourceModule(
        None,
        "test.py",
        mocker.Mock(),
        diagnostics_writer,
        bytes_source=b"x = 1\n",
    )

    parsed_ast = module.py_ast
    # Access the cached AST again to verify that it is not counted twice.
    _ = module.py_ast

    assert parsed_ast is tree_sitter_ast
    assert diagnostics_writer.parser_statistics() == (0, 1)
