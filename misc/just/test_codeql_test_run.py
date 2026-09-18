#!/usr/bin/env python3
"""Tests for `codeql_test_run.py`.

Sorting arguments is the whole of what this file decides, and it decides it by looking
at each one: a word is a test, a `-` is a flag, `NAME=value` is an environment
assignment. Several of these pin down that an argument arrives whole, spaces and all,
which is what taking them as a list rather than re-splitting a string bought.
"""

import os
import unittest
from unittest import mock

import codeql_test_run


def empty_args():
    """What `main` builds before sorting, limited to what `parse_args` fills in."""
    return {
        "tests": [],
        "flags": [],
        "env": [],
        "all_checks": [],
        "codeql": "host",
        "all": False,
    }


def sorted_args(*argv):
    args = empty_args()
    codeql_test_run.parse_args(args, list(argv))
    return args


class TestParseArgs(unittest.TestCase):
    def test_a_plain_word_is_a_test(self):
        self.assertEqual(sorted_args("ql/test/Foo")["tests"], ["ql/test/Foo"])

    def test_a_dash_is_a_flag(self):
        self.assertEqual(sorted_args("--fail-on-trap-errors")["flags"], ["--fail-on-trap-errors"])

    def test_an_uppercase_assignment_is_an_environment_variable(self):
        self.assertEqual(sorted_args("CPUS=4")["env"], ["CPUS=4"])

    def test_a_lowercase_assignment_is_a_test(self):
        # Only shouting counts, so a path that happens to contain `=` stays a path.
        self.assertEqual(sorted_args("dir/a=b")["tests"], ["dir/a=b"])

    def test_codeql_selects_the_executable(self):
        self.assertEqual(sorted_args("--codeql=built")["codeql"], "built")

    def test_the_last_codeql_wins(self):
        self.assertEqual(sorted_args("--codeql=host", "--codeql=built")["codeql"], "built")

    def test_all_checks_is_asked_for_by_either_spelling(self):
        self.assertTrue(sorted_args("--all-checks")["all"])
        self.assertTrue(sorted_args("+")["all"])

    def test_an_extra_check_is_held_back_until_it_is_asked_for(self):
        held = sorted_args("--all-checks=--check-databases")
        self.assertEqual(held["all_checks"], ["--check-databases"])
        # Held back means held back: it is not a flag until `--all-checks` arrives.
        self.assertEqual(held["flags"], [])
        self.assertFalse(held["all"])

    def test_an_empty_argument_is_ignored(self):
        # One of these comes of a caller interpolating a variable that was never set.
        self.assertEqual(sorted_args("", "test")["tests"], ["test"])

    def test_a_test_path_containing_a_space_stays_one_argument(self):
        self.assertEqual(sorted_args("some dir/test")["tests"], ["some dir/test"])

    def test_an_assignment_whose_value_contains_a_space_stays_whole(self):
        """The value is the point, and a split one used to arrive as three characters.

        An argument list carries this; a whitespace-separated string cannot, as there
        is nothing left in it to tell a separator from part of a value.
        """
        self.assertEqual(sorted_args("EXTRA=a b")["env"], ["EXTRA=a b"])

    def test_sorts_a_whole_command_line_at_once(self):
        args = sorted_args("-j2", "CPUS=4", "ql/test", "+", "--all-checks=--check-diff")
        self.assertEqual(args["flags"], ["-j2"])
        self.assertEqual(args["env"], ["CPUS=4"])
        self.assertEqual(args["tests"], ["ql/test"])
        self.assertEqual(args["all_checks"], ["--check-diff"])
        self.assertTrue(args["all"])


class TestEnvValue(unittest.TestCase):
    def test_prefers_a_test_argument(self):
        args = sorted_args("CPUS=4")
        with mock.patch.dict(os.environ, {"CPUS": "8"}):
            self.assertEqual(codeql_test_run.env_value(args, "CPUS", "1"), "4")

    def test_falls_back_to_the_environment(self):
        with mock.patch.dict(os.environ, {"CPUS": "8"}):
            self.assertEqual(codeql_test_run.env_value(empty_args(), "CPUS", "1"), "8")

    def test_falls_back_to_the_default(self):
        with mock.patch.dict(os.environ, {}, clear=True):
            self.assertEqual(codeql_test_run.env_value(empty_args(), "CPUS", "1"), "1")

    def test_the_last_assignment_wins(self):
        args = sorted_args("CPUS=4", "CPUS=2")
        self.assertEqual(codeql_test_run.env_value(args, "CPUS", "1"), "2")

    def test_an_empty_value_does_not_count_as_a_setting(self):
        args = sorted_args("CPUS=")
        with mock.patch.dict(os.environ, {"CPUS": "8"}):
            self.assertEqual(codeql_test_run.env_value(args, "CPUS", "1"), "8")

    def test_a_value_containing_a_space_survives(self):
        args = sorted_args("EXTRA=a b")
        self.assertEqual(codeql_test_run.env_value(args, "EXTRA", "none"), "a b")


if __name__ == "__main__":
    unittest.main()
