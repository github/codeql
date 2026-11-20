from pathlib import Path

from semmle.python.parser import yeast_parser
from semmle.python.parser.tokenizer import encoding_from_source


class Logger:
    def debug(self, *_args, **_kwargs):
        pass


def test_non_utf8_source_is_passed_as_utf8(mocker):
    path = Path(__file__).parent / "tokenizer" / "latin.py"
    encoding, source = encoding_from_source(path.read_bytes())
    source = source.decode(encoding)
    process = mocker.Mock(returncode=0)
    process.communicate.return_value = (b'{"status":"not_parsed"}', b"")
    popen = mocker.patch(
        "semmle.python.parser.yeast_parser.subprocess.Popen",
        return_value=process,
    )

    assert yeast_parser.parse(str(path), source, Logger()) is None
    popen.assert_called_once_with(
        yeast_parser.command + yeast_parser.command_separator + [str(path)],
        stdin=yeast_parser.subprocess.PIPE,
        stdout=yeast_parser.subprocess.PIPE,
        stderr=yeast_parser.subprocess.PIPE,
    )
    process.communicate.assert_called_once_with(source.encode("utf-8"))
