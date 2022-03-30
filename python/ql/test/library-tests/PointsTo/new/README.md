## Dataflow, points-to, call-graph and type-inference tests.

Since dataflow, points-to, call-graph and type-inference are all interlinked it makes sense to test them together. 

### The test code.
The test code is all under the `code/` subdirectory and all test files are named \w_name, supporting
files do have an underscore as their second character.
This allows tests to be applied to a subset of the test data and test/data combinations to be turned on/off easily for debugging.

Be aware that here are two `__init__.py`, so the results are interleaved.




