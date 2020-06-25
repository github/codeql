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


# List taken from https://docs.python.org/3/reference/expressions.html
# 6. Expressions
# 6.1. Arithmetic conversions
# 6.2. Atoms
# 6.2.1. Identifiers (Names)
# 6.2.2. Literals
# 6.2.3. Parenthesized forms
# 6.2.4. Displays for lists, sets and dictionaries
# 6.2.5. List displays
# 6.2.6. Set displays
# 6.2.7. Dictionary displays
# 6.2.8. Generator expressions
# 6.2.9. Yield expressions
# 6.2.9.1. Generator-iterator methods
# 6.2.9.2. Examples
# 6.2.9.3. Asynchronous generator functions
# 6.2.9.4. Asynchronous generator-iterator methods
# 6.3. Primaries
# 6.3.1. Attribute references
# 6.3.2. Subscriptions
# 6.3.3. Slicings
# 6.3.4. Calls
# 6.4. Await expression
# 6.5. The power operator
# 6.6. Unary arithmetic and bitwise operations
# 6.7. Binary arithmetic operations
# 6.8. Shifting operations
# 6.9. Binary bitwise operations
# 6.10. Comparisons
# 6.10.1. Value comparisons
# 6.10.2. Membership test operations
# 6.10.3. Identity comparisons
# 6.11. Boolean operations
# 6.12. Assignment expressions
# 6.13. Conditional expressions
# 6.14. Lambdas
# 6.15. Expression lists
# 6.16. Evaluation order
# 6.17. Operator precedence
