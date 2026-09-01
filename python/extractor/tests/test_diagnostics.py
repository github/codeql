import platform

from semmle import logging
from semmle import util
from semmle import worker


def test_extractor_telemetry_message(mocker):
    mocker.patch("semmle.logging.get_analysis_version", return_value="3.13")

    message = logging.extractor_telemetry_message().to_dict()
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
        },
    }


def test_write_extractor_telemetry(mocker):
    diagnostics_writer = mocker.Mock()
    logger = mocker.Mock()

    worker._write_extractor_telemetry(diagnostics_writer, logger)

    diagnostics_writer.write.assert_called_once()
    logger.warning.assert_not_called()


def test_write_extractor_telemetry_handles_io_error(mocker):
    diagnostics_writer = mocker.Mock()
    diagnostics_writer.write.side_effect = OSError("write failed")
    logger = mocker.Mock()

    worker._write_extractor_telemetry(diagnostics_writer, logger)

    logger.warning.assert_called_once_with(
        "Failed to write extractor telemetry: %s", diagnostics_writer.write.side_effect
    )
