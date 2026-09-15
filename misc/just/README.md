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
  argument. Several may be found, in which case they run sequentially: `just format
  ql/cpp` formats everything under `ql/cpp` that knows how to format itself.

Both directions are searched, and every distinct recipe found runs. This matters because
a verb higher up is usually doing a different job from one further down rather than a
broader version of it: `rust` formats Rust sources while `rust/ql` formats QL, so
`just format rust` has to do both. A recipe that only arrived through `import` is the
same job, though, and runs once.

A directory that only makes sense when named explicitly can opt out of being found from
above:

```just
explicit_verbs := ['test']
```

This only affects the downward search. Running the verb from inside that directory, or
naming the directory on the command line, keeps working. A verb that passed over such a
directory says so and names it, so that a command covering a tree does not look like it
covered more than it did.

The QL test suites use this: `test` on a language runs the whole suite, which takes a
long time and needs a CodeQL CLI, so that has to be asked for by name. Integration tests
and the sharded Kotlin suites that CI runs opt out for the same reason. What is left
discoverable from above is what is cheap enough to run without meaning to.

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
