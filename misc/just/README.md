This directory contains an infrastructure for [`just`](https://github.com/casey/just)
recipes that can be used throughout this and the internal repository. In particular we
have common verbs (`build`, `test`, `format`, `lint`, `generate`) that individual parts
of the project can implement, and some common functionality that can be used to that
effect.

# Forwarding

The core of the functionality is given by forwarding. The idea is that:

- if you are in the directory where a verb is implemented, you will get that as per
  standard `just` behaviour (possibly using fallback).
- if on the other hand you are above it, and you run something like
  `just test ql/rust/ql/test/{a,b}`, then a forwarder script finds a common justfile
  implementing the verb for all the positional arguments passed there, and then retries
  calling `just test` from there. So if `test` is implemented beneath that (in that case,
  it is in `rust/ql/test`), it uses that recipe.
- even if there isn't a recipe that is common to all the positional arguments, the
  forwarder will still group the arguments in batches using the same recipe. So
  `just build ql/rust ql/java`, or
  `just test ql/rust/ql/test/some/language/test ql/rust/ql/integration-test/some/integration/test`
  will also work, with corresponding recipes run sequentially.
- finally, the forwarder also looks _below_ each argument, so that `just test ql/cpp`
  runs the tests defined underneath it. The argument only says where to look in this
  case, so each recipe found is run on its own directory rather than being passed the
  argument. Several may be found, in which case they run sequentially:
  `just format ql/cpp` formats everything under `ql/cpp` that knows how to format
  itself.

Both directions are searched, and every distinct recipe found runs. This matters because
a verb higher up is usually doing a different job from one further down rather than a
broader version of it: `rust` formats Rust sources while `rust/ql` formats QL, so
`just format rust` has to do both. A recipe that only arrived through `import` is the
same job, though, and runs once.

A repository root forwards every verb, which leaves it no way to answer one itself: a
recipe written next to the `import` overrides the imported one and takes the forwarder's
place, so `just format cpp` would stop finding anything. The root spells its own
implementation `_root_<verb>` instead, and the forwarder picks that up wherever the
plain name turns out to be the forwarder's own:

```just
import 'misc/just/forward.just'

_root_format *ARGS=".": (_format_bazel ARGS)
```

This is for work that belongs to no single directory. bazel files are the case in hand:
they sit throughout the tree rather than under any one language, so formatting them is
the root's job, and taking the argument keeps `just format cpp` to the bazel files under
`cpp`.

Note that this one delegates rather than doing the work itself. The forwarder reaches a
recipe above its argument with `--justfile`, which runs it from the directory of the
justfile defining it unless the recipe is `[no-cd]`. A `_root_<verb>` that grows a body
therefore reads its default `.` as the whole repository rather than the directory the
caller is in, so one that does its own work needs `[no-cd]` itself.

Being a recipe like any other, a `_root_<verb>` is inherited by a justfile importing the
one defining it. It runs once either way, as the two spellings are the same recipe. A
root that defines its own instead replaces it, and then both run, each over the files of
the repository that defines it: bazel formatting asks bazel from the root of the checkout
the files belong to, so that a repository formats its own files with its own pin.

Nothing in a justfile says which of the two happened, so they are told apart by comparing
the recipes. A root whose own copy is identical to the one it would otherwise inherit,
down to the comment above it, is therefore taken for the inherited one and runs once.
Copy such a recipe to start from if it helps, but leave its comment behind.

That last part is arranged by variables rather than by recipes. `set
allow-duplicate-variables` in `defs.just` lets an importing justfile assign a variable
defined here and have its value win, which is how a consuming root points the bazel
formatter at its own workspace, its own buildifier and its own exclusions. The leading
underscore says these are not meant to be run, not that they are private: any of them a
root might reasonably want to redirect is an interface between the two repositories.

Renaming one is therefore a breaking change that nothing reports. `just` has no notion
of an assignment that fails to override, so a root assigning the old name keeps parsing,
keeps listing, keeps passing CI, and silently reverts to the value here. Worse, a root
overriding several loses only the renamed one, leaving a half-applied configuration:
total failure would land in a state someone designed, while partial failure lands in one
nobody has ever seen.

Nothing can see it either, because the underscore that keeps these out of `just --list`
keeps them out of `--variables` and a bare `--evaluate` as well. Asked by name they do
answer, which is how a root checks that an override of its own still overrides anything:

```sh
just --evaluate _bazel_excluded                      # what mine is now
just --justfile <this-repo>/justfile --evaluate _bazel_excluded   # what it would be
```

A name that has gone says so rather than reporting an empty value. That is a diagnostic
to reach for once something looks wrong, though: it answers whether a name still exists,
not whether its meaning has changed, so it passes happily when the value here gains or
loses a pattern. Rename freely, but say so when handing the change over.

A directory that only makes sense when named explicitly can opt out of being found from
above:

```just
explicit_verbs := ['test']
```

This only affects the downward search. Running the verb from inside that directory, or
naming the directory on the command line, keeps working. A verb that passed over such a
directory says so and names it, so that a command covering a tree does not look like it
covered more than it did. That listing is part of the account of what ran and leaves the
exit status alone; only a verb that matched nothing at all fails.

The QL test suites use this: `test` on a language runs the whole suite, which takes a
long time, so that has to be asked for by name. Integration tests and the sharded
Kotlin suites that CI runs opt out for the same reason. What is left discoverable from
above is what is cheap enough to run without meaning to.

Being an ordinary variable, `explicit_verbs` is inherited by justfiles importing one
that sets it. That is normally what is wanted, as importing a suite's justfile means
being the same kind of suite, down to the reason for naming it explicitly. An importer
that disagrees can reassign it, and its own value wins:

```just
import '../some/suite/justfile'

explicit_verbs := []
```

Duplicate variables are allowed throughout (see `defs.just`), so this is silent in both
directions: assigning `explicit_verbs` without realising one was inherited overrides it
without complaint, which can put a heavy suite back within reach of a verb aimed at a
parent directory.

Justfiles are found through `git`, so a newly written one needs to be either tracked or
untracked-but-not-ignored to be picked up.

Another point is how launching QL tests can be tweaked:

- by default, the corresponding CLI is built from the internal repo (nothing is done if
  working in `codeql` standalone), and no additional database or consistency checks are
  made
- `--codeql=built` can be passed to skip the build step (if no changes were made to the
  CLI/extractors). This is consistent with the same pytest option
- you can add the additional checks that CI does with `--all-checks` or the `+`
  abbreviation. These additional checks are configured in justfiles per language, and
  correspond to all the additional checks that CI adds (but that a dev might not want to
  run by default).

Test arguments are passed around as `just` lists (`set lists`), so they reach the
underlying runner already split and arguments containing spaces survive intact.

One caveat: when a verb ends up running several recipes, non-positional arguments need
to be understood by all of them. That is fine when they speak the same language, as
`--learn` or `--codeql` do across QL and integration tests. It is not when they do not:
a broad `just test .` reaches bazel and pytest suites alike, and a flag meant for one of
them will fail on the other. It fails rather than being quietly ignored, so the answer
is to aim the verb at something narrower.

# Command separators

Commands are echoed between rules that span the terminal. The formatters echo a summary
rather than the line that runs: they name the formatter and what it is told to do, and
leave out the wrapper that collects the files, the patterns it walks and the flags that
only shape output. A leading `-> ` marks a line as that summary. `just -n` prints what
actually runs, which it does whether or not the recipe is `@`-quiet.

Nothing is lost by this, as a banner has never been something to paste: the echoed line
carried an unexpanded `"$@"`, which matches no file in another shell, so pasting one
formatted nothing and exited 0.

What a formatter says for itself is filtered down to what happened, as several name every
file they considered and most of them were left alone. One such line is kept on purpose:
buildifier's count of the warnings it could not fix, which is the only notice of them,
since it reports no detail in fix mode and exits 0 whether or not any remain. That tally
grows with the tree and is mostly lint about docstrings. Finding it tiresome is a reason
to configure what buildifier lints, never to widen the filter back over it, which would
take the warnings worth having along with the rest.

Measuring the width means a `shell()` call, and that runs on every parse, so the result
is exported as `JUST_CMD_RULE` and an inherited value is preferred to measuring again.

Inheritance crosses processes, which is what forwarding creates: a child per justfile
reached, each of them measuring nothing. A `mod` spawns no process, so a module measures
for itself, and the count is one per `mod` reached, however deeply nested, plus one for
the file itself. That is cheap, and modules agree anyway since they share a terminal,
but it is worth knowing before counting measurements. Presetting `JUST_CMD_RULE` skips
all of them, and is also how to fix the width in CI or in a recording — it is the whole
separator and ends up in a shell script, so every line of it has to be a comment, or it
runs.

With no terminal to ask — a pipe, a log, a shell without `stty` — it falls back to a
fixed 57 columns, so logs and CI output are the same width every time. That is one
branch rather than a platform test: `just` runs `sh` everywhere, so Windows takes
whichever arm fits rather than a path of its own.

# Tests

The scripts here have tests, run by `just test misc/just`, by `bazel test
//misc/just/...`, or by CI on any change under this directory. They are plain
`unittest`: this is the layer that runs other tooling, so it should not need a package
manager to check itself.

They exist for the class of bug that leaves no trace. An exclusion that stops excluding,
a verb that stops being found, an argument that arrives split in two — each of those
still exits zero, and the only symptom is work quietly not done. So the tests come in
pairs: one asserting the quiet outcome, and one positive control asserting the same
setup can produce the loud one. Without the second, a passing first test is also what a
test that runs nothing at all looks like.
