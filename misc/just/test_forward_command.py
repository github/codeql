#!/usr/bin/env python3
"""Tests for `forward_command.py`.

These cover the deciding rather than the running: which justfile answers a verb, with
how many arguments, and which ones ask to be passed over. All of that is read out of
`just --dump`, so the shapes below were taken from what `just` really emits rather than
imagined. That is checked rather than claimed: the last class here dumps a real justfile
and holds the fixtures against it, because a hand-written shape is otherwise only as
good as the day it was written, and agrees with itself long after `just` has moved on.
"""

import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import forward_command


def parameter(name, kind="singular", default=None):
    return {"name": name, "kind": kind, "default": default}


def recipe(name, parameters=(), dependencies=(), private=False, doc=None):
    return {
        "name": name,
        "private": private,
        "doc": doc,
        "parameters": list(parameters),
        "dependencies": [{"recipe": dependency} for dependency in dependencies],
    }


def alias(name, target):
    return {"attributes": [], "name": name, "target": target}


def dump(*recipes, aliases=None, assignments=None):
    return {
        "recipes": {recipe["name"]: recipe for recipe in recipes},
        "aliases": aliases or {},
        "assignments": assignments or {},
    }


def forwarding(command):
    """The pair a justfile has when it both forwards a verb and answers it itself."""
    return dump(
        recipe(
            command,
            [parameter("ARGS", kind="star")],
            dependencies=[forward_command.FORWARD_RECIPE],
        ),
        recipe(f"{forward_command.ROOT_PREFIX}{command}", [parameter("ARGS", "star")]),
    )


class TestAccepts(unittest.TestCase):
    def accepts(self, parameters, argc):
        return forward_command.accepts(recipe("r", parameters), argc)

    def test_a_recipe_without_parameters_takes_none(self):
        self.assertTrue(self.accepts([], 0))
        self.assertFalse(self.accepts([], 1))

    def test_a_parameter_without_a_default_must_be_given(self):
        self.assertFalse(self.accepts([parameter("X")], 0))
        self.assertTrue(self.accepts([parameter("X")], 1))
        self.assertFalse(self.accepts([parameter("X")], 2))

    def test_a_defaulted_parameter_may_be_left_out(self):
        defaulted = [parameter("X", default=".")]
        self.assertTrue(self.accepts(defaulted, 0))
        self.assertTrue(self.accepts(defaulted, 1))
        self.assertFalse(self.accepts(defaulted, 2))

    def test_a_star_parameter_takes_any_number(self):
        star = [parameter("ARGS", kind="star")]
        for argc in (0, 1, 7):
            self.assertTrue(self.accepts(star, argc), argc)

    def test_a_plus_parameter_takes_at_least_one(self):
        plus = [parameter("ARGS", kind="plus")]
        self.assertFalse(self.accepts(plus, 0))
        self.assertTrue(self.accepts(plus, 1))
        self.assertTrue(self.accepts(plus, 7))


