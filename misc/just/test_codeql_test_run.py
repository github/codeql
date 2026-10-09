#!/usr/bin/env python3
"""Tests for `codeql_test_run.py`.

Sorting arguments is the whole of what this file decides, and it decides it by looking
at each one: a word is a test, a `-` is a flag, `NAME=value` is an environment
assignment. Several of these pin down that an argument arrives whole, spaces and all,
which is what taking them as a list rather than re-splitting a string bought.

Sorting and resolving are tested at different levels because they happen at different
levels. `parse_arguments` only sorts; a setting is not resolved until `main` has merged
the assignments into the environment, so anything about precedence is observed there.
"""

import os
import sys
import unittest
from unittest import mock

import codeql_test_run


def sorted_args(*argv, semmle_code=None):
    """Sort a command line, supplying the language that always precedes it."""
    with (
        mock.patch.object(codeql_test_run, "SEMMLE_CODE", semmle_code),
        mock.patch.object(sys, "argv", ["codeql_test_run.py", "alanguage", *argv]),
    ):
        return codeql_test_run.parse_arguments()


def run_main(*argv, environ=None):
    """Run `main` with the executable and the child process stubbed out.

    Returns the flags and tests handed to `codeql test run`, and the environment the
    child would have been given.
    """
    codeql = mock.MagicMock()
    codeql.exists.return_value = True
    with (
        mock.patch.object(codeql_test_run, "SEMMLE_CODE", None),
        mock.patch.object(sys, "argv", ["codeql_test_run.py", "alanguage", *argv]),
        mock.patch.dict(os.environ, environ or {}, clear=True),
        mock.patch.object(codeql_test_run, "resolve_codeql", return_value=codeql),
        mock.patch.object(codeql_test_run, "invoke", return_value=0) as invoke,
    ):
        codeql_test_run.main()
        (invocation,) = invoke.call_args.args
        separator = invocation.index("--")
        # Past the executable and `test run`, up to the separator `main` adds itself.
        return invocation[3:separator], invocation[separator + 1 :], dict(os.environ)


def flags(*argv, environ=None):
    return run_main(*argv, environ=environ)[0]


def paths(*argv, environ=None):
    return run_main(*argv, environ=environ)[1]


def child_environ(*argv, environ=None):
    return run_main(*argv, environ=environ)[2]


class TestParseArgs(unittest.TestCase):
    def test_a_plain_word_is_a_test(self):
        self.assertEqual(sorted_args("ql/test/Foo").tests, ["ql/test/Foo"])

    def test_a_dash_is_a_flag(self):
        self.assertEqual(
            sorted_args("--fail-on-trap-errors").flags, ["--fail-on-trap-errors"]
        )

    def test_an_uppercase_assignment_is_an_environment_variable(self):
        self.assertEqual(sorted_args("CPUS=4").env, {"CPUS": "4"})

    def test_a_lowercase_assignment_is_a_test(self):
        # Only shouting counts, so a path that happens to contain `=` stays a path.
        self.assertEqual(sorted_args("dir/a=b").tests, ["dir/a=b"])

    def test_codeql_selects_the_executable(self):
        # `built` is rejected outright without an internal checkout to build in, so
        # this says what it means to sort the option, not to act on it.
        args = sorted_args("--codeql=built", semmle_code="/somewhere")
        self.assertEqual(args.codeql, "built")

    def test_the_last_codeql_wins(self):
        args = sorted_args("--codeql=host", "--codeql=built", semmle_code="/somewhere")
        self.assertEqual(args.codeql, "built")

    def test_all_checks_is_asked_for_by_either_spelling(self):
        self.assertTrue(sorted_args("--all-checks").all)
        self.assertTrue(sorted_args("+").all)

    def test_an_extra_check_is_held_back_until_it_is_asked_for(self):
        held = sorted_args("--extra-check=--check-databases")
        self.assertEqual(held.extra_checks, ["--check-databases"])
        # Held back means held back: it is not a flag until `--all-checks` arrives.
        self.assertEqual(held.flags, [])
        self.assertFalse(held.all)

    def test_a_double_dash_hands_everything_after_it_to_codeql(self):
        # Standard `--`: past it, an option is the caller's business and not ours. The
        # separator itself is ours, though, so it is not passed on as well.
        args = sorted_args("--", "--codeql=built")
        self.assertEqual(args.codeql, "host")
        self.assertIn("--codeql=built", args.flags)
        self.assertNotIn("--", args.flags)

    def test_a_test_path_containing_a_space_stays_one_argument(self):
        self.assertEqual(sorted_args("some dir/test").tests, ["some dir/test"])

    def test_an_assignment_whose_value_contains_a_space_stays_whole(self):
        """The value is the point, and a split one used to arrive as three characters.

        An argument list carries this; a whitespace-separated string cannot, as there
        is nothing left in it to tell a separator from part of a value.
        """
        self.assertEqual(sorted_args("EXTRA=a b").env, {"EXTRA": "a b"})

    def test_sorts_a_whole_command_line_at_once(self):
        args = sorted_args(
            "-j2", "CPUS=4", "ql/test", "+", "--extra-check=--check-diff"
        )
        self.assertEqual(args.flags, ["-j2"])
        self.assertEqual(args.env, {"CPUS": "4"})
        self.assertEqual(args.tests, ["ql/test"])
        self.assertEqual(args.extra_checks, ["--check-diff"])
        self.assertTrue(args.all)


