This directory contains an infrastructure for [`just`](https://github.com/casey/just)
recipes that can be used throughout this and the internal repository. In particular we
have common verbs (`build`, `test`, `format`, `lint`, `generate`) that individual parts
of the project can implement, and some common functionality that can be used to that
effect.

# Forwarding

The core of the functionality is given by forwarding. The idea is that:

- if you are in the directory where a verb is implemented, you will get that as per
  standard `just` behaviour (possibly using fallback).
- if on the other hand you are beneath it, and you run something like
  `just test ql/rust/ql/test/{a,b}`, then a forwarder script finds a common justfile
  implementing the verb for all the positional arguments passed there, and then retries
  calling `just test` from there. So if `test` is implemented beneath that (in that case,
  it is in `rust/ql/test`), it uses that recipe.
- even if there isn't a recipe that is common to all the positional arguments, the
  forwarder will still group the arguments in batches using the same recipe. So
  `just build ql/rust ql/java`, or
  `just test ql/rust/ql/test/some/language/test ql/rust/ql/integration-test/some/integration/test`
  will also work, with corresponding recipes run sequentially.

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

Some caveats:

- passing arguments with spaces generally doesn't work, although setting arguments with
  spaces in `justfile`s (for the base arguments) is supported using escaping as in `\\`.
  This is a known limitation of just (see
  <https://github.com/casey/just/issues/1988>)
- when running different recipes for the same verb, non-positional arguments need to be
  supported by all recipes involved. For example, this will work ok for `--learn` or
  `--codeql` options in language and integration tests