class TestImplements(unittest.TestCase):
    def test_finds_the_recipe_named_after_the_command(self):
        found = forward_command.implements(dump(recipe("test")), "test", 0)
        self.assertEqual(found["name"], "test")

    def test_follows_an_alias(self):
        found = forward_command.implements(
            dump(recipe("test"), aliases={"t": alias("t", "test")}), "t", 0
        )
        self.assertEqual(found["name"], "test")

    def test_follows_an_alias_into_a_forwarding_justfile(self):
        # The recipe named after the alias forwards, so the answer is the root one --
        # and that is named after the verb, which is the target rather than the alias.
        # Reaching here needs the alias to be a verb's own name, the only spelling the
        # forwarder ever passes.
        found = forward_command.implements(
            dump(
                recipe("build", dependencies=[forward_command.FORWARD_RECIPE]),
                recipe(f"{forward_command.ROOT_PREFIX}build"),
                aliases={"format": alias("format", "build")},
            ),
            "format",
            0,
        )
        self.assertEqual(found["name"], f"{forward_command.ROOT_PREFIX}build")

    def test_does_not_settle_on_a_root_recipe_named_after_the_alias(self):
        # `_root_format` exists in most repository roots, so looking the alias up
        # unresolved finds a real recipe rather than nothing: the wrong directory's
        # answer, run in earnest. The version of this without one returns None, which
        # is indistinguishable from a justfile that does not implement the verb at all.
        found = forward_command.implements(
            dump(
                recipe("build", dependencies=[forward_command.FORWARD_RECIPE]),
                recipe(f"{forward_command.ROOT_PREFIX}build"),
                recipe(f"{forward_command.ROOT_PREFIX}format"),
                aliases={"format": alias("format", "build")},
            ),
            "format",
            0,
        )
        self.assertEqual(found["name"], f"{forward_command.ROOT_PREFIX}build")

    def test_passes_over_a_private_recipe(self):
        self.assertIsNone(
            forward_command.implements(dump(recipe("test", private=True)), "test", 0)
        )

    def test_passes_over_a_recipe_that_cannot_take_the_arguments(self):
        self.assertIsNone(forward_command.implements(dump(recipe("test")), "test", 1))

    def test_takes_the_root_recipe_when_the_plain_name_forwards(self):
        """A forwarder's own name says nothing about what its directory does.

        Settling on it would make the search find itself, so the one name the two can
        share is `_root_<command>`.
        """
        found = forward_command.implements(forwarding("format"), "format", 1)
        self.assertEqual(found["name"], "_root_format")

    def test_finds_nothing_when_a_forwarder_has_no_recipe_of_its_own(self):
        forwarder = dump(
            recipe(
                "format",
                [parameter("ARGS", kind="star")],
                dependencies=[forward_command.FORWARD_RECIPE],
            )
        )
        self.assertIsNone(forward_command.implements(forwarder, "format", 1))


class TestListValue(unittest.TestCase):
    def read(self, value):
        return forward_command.list_value({"explicit_verbs": {"value": value}}, "explicit_verbs")

    def test_reads_a_list_literal(self):
        self.assertEqual(self.read(["list", "test", "build"]), ["test", "build"])

    def test_reads_an_empty_list_literal(self):
        self.assertEqual(self.read(["list"]), [])

    def test_counts_an_expression_as_absent(self):
        # What `['a'] ++ ['b']` dumps as. Evaluating it would mean running just.
        concatenation = ["list-concatenate", ["list", "a"], ["list", "b"]]
        self.assertEqual(self.read(concatenation), [])

    def test_counts_a_plain_string_as_absent(self):
        self.assertEqual(self.read("test"), [])

    def test_counts_an_unset_name_as_absent(self):
        self.assertEqual(forward_command.list_value({}, "explicit_verbs"), [])


class TestOptsOut(unittest.TestCase):
    def test_a_listed_verb_asks_to_be_named(self):
        listed = dump(assignments={"explicit_verbs": {"value": ["list", "test"]}})
        self.assertTrue(forward_command.opts_out(listed, "test"))
        self.assertFalse(forward_command.opts_out(listed, "build"))

    def test_listing_nothing_opts_out_of_nothing(self):
        self.assertFalse(forward_command.opts_out(dump(), "test"))


class TestGetJustContext(unittest.TestCase):
    def test_a_justfile_sitting_on_the_argument_is_run_from_there(self):
        # `just build ql/rust` becomes `just build` inside `ql/rust`, as repeating the
        # directory it is already in says nothing.
        cwd, args = forward_command.get_just_context(
            Path("ql/rust/justfile"), "build", [], ["ql/rust"]
        )
        self.assertEqual(cwd, "ql/rust")
        self.assertEqual(args, ["build"])

    def test_flags_survive_being_run_from_there(self):
        cwd, args = forward_command.get_just_context(
            Path("ql/rust/justfile"), "test", ["--all-checks"], ["ql/rust"]
        )
        self.assertEqual(cwd, "ql/rust")
        self.assertEqual(args, ["test", "--all-checks"])

    def test_anything_else_names_the_justfile_and_keeps_the_arguments(self):
        cwd, args = forward_command.get_just_context(
            Path("ql/justfile"), "build", ["-x"], ["ql/rust"]
        )
        self.assertIsNone(cwd)
        self.assertEqual(
            args, ["--justfile", str(Path("ql/justfile")), "build", "-x", "ql/rust"]
        )

    def test_two_arguments_are_both_kept(self):
        cwd, args = forward_command.get_just_context(
            Path("ql/justfile"), "format", [], ["ql/rust", "ql/cpp"]
        )
        self.assertIsNone(cwd)
        self.assertEqual(args[-2:], ["ql/rust", "ql/cpp"])


