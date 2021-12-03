# Call Graph Tests

A small testing framework for our call graph resolution. It relies on manual annotation of calls and callables, **and will only include output if something is wrong**. For example, if we are not able to resolve that the `foo()` call will call the `foo` function, that should give an alert.

```py
# name:foo
def foo():
    pass
# calls:foo
foo()
```

This is greatly inspired by [`CallGraphs/AnnotatedTest`](https://github.com/github/codeql/blob/696d19cb1440b6f6a75c6a2c1319e18860ceb436/javascript/ql/test/library-tests/CallGraphs/AnnotatedTest/Test.ql) from JavaScript.

IMPORTANT: Names used in annotations are not scoped, so must be unique globally. (this is a bit annoying, but makes things simple). If multiple identical annotations are used, an error message will be output.

Important files:

- `CallGraphTest.qll`: main code to find annotated calls/callables and setting everything up.
- `PointsTo.ql`: results when using points-to for call graph resolution.
- `TypeTracker.ql`: results when using TypeTracking for call graph resolution.
- `Relative.ql`: differences between using points-to and TypeTracking.
- `code/` contains the actual Python code we test against (included by `test.py`).

All queries will also execute some `debug_*` predicates. These highlight any obvious problems with the annotation setup, and so there should never be any results committed. To show that this works as expected, see the [CallGraph-xfail](../CallGraph-xfail/)  which uses symlinked versions of the files in this directory (can't include as subdir, so has to be a sibling).

## `options` file

If the value for `--max-import-depth` is set so that `import random` will extract `random.py` from the standard library, BUT NO transitive imports are extracted, then points-to analysis will fail to handle the following snippet.

```py
import random
if random.random() < 0.5:
    func = foo
else:
    func = bar
func()
```
