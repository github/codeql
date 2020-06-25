# This should cover all the syntactical constructs that we hope to support
# Intended sources should be the variable `SOUCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).
#
# Functions whose name ends with "_with_local_flow" will also be tested for local flow.

# Uncomment these to test the test code
# SOURCE = 42
# def SINK(x):
#     return 42

def test_tuple_with_local_flow():
    x = (3, SOURCE)
    y = x[1]
    SINK(y)