class TestInvocationPath(unittest.TestCase):
    def test_spells_a_path_relatively_when_the_argument_was(self):
        found = Path.cwd() / "sub" / "justfile"
        self.assertEqual(
            forward_command.invocation_path(found, like="sub"), Path("sub/justfile")
        )

    def test_leaves_a_path_absolute_when_the_argument_was(self):
        found = Path.cwd() / "sub" / "justfile"
        self.assertEqual(
            forward_command.invocation_path(found, like=str(Path.cwd())), found
        )


class TestFindJustfilesAbove(unittest.TestCase):
    """The two shapes a consuming root can have, both of which the README promises.

    A root that imports the justfile defining a `_root_<verb>` inherits it, and the verb
    is then reached twice under two spellings of one recipe, which has to run once. A
    root that defines its own replaces it, and both have to run, each over the files of
    the repository defining it. No dump says which of the two happened, so they are told
    apart by comparing the recipes themselves, and the fields that carry the difference
    are whatever the two repositories happened not to write identically.

    That makes a verbatim copy of one root recipe into another indistinguishable from
    inheritance, comment included, and a comment is the part of a recipe most likely to
    survive the paste that produces this.
    """

    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        root = Path(directory.name).resolve()
        self.outer = root / "justfile"
        self.inner = root / "inner" / "justfile"
        self.argument = root / "inner" / "below"
        self.argument.mkdir(parents=True)
        for justfile in (self.outer, self.inner):
            justfile.write_text("")

    def implementing(self, doc=None, dependencies=()):
        """A justfile that forwards `format` and answers it itself."""
        return dump(
            recipe(
                "format",
                [parameter("ARGS", "star")],
                dependencies=[forward_command.FORWARD_RECIPE],
            ),
            recipe(
                f"{forward_command.ROOT_PREFIX}format",
                [parameter("ARGS", "star")],
                dependencies=dependencies,
                doc=doc,
            ),
        )

    def found(self, outer, inner):
        dumps = {self.outer: outer, self.inner: inner}
        with mock.patch.object(
            forward_command,
            "dump_justfile",
            side_effect=lambda justfile: (dumps[Path(justfile)], None),
        ):
            found, failed = forward_command.find_justfiles_above(
                "format", str(self.argument)
            )
        self.assertFalse(failed)
        return found

    def test_a_recipe_reached_under_two_spellings_runs_once(self):
        found = self.found(self.implementing(), self.implementing())
        self.assertEqual([justfile for justfile, _ in found], [self.inner])

    def test_two_roots_differing_only_in_their_comment_both_run(self):
        found = self.found(self.implementing(), self.implementing(doc="From here."))
        self.assertEqual([justfile for justfile, _ in found], [self.inner, self.outer])

    def test_two_roots_sharing_a_comment_still_both_run_if_they_do_different_work(self):
        found = self.found(
            self.implementing(doc="From here.", dependencies=["_format_other"]),
            self.implementing(doc="From here."),
        )
        self.assertEqual([justfile for justfile, _ in found], [self.inner, self.outer])


class TestDiscoveryFailures(unittest.TestCase):
    def test_dump_all_reports_every_failure(self):
        justfiles = [Path("one/justfile"), Path("two/justfile"), Path("three/justfile")]
        dumps = [(None, "bad one"), (dump(), None), (None, "bad three")]
        with mock.patch.object(
            forward_command, "dump_justfile", side_effect=dumps
        ), mock.patch.object(forward_command, "error") as report:
            parsed, failed = forward_command.dump_all(justfiles)
        self.assertTrue(failed)
        self.assertEqual(parsed, [(Path("two/justfile"), dump())])
        self.assertEqual(report.call_count, 2)

    def test_git_failure_is_reported_to_callers(self):
        result = subprocess.CompletedProcess(
            ["git"], 128, stdout="", stderr="fatal: not a repository"
        )
        with mock.patch.object(
            subprocess, "run", return_value=result
        ), mock.patch.object(forward_command, "error"):
            lines, failed = forward_command.git(".", "ls-files")
        self.assertEqual(lines, [])
        self.assertTrue(failed)

    def test_forward_fails_without_running_after_resolution_failure(self):
        justfile = Path("pkg/justfile")
        resolved = [(justfile, "pkg", recipe("test", [parameter("ARGS", "star")]))]
        with mock.patch.object(
            forward_command, "resolve", return_value=(resolved, [], True)
        ), mock.patch.object(forward_command, "invoke_just") as invoke:
            self.assertEqual(forward_command.forward("test", ["pkg"]), 1)
        invoke.assert_not_called()