class TestOfferedChecks(unittest.TestCase):
    """What a root offers and what `--all-checks` enables are separate things.

    These go through `main` because that is where the two meet. `--all-checks` is
    injected on every language test run rather than typed, so it means "enable whatever
    this root offers" and not "I want more coverage": a root offering nothing has to
    stay runnable through it.
    """

    def test_an_offered_check_is_applied_when_asked_for(self):
        applied = flags("--extra-check=--check-databases", "--all-checks")
        self.assertIn("--check-databases", applied)

    def test_an_offered_check_stays_held_back_until_it_is(self):
        self.assertNotIn("--check-databases", flags("--extra-check=--check-databases"))

    def test_asking_for_checks_a_root_offers_none_of_enables_nothing(self):
        self.assertEqual(paths("--all-checks", "some/test"), ["some/test"])
        self.assertEqual(flags("--all-checks", "some/test"), flags("some/test"))

    def test_a_check_passed_unconditionally_is_not_an_offer(self):
        # A root can mean to run a check always rather than put it behind the flag. That
        # is a flag like any other here, so it neither becomes an offer nor is withheld
        # until the offers are asked for.
        always = flags("--check-databases", "some/test")
        self.assertIn("--check-databases", always)
        self.assertEqual(
            flags("--check-databases", "--all-checks", "some/test"), always
        )


class TestSettings(unittest.TestCase):
    """`RAM_PER_THREAD` and `CPUS` are read back after assignments are applied.

    Resolution is what these pin down, so they go through `main`: an assignment and an
    inherited variable only meet once `main` has merged them.
    """

    def test_prefers_a_test_argument(self):
        self.assertIn("-j4", flags("CPUS=4", environ={"CPUS": "8"}))

    def test_falls_back_to_the_environment(self):
        self.assertIn("-j8", flags(environ={"CPUS": "8"}))

    def test_falls_back_to_the_default(self):
        self.assertIn(f"-j{os.cpu_count()}", flags())

    def test_the_last_assignment_wins(self):
        self.assertIn("-j2", flags("CPUS=4", "CPUS=2"))

    def test_an_empty_value_falls_back_to_the_default(self):
        """An empty value does not override, so a later one erases an earlier setting.

        Compared against a run that never mentions the setting, so this pins the
        behaviour without restating what the default happens to be. It is about
        resolution only: see below for what the child is given.
        """
        self.assertEqual(flags("CPUS=4", "CPUS="), flags())

    def test_an_empty_assignment_still_reaches_the_child(self):
        """Falling back to the default is not the same as the assignment being dropped.

        `RAM_PER_THREAD` and `CPUS` are read back out of the environment, so an empty
        one reads as unset and the default stands. Every assignment is exported either
        way, so the child sees the variable set and empty rather than absent, and a
        variable this script does not read has no other behaviour to fall back to.
        """
        self.assertEqual(child_environ("CPUS=")["CPUS"], "")
        self.assertNotIn("CPUS", child_environ())

    def test_an_assignment_reaches_the_child(self):
        self.assertEqual(child_environ("EXTRA=a b")["EXTRA"], "a b")

    def test_ram_is_per_thread(self):
        self.assertIn("--ram=200", flags("CPUS=2", "RAM_PER_THREAD=100"))


class TestDefaults(unittest.TestCase):
    def test_the_current_directory_is_the_default_test(self):
        self.assertEqual(paths(), ["."])

    def test_a_named_test_replaces_the_default(self):
        self.assertEqual(paths("ql/test/Foo"), ["ql/test/Foo"])

    def test_an_offered_check_becomes_a_flag_once_asked_for(self):
        self.assertIn(
            "--check-databases", flags("--extra-check=--check-databases", "+")
        )


if __name__ == "__main__":
    unittest.main()
