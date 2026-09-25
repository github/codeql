#!/usr/bin/env python3
"""Tests for `run_on_files.py`.

Two of these guard properties that cost nothing to break and say nothing when broken.
An exclusion that stops excluding does not fail: it formats files it was told to leave
alone, with a tool the other repository did not choose, and the only way to notice is
to go looking. These are that noticing, done once and kept.

Each of those two carries a positive control, as the assertion they make is that a
collection is empty, and an empty collection is also what a mistyped pattern, a wrong
directory or a walk that never ran produce.
"""

import contextlib
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import run_on_files

HERE = Path(__file__).resolve().parent

# Print each argument on its own line, so that a test can tell one argument containing a
# space from two arguments.
ECHO_ARGUMENTS = "import sys\nfor a in sys.argv[1:]: print(a)"
ECHO_TO_STDERR = "import sys\nfor a in sys.argv[1:]: print(a, file=sys.stderr)"


def can_symlink():
    """Whether this process may create symbolic links, which Windows restricts."""
    with tempfile.TemporaryDirectory() as directory:
        try:
            os.symlink(directory, Path(directory) / "link")
            return True
        except (OSError, NotImplementedError):
            return False


CAN_SYMLINK = can_symlink()


@contextlib.contextmanager
def working_directory(directory):
    previous = os.getcwd()
    os.chdir(directory)
    try:
        yield
    finally:
        os.chdir(previous)


class TemporaryTree(unittest.TestCase):
    """A scratch tree of empty files, named by `files`."""

    files = ()

    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        # Resolved once here: macOS puts temporary directories behind a symbolic link,
        # and these tests compare against absolute paths.
        self.root = Path(temporary.name).resolve()
        for name in self.files:
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.touch()


class TestFilesUnder(TemporaryTree):
    files = (
        "outer/BUILD",
        "outer/BUILD.bazel",
        "outer/notes.md",
        "outer/nested/BUILD.bazel",
        "outer/nested/deep/BUILD.bazel",
    )

    def collect(self, paths, patterns, *args, **kwargs):
        files, _ = run_on_files.files_under(paths, patterns, *args, **kwargs)
        return files

    def test_matches_the_whole_name_rather_than_an_extension(self):
        # A bazel file may be called `BUILD`, with no extension to match on.
        with working_directory(self.root / "outer"):
            self.assertEqual(self.collect(["."], ["BUILD"]), ["BUILD"])

    def test_leaves_out_a_file_no_pattern_names(self):
        with working_directory(self.root):
            found = self.collect(["outer"], ["*.bazel"])
        self.assertNotIn(os.path.join("outer", "notes.md"), found)

    def test_walks_the_whole_tree_below_a_directory(self):
        with working_directory(self.root):
            found = self.collect(["outer"], ["*.bazel"])
        self.assertEqual(
            found,
            [
                os.path.join("outer", "BUILD.bazel"),
                os.path.join("outer", "nested", "BUILD.bazel"),
                os.path.join("outer", "nested", "deep", "BUILD.bazel"),
            ],
        )

    def test_takes_a_file_as_well_as_a_directory(self):
        with working_directory(self.root):
            path = os.path.join("outer", "BUILD.bazel")
            self.assertEqual(self.collect([path], ["*.bazel"]), [path])

    def test_leaves_out_a_file_named_directly_that_no_pattern_matches(self):
        with working_directory(self.root):
            self.assertEqual(self.collect([os.path.join("outer", "notes.md")], ["*.bazel"]), [])

    def test_excludes_are_matched_against_the_path_not_the_name(self):
        with working_directory(self.root):
            found = self.collect(["outer"], ["*.bazel"], ["*/nested/*"])
        self.assertEqual(found, [os.path.join("outer", "BUILD.bazel")])

    def test_absolute_exclusion_holds_for_a_path_walked_from_inside(self):
        """The walk only ever extends the path it was given.

        Walking `nested` from inside `outer` builds no path naming `outer`, so an
        exclusion spelled relative to the enclosing directory cannot match it. One
        anchored absolutely has to, which is what a repository relies on to stay out of
        a nested one that is being formatted from within.
        """
        with working_directory(self.root / "outer"):
            # Positive control: there is something here to exclude, so an empty result
            # below means the exclusion worked rather than that the walk found nothing.
            self.assertEqual(len(self.collect(["nested"], ["*.bazel"])), 2)
            self.assertEqual(
                self.collect(["nested"], ["*.bazel"], [f"{self.root / 'outer'}/*"]),
                [],
            )

    @unittest.skipUnless(CAN_SYMLINK, "symbolic links need a privilege on Windows")
    def test_absolute_exclusion_holds_for_a_path_reached_through_a_link(self):
        """An absolute path may still be spelled through a symbolic link.

        Joining it with the working directory leaves that spelling alone, so only
        resolving it makes an absolutely anchored exclusion hold here too.
        """
        link = self.root / "link"
        link.symlink_to(self.root / "outer", target_is_directory=True)
        reached_through_link = str(link / "nested")
        # Positive control, as above.
        self.assertEqual(len(self.collect([reached_through_link], ["*.bazel"])), 2)
        self.assertEqual(
            self.collect([reached_through_link], ["*.bazel"], [f"{self.root / 'outer'}/*"]),
            [],
        )

    def test_a_relative_exclusion_still_holds_for_a_relative_walk(self):
        # Trying both spellings must not cost a pattern the reach it was written with.
        with working_directory(self.root):
            self.assertEqual(self.collect(["outer"], ["*.bazel"], ["outer/*"]), [])

    def test_within_leaves_out_what_lies_beyond_it(self):
        with working_directory(self.root):
            self.assertEqual(
                self.collect(["outer"], ["*.bazel"], within=str(self.root / "outer" / "nested")),
                [
                    os.path.join("outer", "nested", "BUILD.bazel"),
                    os.path.join("outer", "nested", "deep", "BUILD.bazel"),
                ],
            )

    @unittest.skipUnless(CAN_SYMLINK, "symbolic links need a privilege on Windows")
    def test_does_not_walk_through_a_symbolic_link(self):
        # This is what keeps the `bazel-*` convenience links out of a walk, which would
        # otherwise reach the whole output tree.
        (self.root / "outer" / "bazel-out").symlink_to(
            self.root / "outer" / "nested", target_is_directory=True
        )
        with working_directory(self.root):
            found = self.collect(["outer"], ["*.bazel"])
        self.assertFalse([path for path in found if "bazel-out" in path])

    def test_absolute_asks_for_absolute_names(self):
        with working_directory(self.root):
            found = self.collect(["outer"], ["BUILD"], absolute=True)
        self.assertEqual(found, [str(self.root / "outer" / "BUILD")])

    def test_a_file_is_collected_once_however_many_paths_reach_it(self):
        with working_directory(self.root):
            found = self.collect(["outer", os.path.join("outer", "BUILD.bazel")], ["*.bazel"])
        self.assertEqual(len(found), len(set(found)))