class TestForwardInvocations(unittest.TestCase):
    def test_accumulates_variadic_recipe_arguments(self):
        justfile = Path("pkg/justfile")
        test_recipe = recipe("test", [parameter("ARGS", "star")])

        def resolve(command, arg):
            return [(justfile, arg, test_recipe)], [], False

        with mock.patch.object(
            forward_command, "resolve", side_effect=resolve
        ), mock.patch.object(forward_command, "invoke_just", return_value=0) as invoke:
            self.assertEqual(forward_command.forward("test", ["pkg/a", "pkg/b"]), 0)

        invoke.assert_called_once_with(
            None, ["--justfile", "pkg/justfile", "test", "pkg/a", "pkg/b"]
        )

    def test_splits_non_variadic_recipe_arguments(self):
        justfile = Path("pkg/justfile")
        test_recipe = recipe("test", [parameter("ARG")])

        def resolve(command, arg):
            return [(justfile, arg, test_recipe)], [], False

        with mock.patch.object(
            forward_command, "resolve", side_effect=resolve
        ), mock.patch.object(forward_command, "invoke_just", return_value=0) as invoke:
            self.assertEqual(forward_command.forward("test", ["pkg/a", "pkg/b"]), 0)

        self.assertEqual(
            invoke.call_args_list,
            [
                mock.call(None, ["--justfile", "pkg/justfile", "test", "pkg/a"]),
                mock.call(None, ["--justfile", "pkg/justfile", "test", "pkg/b"]),
            ],
        )


# Resolve the same binary `forward_command` will run: it honours JUST_EXECUTABLE, so a
# pinned `just` would otherwise have these fixtures checked against a different binary
# than the code uses. `which` covers both spellings, returning an explicit path as given
# and looking a bare name up on PATH.
JUST = shutil.which(forward_command.JUST)

# The justfile below uses every construct the fixtures above model, so that a dump of it
# can be checked against them.
CONSTRUCTS = """
set unstable
set lists

alias t := test

explicit_verbs := ['test']

test *ARGS='.': _helper
    echo {{ ARGS }}

# A comment above a recipe becomes its doc.
build X Y='y':
    echo {{ X }} {{ Y }}

lint +ARGS:
    echo {{ ARGS }}

[private]
_helper:
    echo helper
"""


