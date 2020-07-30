# This should cover all the syntactical constructs that we hope to support.
# Headings refer to https://docs.python.org/3/reference/expressions.html,
# and are selected whenever they incur dataflow.
# Intended sources should be the variable `SOURCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).
#
# Functions whose name ends with "_with_local_flow" will also be tested for local flow.
#
# All functions starting with "test_" should run and print a source (sources are defined in testConfig.qll).

# These are defined so that we can evaluate the test code.
SOURCE = "source"
def SINK(x):
    print(x)

def test_tuple_with_local_flow():
    x = (3, SOURCE)
    y = x[1]
    SINK(y)

# 6.2.1. Identifiers (Names)
def test_names():
    x = SOURCE
    SINK(x)

# 6.2.2. Literals
def test_string_literal():
    x = "source"
    SINK(x)

def test_bytes_literal():
    x = b"source"
    SINK(x)

def test_integer_literal():
    x = 42
    SINK(x)

def test_floatnumber_literal():
    x = 42.0
    SINK(x)

def test_imagnumber_literal():
    x = 42j
    SINK(x)

# 6.2.3. Parenthesized forms
def test_parenthesized_form():
    x = (SOURCE)
    SINK(x)

# 6.2.5. List displays
def test_list_display():
    x = [SOURCE]
    SINK(x[0])

def test_list_comprehension():
    x = [SOURCE for y in [3]]
    SINK(x[0])

def test_nested_list_display():
    x = [* [SOURCE]]
    SINK(x[0])

# 6.2.6. Set displays
def test_set_display():
    x = {SOURCE}
    SINK(x.pop())

def test_set_comprehension():
    x = {SOURCE for y in [3]}
    SINK(x.pop())

def test_nested_set_display():
    x = {* {SOURCE}}
    SINK(x.pop())

# 6.2.7. Dictionary displays
def test_dict_display():
    x = {"s": SOURCE}
    SINK(x["s"])

def test_dict_comprehension():
    x = {y: SOURCE for y in ["s"]}
    SINK(x["s"])

def test_nested_dict_display():
    x = {** {"s": SOURCE}}
    SINK(x["s"])

# 6.2.8. Generator expressions
def test_generator():
    x = (SOURCE for y in [3])
    SINK([*x][0])

# 6.2.9. Yield expressions
def gen(x):
    yield x

def test_yield():
    g = gen(SOURCE)
    SINK(next(g))

def gen_from(x):
    yield from gen(x)

def test_yield_from():
    g = gen_from(SOURCE)
    SINK(next(g))

# a statement rather than an expression, but related to generators
def test_for():
    for x in gen(SOURCE):
        SINK(x)

# 6.2.9.1. Generator-iterator methods
def test___next__():
    g = gen(SOURCE)
    SINK(g.__next__())

def gen2(x):
    m = yield x # argument of `send` has to flow to value of `yield x` (and so to `m`)
    yield m

def test_send():
    g = gen2(3)
    n = next(g)
    SINK(g.send(SOURCE))

def gen_ex(x):
    try:
        yield 3
    except:
        yield x # `x` has to flow to call to `throw`

def test_throw():
    g = gen_ex(SOURCE)
    n = next(g)
    SINK(g.throw(TypeError))

# no `test_close` as `close` involves no data flow

# 6.2.9.3. Asynchronous generator functions
async def agen(x):
    yield x

# 6.2.9.4. Asynchronous generator-iterator methods

# helper to run async test functions
def runa(a):
    import asyncio
    asyncio.run(a)

async def atest___anext__():
    g = agen(SOURCE)
    SINK(await g.__anext__())

def test___anext__():
    runa(atest___anext__())

async def agen2(x):
    m = yield x # argument of `send` has to flow to value of `yield x` (and so to `m`)
    yield m

async def atest_asend():
    g = agen2(3)
    n = await g.__anext__()
    SINK(await g.asend(SOURCE))

def test_asend():
    runa(atest_asend())

async def agen_ex(x):
    try:
        yield 3
    except:
        yield x # `x` has to flow to call to `athrow`

async def atest_athrow():
    g = agen_ex(SOURCE)
    n = await g.__anext__()
    SINK(await g.athrow(TypeError))

def test_athrow():
    runa(atest_athrow())

# 6.3.1. Attribute references
class C:
    a = SOURCE

def test_attribute_reference():
    SINK(C.a)

# overriding __getattr__ should be tested by the class coverage tests

# 6.3.2. Subscriptions
# This does not constitute dataflow (but could be taint flow)
def example_subscription_string():
    SINK("source"[0])

def test_subscription_tuple():
    SINK((SOURCE,)[0])

def test_subscription_list():
    SINK([SOURCE][0])

def test_subscription_mapping():
    SINK({"s":SOURCE}["s"])

# overriding __getitem__ should be tested by the class coverage tests

# 6.3.3. Slicings
l = [SOURCE]

def test_slicing():
    s = l[0:1:1]
    SINK(s[0])

# The grammar seems to allow `l[0:1:1, 0:1]`, but the interpreter does not like it

# 6.3.4. Calls
def f(a, b):
    return b

def test_call_positional():
    SINK(f(3, SOURCE))

def test_call_keyword():
    SINK(f(3, b=SOURCE))

def test_call_unpack_iterable():
    SINK(f(3, *[SOURCE]))

def test_call_unpack_mapping():
    SINK(f(3, **{"b": SOURCE}))

def f_extra_pos(a, *b):
    return b[0]

def test_call_extra_pos():
    SINK(f_extra_pos(3, SOURCE))

def f_extra_keyword(a, **b):
    return b["b"]

def test_call_extra_keyword():
    SINK(f_extra_keyword(3, b=SOURCE))

# return the name of the first extra keyword argument
def f_extra_keyword_flow(**a):
    return [*a][0]

# call the function with our source as the name of the keyword arguemnt
def test_call_extra_keyword_flow():
    SINK(f_extra_keyword_flow(**{SOURCE: None}))

# 6.12. Assignment expressions
def test_assignment_expression():
    x = 3
    SINK(x := SOURCE)

# 6.13. Conditional expressions
def test_conditional_true():
    SINK(SOURCE if True else 3)

def test_conditional_false():
    SINK(3 if False else SOURCE)

def test_conditional_evaluation_true():
    x = 3
    SINK(x if (SOURCE == (x := SOURCE)) else 3) # Condition is evaluated first, so x is SOURCE once chosen

def test_conditional_evaluation_false():
    x = 3
    SINK(3 if (3 == (x := SOURCE)) else x) # Condition is evaluated first, so x is SOURCE once chosen

# 6.14. Lambdas
def test_lambda():
    f = lambda x : x
    SINK(f(SOURCE))