class TestContributingPaths(TemporaryTree):
    """The second half of what a walk learns, and the reason the banner is honest.

    A path that was asked about is not the same as a path being acted on. Naming the
    first is what made a run over a repository and a nested one report the nested path
    twice, once from an invocation that had excluded every file in it.
    """

    files = (
        "outer/BUILD.bazel",
        "outer/nested/BUILD.bazel",
        "outer/barren/notes.md",
    )

    def contributing(self, paths, patterns, *args, **kwargs):
        _, contributing = run_on_files.files_under(paths, patterns, *args, **kwargs)
        return contributing

    def test_names_only_a_path_that_yielded_a_file(self):
        with working_directory(self.root):
            self.assertEqual(
                self.contributing(
                    [os.path.join("outer", "nested"), os.path.join("outer", "barren")],
                    ["*.bazel"],
                ),
                [os.path.join("outer", "nested")],
            )

    def test_leaves_out_a_path_whose_files_were_all_excluded(self):
        with working_directory(self.root):
            self.assertEqual(
                self.contributing(
                    ["outer"],
                    ["*.bazel"],
                    [f"{self.root / 'outer'}/*"],
                ),
                [],
            )

    def test_keeps_the_spelling_the_path_was_given_in(self):
        # It goes back to whoever wrote it, so it has to be recognisable as theirs.
        with working_directory(self.root):
            self.assertEqual(self.contributing(["./outer"], ["*.bazel"]), ["./outer"])

    def test_names_both_paths_that_reach_the_same_file(self):
        # The file is collected once, but each path did have something in it.
        with working_directory(self.root):
            paths = ["outer", os.path.join("outer", "nested")]
            files, contributing = run_on_files.files_under(paths, ["*.bazel"])
        self.assertEqual(contributing, paths)
        self.assertEqual(len(files), 2)


class TestBanner(unittest.TestCase):
    def test_names_the_command_and_the_paths_it_has_something_to_do_in(self):
        # The bare form has to be asked for rather than assumed: `just` exports these
        # two, so run through the `test` recipe the ambient environment is not empty,
        # and a test that reads it would pass or fail by how it was started.
        with mock.patch.dict(os.environ):
            os.environ.pop("CMD_BEGIN", None)
            os.environ.pop("CMD_END", None)
            self.assertEqual(
                run_on_files.banner(["clang-format", "-i"], ["cpp", "swift"]),
                "-> clang-format -i -- cpp swift",
            )

    def test_is_wrapped_in_the_rules_the_justfiles_set(self):
        with mock.patch.dict(
            os.environ, {"CMD_BEGIN": "<begin>", "CMD_END": "<end>"}
        ):
            self.assertEqual(
                run_on_files.banner(["black"], ["."]), "<begin>-> black -- .<end>"
            )


