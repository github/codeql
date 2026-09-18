#!/usr/bin/env python3
"""Tests for `language_tests.py`.

`just` is stubbed out here: what this file decides is the invocation, and running it
needs a built CLI and a whole test suite. The invocation is also where the interesting
property lives, as an argument has to reach the suite exactly as it was written.
"""

import contextlib
import io
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import language_tests


class TestMain(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        # Resolved once: macOS puts temporary directories behind a symbolic link, and
        # an unresolved root would not be a prefix of the paths built from it.
        self.semmle_code = Path(temporary.name).resolve()
        self.suite = self.semmle_code / "ql" / "rust" / "ql" / "test"
        self.suite.mkdir(parents=True)
        (self.semmle_code / "ql" / "rust" / "justfile").touch()

    def run_main(self, *argv, environment=None, side_effect=None):
        """Run `main` with `just` stubbed out, returning its status and that stub."""
        env = {"SEMMLE_CODE": str(self.semmle_code), "JUST_EXECUTABLE": "just"}
        env.update(environment or {})
        printed = io.StringIO()
        with (
            mock.patch.object(
                language_tests.sys, "argv", ["language_tests.py", *argv]
            ),
            mock.patch.dict(os.environ, env),
            mock.patch.object(
                language_tests.subprocess, "run", side_effect=side_effect
            ) as run,
            contextlib.redirect_stdout(printed),
            # The messages it writes here are expected by the tests below, and reading
            # them among the results would suggest something had gone wrong.
            contextlib.redirect_stderr(io.StringIO()),
        ):
            status = language_tests.main()
        return status, run, printed.getvalue()

    def invocation(self, *argv, **kwargs):
        status, run, _ = self.run_main(*argv, **kwargs)
        self.assertEqual(status, 0)
        return list(run.call_args.args[0])

    def test_relativizes_an_absolute_root_against_the_checkout(self):
        # Roots are absolute because a justfile builds them from `source_dir()`, and
        # the command line is read by people.
        self.assertEqual(
            self.invocation(str(self.suite))[-1],
            os.path.join("ql", "rust", "ql", "test"),
        )

    def test_finds_the_nearest_justfile_above_the_root(self):
        invocation = self.invocation(str(self.suite))
        self.assertEqual(
            invocation[invocation.index("--justfile") + 1],
            str(Path("ql/rust/justfile")),
        )

    def test_asks_for_the_checks_ci_wants(self):
        invocation = self.invocation(str(self.suite))
        self.assertIn("--all-checks", invocation)
        self.assertIn("--codeql=built", invocation)

    def test_runs_from_the_checkout(self):
        _, run, _ = self.run_main(str(self.suite))
        self.assertEqual(run.call_args.kwargs["cwd"], self.semmle_code)

    def test_an_argument_containing_a_space_stays_one_argument(self):
        """The reason these arrive as a list rather than one string to re-split.

        Splitting on whitespace made this reach the suite as two arguments, and a value
        that was only whitespace reached it as its own separators.
        """
        self.assertIn("EXTRA=a b", self.invocation(str(self.suite), "EXTRA=a b"))

    def test_a_relative_argument_is_passed_verbatim(self):
        self.assertIn("--fail-fast", self.invocation(str(self.suite), "--fail-fast"))

    def test_keeps_the_arguments_in_the_order_they_were_given(self):
        invocation = self.invocation(str(self.suite), "CPUS=2", "--verbose")
        self.assertEqual(invocation[-3:], [os.path.join("ql", "rust", "ql", "test"), "CPUS=2", "--verbose"])

    def test_uses_the_just_it_was_given(self):
        invocation = self.invocation(
            str(self.suite), environment={"JUST_EXECUTABLE": "/opt/just"}
        )
        self.assertEqual(invocation[0], "/opt/just")

    def test_says_what_it_is_about_to_run(self):
        _, _, printed = self.run_main(str(self.suite))
        self.assertIn("-> just", printed)

    def test_needs_a_root(self):
        status, run, _ = self.run_main()
        self.assertEqual(status, 1)
        run.assert_not_called()

    def test_nothing_but_blank_arguments_is_no_arguments(self):
        # An unset variable interpolated by a caller arrives as one of these. Counting
        # it as an argument and then dropping it left nothing to take a root from.
        status, run, _ = self.run_main("", "")
        self.assertEqual(status, 1)
        run.assert_not_called()

    def test_reports_a_root_with_no_justfile_above_it(self):
        orphan = self.semmle_code / "elsewhere"
        orphan.mkdir()
        status, run, _ = self.run_main(str(orphan))
        self.assertEqual(status, 1)
        run.assert_not_called()

    def test_passes_on_the_status_of_a_failing_suite(self):
        failure = subprocess.CalledProcessError(3, "just")
        status, _, _ = self.run_main(str(self.suite), side_effect=failure)
        self.assertEqual(status, 3)


if __name__ == "__main__":
    unittest.main()
