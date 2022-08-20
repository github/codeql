While working on the field-flow tests, I encountered some very strange behavior. By moving some tests into a new file, they suddenly started working :O

This folder contains the artifacts from investigating this problem, so we can recall the facts (but besides that, don't have much value in itself).

The test files can be found in `src/`, and I have set of a bunch of different tests with different extractor options in the `test-*` folders.

The core of the problem is that in _some_ configuration of extractor options, after seeing the code below, points-to gives up trying to resolve calls :flushed:

```py
import os
cond = os.urandom(1)[0] > 128

if cond:
    pass

if cond:
    pass
```

This seems to have been caused by not allowing enough imports to be resolved. There is also some interaction with splitting, since turning that off also removes the problem.

But allowing our test to see more imports is more representative of what happens when analyzing real code, so that's the better approach :+1: (and going above 3 does not seem to change anything in this case).

I've thought about whether we can write a query to reliably cases such as this, but I don't see any solutions. However, we can easily try running all our tests with `--max-import-depth=100` and see if anything changes from this.

# Seeing the solutions work

Doing `diff -u -r test-1-normal/ test-5-max-import-depth-3/` shows that all the calls we should be able to resolve, are now resolved properly. and critically this line is added:

```diff
+| ../src/urandom_problem.py:43:6:43:8 | ControlFlowNode for foo | Fixed missing result:flow="SOURCE, l:-15 -> foo" |
```

<details>
<summary>full diff</summary>

```diff
diff '--color=auto' -u -r test-1-normal/NormalDataflowTest.expected test-5-max-import-depth-3/NormalDataflowTest.expected
--- test-1-normal/NormalDataflowTest.expected	2022-02-27 10:33:00.603882599 +0100
+++ test-5-max-import-depth-3/NormalDataflowTest.expected	2022-02-28 10:10:08.930743800 +0100
@@ -1,2 +1,3 @@
 missingAnnotationOnSINK
 failures
+| ../src/urandom_problem.py:43:6:43:8 | ControlFlowNode for foo | Fixed missing result:flow="SOURCE, l:-15 -> foo" |
diff '--color=auto' -u -r test-1-normal/options test-5-max-import-depth-3/options
--- test-1-normal/options	2022-02-27 10:36:51.124793909 +0100
+++ test-5-max-import-depth-3/options	2022-02-27 11:01:43.908098372 +0100
@@ -1 +1 @@
-semmle-extractor-options: --max-import-depth=1 -R ../src
+semmle-extractor-options: --max-import-depth=3 -R ../src
diff '--color=auto' -u -r test-1-normal/UnresolvedCalls.expected test-5-max-import-depth-3/UnresolvedCalls.expected
--- test-1-normal/UnresolvedCalls.expected	2022-02-28 10:09:19.213742437 +0100
+++ test-5-max-import-depth-3/UnresolvedCalls.expected	2022-02-28 10:10:08.638737921 +0100
@@ -0,0 +1,5 @@
+| ../src/isfile_no_problem.py:34:33:34:70 | Comment # $ unresolved_call=os.path.isfile(..) | Missing result:unresolved_call=os.path.isfile(..) |
+| ../src/urandom_no_if_no_problem.py:34:31:34:64 | Comment # $ unresolved_call=os.urandom(..) | Missing result:unresolved_call=os.urandom(..) |
+| ../src/urandom_problem.py:34:31:34:64 | Comment # $ unresolved_call=os.urandom(..) | Missing result:unresolved_call=os.urandom(..) |
+| ../src/urandom_problem.py:42:18:42:47 | Comment # $ unresolved_call=give_src() | Missing result:unresolved_call=give_src() |
+| ../src/urandom_problem.py:43:11:43:75 | Comment # $ unresolved_call=SINK(..) MISSING: flow="SOURCE, l:-15 -> foo" | Missing result:unresolved_call=SINK(..) |
diff '--color=auto' -u -r test-1-normal/UnresolvedPointsToCalls.expected test-5-max-import-depth-3/UnresolvedPointsToCalls.expected
--- test-1-normal/UnresolvedPointsToCalls.expected	2022-02-28 10:09:19.033738812 +0100
+++ test-5-max-import-depth-3/UnresolvedPointsToCalls.expected	2022-02-28 10:12:48.572752108 +0100
@@ -1,5 +1 @@
-| ../src/urandom_no_if_no_problem.py:34:8:34:20 | ../src/urandom_no_if_no_problem.py:34 | os.urandom(..) |
 | ../src/urandom_no_import_no_problem.py:34:8:34:20 | ../src/urandom_no_import_no_problem.py:34 | os.urandom(..) |
-| ../src/urandom_problem.py:34:8:34:20 | ../src/urandom_problem.py:34 | os.urandom(..) |
-| ../src/urandom_problem.py:42:7:42:16 | ../src/urandom_problem.py:42 | give_src() |
-| ../src/urandom_problem.py:43:1:43:9 | ../src/urandom_problem.py:43 | SINK(..) |
```

</details>

There are no benefit in increasing import depth above 3 for this test-example:

```diff
$ diff -u -r test-4-max-import-depth-100/ test-5-max-import-depth-3/
--- test-4-max-import-depth-100/options 2022-02-28 10:02:09.269071781 +0100
+++ test-5-max-import-depth-3/options   2022-02-27 11:01:43.908098372 +0100
@@ -1 +1 @@
-semmle-extractor-options: --max-import-depth=100 -R ../src
+semmle-extractor-options: --max-import-depth=3 -R ../src
```

Also notice that using import depth 2 actually makes things worse, as we no longer handle the `isfile_no_problem.py` file properly :facepalm: :sweat_smile: NOTE: This was only for Python 3, for Python 2 there was no change :flushed:

```diff
diff '--color=auto' -u -r test-4-max-import-depth-100/NormalDataflowTest.expected test-6-max-import-depth-2/NormalDataflowTest.expected
--- test-4-max-import-depth-100/NormalDataflowTest.expected     2022-02-28 10:10:02.206608379 +0100
+++ test-6-max-import-depth-2/NormalDataflowTest.expected       2022-02-28 10:10:13.882716665 +0100
@@ -1,3 +1,5 @@
 missingAnnotationOnSINK
+| ../src/isfile_no_problem.py:43:6:43:8 | ../src/isfile_no_problem.py:43 | ERROR, you should add `# $ MISSING: flow` annotation | foo |
 failures
+| ../src/isfile_no_problem.py:43:11:43:41 | Comment # $ flow="SOURCE, l:-15 -> foo" | Missing result:flow="SOURCE, l:-15 -> foo" |
 | ../src/urandom_problem.py:43:6:43:8 | ControlFlowNode for foo | Fixed missing result:flow="SOURCE, l:-15 -> foo" |
```