class TestBatched(unittest.TestCase):
    def test_keeps_everything_in_one_batch_when_it_fits(self):
        self.assertEqual(list(run_on_files.batched(["a", "b"], 100)), [["a", "b"]])

    def test_splits_once_the_limit_is_reached(self):
        batches = list(run_on_files.batched(["aaa", "bbb", "ccc"], 8))
        self.assertEqual(batches, [["aaa", "bbb"], ["ccc"]])

    def test_loses_no_file_and_keeps_their_order(self):
        files = [f"file{n}" for n in range(50)]
        batched = [file for batch in run_on_files.batched(files, 20) for file in batch]
        self.assertEqual(batched, files)

    def test_yields_nothing_for_no_files(self):
        self.assertEqual(list(run_on_files.batched([], 100)), [])

    def test_still_yields_a_file_longer_than_the_limit(self):
        # Dropping it would be silent, and the command is a better place for the
        # complaint than a batch that never happens.
        long = "x" * 200
        self.assertEqual(list(run_on_files.batched([long], 10)), [[long]])


class TestBatchLimit(unittest.TestCase):
    def test_leaves_room_for_the_environment_and_a_single_argument(self):
        limit = run_on_files.batch_limit()
        self.assertGreaterEqual(limit, 4096)
        # A single argument is capped far lower than the whole command line, and a
        # command handing its arguments on through a shell arrives as one of them.
        self.assertLessEqual(limit, 100000)


class TestCommaSeparated(unittest.TestCase):
    def test_splits_a_group_given_as_one_argument(self):
        self.assertEqual(run_on_files.comma_separated("a,b,c"), ["a", "b", "c"])

    def test_leaves_a_single_pattern_alone(self):
        self.assertEqual(run_on_files.comma_separated("a"), ["a"])


class TestCommandLine(TemporaryTree):
    files = (
        "project/BUILD.bazel",
        "project/with space/BUILD.bazel",
        "project/notes.md",
        "elsewhere/BUILD.bazel",
    )

    def run_script(self, *arguments, cwd=None):
        return subprocess.run(
            [sys.executable, str(HERE / "run_on_files.py"), *arguments],
            cwd=cwd or self.root,
            capture_output=True,
            text=True,
        )

    def echo(self, script=ECHO_ARGUMENTS):
        return [sys.executable, "-c", script]

    def test_passes_a_name_containing_a_space_as_one_argument(self):
        """The reason this program exists rather than a shell command substitution."""
        result = self.run_script("*.bazel", *self.echo(), "--", "project")
        self.assertEqual(result.returncode, 0, result.stderr)
        printed = result.stdout.splitlines()
        self.assertIn(os.path.join("project", "with space", "BUILD.bazel"), printed)

    def test_announces_the_command_once_a_file_has_matched(self):
        result = self.run_script("*.bazel", *self.echo(), "--", "project")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("-> ", result.stderr)
        self.assertIn(" -- project", result.stderr)

    def test_the_banner_leaves_out_a_path_that_contributed_nothing(self):
        """What a repository formatting its own files over a nested one used to say.

        Both paths were named while one of them had every file excluded, so the run
        read as covering ground it had already declined to touch.
        """
        result = self.run_script(
            "--exclude",
            f"{self.root / 'project'}/*",
            "*.bazel",
            *self.echo(),
            "--",
            "elsewhere",
            "project",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(" -- elsewhere", result.stderr)
        self.assertNotIn("project", result.stderr)

    def test_says_nothing_at_all_when_no_file_matches(self):
        """Silence has to mean that nothing matched, not that nothing was looked at.

        The banner is the whole point: announced before the collection, it would claim
        a formatter ran over a directory it never opened.
        """
        result = self.run_script("*.nomatch", *self.echo(), "--", "project")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_refuses_a_path_that_does_not_exist(self):
        # Naming a path is an assertion that it is there, so this is not the silent case
        # above: an unexpanded glob would otherwise look exactly like nothing to do.
        result = self.run_script("*.bazel", *self.echo(), "--", "absent")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("no such path: absent", result.stderr)

    def test_needs_the_paths_separated_from_the_command(self):
        result = self.run_script("*.bazel", *self.echo(), "project")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("--", result.stderr)

    def test_needs_a_command(self):
        # Two separators: argparse takes the first for its own end-of-options marker
        # when nothing precedes it, so one alone leaves no separator to find and is
        # reported as the missing one above.
        result = self.run_script("*.bazel", "--", "--", "project")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("no command given", result.stderr)

    def test_separates_on_the_last_dash_dash_so_a_command_may_contain_one(self):
        result = self.run_script("*.bazel", *self.echo(), "--", "--", "project")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--", result.stdout.splitlines())

    def test_drops_the_lines_it_was_told_to_drop(self):
        result = self.run_script(
            "--drop",
            "notes",
            "*.bazel,*.md",
            *self.echo(ECHO_TO_STDERR),
            "--",
            "project",
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("notes.md", result.stderr)
        self.assertIn("BUILD.bazel", result.stderr)

    def test_reports_the_command_failing(self):
        failing = [sys.executable, "-c", "import sys; sys.exit(3)"]
        result = self.run_script("*.bazel", *failing, "--", "project")
        self.assertEqual(result.returncode, 3)


if __name__ == "__main__":
    unittest.main()
