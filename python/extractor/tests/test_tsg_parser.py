import unittest

from ast import literal_eval

from semmle.logging import format_message
from semmle.python.parser.tsg_parser import evaluate_string, rust_to_python_escapes


class RustEscapeTest(unittest.TestCase):
    """`tsg-python` serialises strings with Rust's `Debug` formatting, which escapes characters such
    as U+FE0F as `\\u{...}` -- a syntax Python's `literal_eval` does not accept -- and NUL as `\\0`,
    which Python reads as an octal escape."""

    def test_untouched_without_escapes(self):
        text = '"caf\u00e9 \u2713 \U0001f4be"'
        self.assertEqual(rust_to_python_escapes(text), text)

    def test_basic_multilingual_plane(self):
        self.assertEqual(rust_to_python_escapes(r'"\u{fe0f}"'), r'"\ufe0f"')
        self.assertEqual(rust_to_python_escapes(r'"\u{200d}"'), r'"\u200d"')

    def test_short_and_astral_code_points(self):
        self.assertEqual(rust_to_python_escapes(r'"\u{0}"'), r'"\u0000"')
        self.assertEqual(rust_to_python_escapes(r'"\u{1f4a9}"'), r'"\U0001f4a9"')

    def test_other_escapes_are_preserved(self):
        self.assertEqual(rust_to_python_escapes(r'"a\nb\"c\u{ad}"'), r'"a\nb\"c\u00ad"')

    def test_escaped_backslash_is_not_an_escape_introducer(self):
        # How a raw string `r"\u{fe0f}"` in the analysed source gets serialised: the `\u{fe0f}` is
        # literal text, not an escape, and must survive unchanged.
        self.assertEqual(rust_to_python_escapes(r'"\\u{fe0f}"'), r'"\\u{fe0f}"')

    def test_nul_is_not_left_as_an_octal_escape(self):
        # Rust renders NUL as `\0`; Python would read that as the start of an octal escape and
        # swallow the digits that follow, decoding `"\01"` to U+0001 instead of NUL then `1`.
        self.assertEqual(rust_to_python_escapes(r'"\01"'), r'"\x001"')

    def test_every_escape_shape_round_trips(self):
        # Rust's `Debug for str` only ever emits these escape shapes. Check that each round-trips
        # with every printable ASCII neighbour before and after it.
        for escape_shape, expected in [
            (r'\0', "\x00"),
            (r'\t', "\t"),
            (r'\n', "\n"),
            (r'\r', "\r"),
            (r'\\', "\\"),
            (r'\"', '"'),
            (r'\u{1}', "\u0001"),
            (r'\u{1f}', "\u001f"),
            (r'\u{300}', "\u0300"),
            (r'\u{fe0f}', "\ufe0f"),
            (r'\u{e0100}', "\U000e0100"),
            (r'\u{10fffe}', "\U0010fffe"),
        ]:
            for neighbour in map(chr, range(0x20, 0x7F)):
                rendered_neighbour = {"\\": r"\\", '"': r'\"'}.get(neighbour, neighbour)
                for position, text, expected_value in [
                    ("before", '"' + rendered_neighbour + escape_shape + '"', neighbour + expected),
                    ("after", '"' + escape_shape + rendered_neighbour + '"', expected + neighbour),
                ]:
                    with self.subTest(
                        escape_shape=escape_shape,
                        neighbour=neighbour,
                        position=position,
                    ):
                        self.assertEqual(literal_eval(rust_to_python_escapes(text)), expected_value)

    def test_evaluate_string_on_reported_value(self):
        # The exact value from https://github.com/github/codeql/issues/22435 that used to raise
        # `truncated \uXXXX escape`.
        value = rust_to_python_escapes('"\\"\u26a0\\u{fe0f}  problem %s: %s\\""')
        self.assertEqual(evaluate_string(value), "\u26a0\ufe0f  problem %s: %s")


class FormatMessageTest(unittest.TestCase):
    """A pre-formatted log message may contain `%` directives coming from the analysed source, and
    must not be `%`-formatted again."""

    def test_no_arguments(self):
        message = "Error while parsing value '%s: %s'"
        self.assertEqual(format_message(message, ()), message)

    def test_with_arguments(self):
        self.assertEqual(format_message("%s and %s", ("a", "b")), "a and b")