@unittest.skipUnless(JUST, "needs `just` on PATH")
class TestFixturesStillMatchJust(unittest.TestCase):
    """Check the fixtures above against what `just` really dumps.

    Everything else here reads a shape written by hand, which is only as good as the
    day it was written: `just` changed how it dumps an alias once already, and the test
    covering aliases went on passing against the shape that had gone away. A fixture
    cannot notice that on its own, so this asks the real thing.

    Only the fields the code reads are compared. `just` is free to dump more, and a
    test that failed whenever it did would be noise rather than a warning.
    """

    @classmethod
    def setUpClass(cls):
        with tempfile.TemporaryDirectory() as directory:
            justfile = Path(directory) / "justfile"
            justfile.write_text(CONSTRUCTS)
            dumped = subprocess.run(
                [JUST, "--justfile", str(justfile), "--dump", "--dump-format", "json"],
                capture_output=True,
                text=True,
                check=True,
            )
        cls.dump = json.loads(dumped.stdout)

    def test_a_dump_is_read_by_the_keys_the_fixtures_use(self):
        self.assertLessEqual(set(dump()), set(self.dump))

    def test_an_alias_names_its_target(self):
        real = self.dump["aliases"]["t"]
        self.assertEqual(set(alias("t", "test")), set(real))
        self.assertEqual(real["target"], "test")

    def test_a_recipe_is_read_by_the_keys_the_fixtures_use(self):
        self.assertLessEqual(set(recipe("test")), set(self.dump["recipes"]["test"]))

    def test_a_comment_above_a_recipe_is_the_doc_the_comparison_reads(self):
        # Two root recipes doing different jobs are often told apart by this alone.
        recipes = self.dump["recipes"]
        self.assertEqual(
            recipes["build"]["doc"], "A comment above a recipe becomes its doc."
        )
        self.assertIsNone(recipes["test"]["doc"])

    def test_a_private_recipe_says_so(self):
        self.assertIs(self.dump["recipes"]["_helper"]["private"], True)
        self.assertIs(self.dump["recipes"]["test"]["private"], False)

    def test_a_dependency_names_its_recipe(self):
        dependencies = self.dump["recipes"]["test"]["dependencies"]
        self.assertEqual([d["recipe"] for d in dependencies], ["_helper"])

    def test_parameters_keep_the_kinds_and_defaults_accepts_reads(self):
        kinds = {
            name: [(p["kind"], p["default"]) for p in recipe["parameters"]]
            for name, recipe in self.dump["recipes"].items()
        }
        self.assertEqual(kinds["test"], [("star", ".")])
        self.assertEqual(kinds["build"], [("singular", None), ("singular", "y")])
        self.assertEqual(kinds["lint"], [("plus", None)])
        self.assertEqual(kinds["_helper"], [])

    def test_a_list_assignment_is_the_shape_list_value_unwraps(self):
        self.assertEqual(
            forward_command.list_value(self.dump["assignments"], "explicit_verbs"),
            ["test"],
        )


@unittest.skipUnless(JUST, "needs `just` on PATH")
class TestImportingDoesNotChangeARecipe(unittest.TestCase):
    """Ask `just` for the premise the deduplication rests on rather than assuming it.

    A root importing the justfile that defines a `_root_<verb>` reaches one recipe under
    two spellings, and it is told apart from two repositories each defining their own by
    comparing the recipes whole. That comparison reads every field `just` emits, not the
    few the rest of this file models, so a release adding a per-recipe field that varies
    between justfiles -- a source path, a line number, anything saying where a recipe was
    written -- would stop the two spellings comparing equal and run an inherited recipe
    twice.

    Such a field is precisely the discriminator this code would otherwise want, so it
    would arrive looking like a feature. `namepath`, the closest thing to one today, is
    a module path rather than a file one, and so reads identically for two top-level
    recipes. The fixtures above cannot see any of this: they are compared as subsets,
    which is right for reading a field by name and blind to a field nobody thought to
    model. Nor would a repository notice, since defining a recipe of one's own only
    moves it further from the imported one: the shape that would start running twice is
    the one built here and kept nowhere else.
    """

    def recipes(self, justfile):
        dumped = subprocess.run(
            [JUST, "--justfile", str(justfile), "--dump", "--dump-format", "json"],
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(dumped.stdout)["recipes"]

    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        root = Path(directory.name)
        (root / "inner").mkdir()
        self.inner = root / "inner" / "justfile"
        self.inner.write_text("# Shared.\n_root_format:\n    echo shared\n")
        self.outer = root / "justfile"

    def test_an_imported_recipe_is_the_one_it_came_from(self):
        self.outer.write_text("import 'inner/justfile'\n")
        self.assertEqual(
            self.recipes(self.outer)["_root_format"],
            self.recipes(self.inner)["_root_format"],
        )

    def test_a_root_defining_its_own_is_not(self):
        # Same body, so only the comment separates them: the narrowest the difference
        # between the two shapes ever gets.
        self.outer.write_text(
            "set allow-duplicate-recipes\n"
            "import 'inner/justfile'\n"
            "\n"
            "# Mine.\n"
            "_root_format:\n"
            "    echo shared\n"
        )
        self.assertNotEqual(
            self.recipes(self.outer)["_root_format"],
            self.recipes(self.inner)["_root_format"],
        )


if __name__ == "__main__":
    unittest.main()
