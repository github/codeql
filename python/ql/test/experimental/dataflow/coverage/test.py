# This should cover all the syntactical constructs that we hope to support.
# Headings refer to https://docs.python.org/3/reference/expressions.html,
# and are selected whenever they incur dataflow.
# Intended sources should be the variable `SOURCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).
#
# Functions whose name ends with "_with_local_flow" will also be tested for local flow.
#
# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")


def test_tuple_with_local_flow():
    x = (NONSOURCE, SOURCE)
    y = x[1]
    SINK(y) #$ flow="SOURCE, l:-2 -> y"


def test_tuple_negative():
    x = (NONSOURCE, SOURCE)
    y = x[0]
    SINK_F(y)


# 6.2.1. Identifiers (Names)
def test_names():
    x = SOURCE
    SINK(x) #$ flow="SOURCE, l:-1 -> x"


# 6.2.2. Literals
def test_string_literal():
    x = "source"
    SINK(x) #$ flow="'source', l:-1 -> x"


def test_bytes_literal():
    x = b"source"
    SINK(x) #$ flow="b'source', l:-1 -> x"


def test_integer_literal():
    x = 42
    SINK(x) #$ flow="42, l:-1 -> x"


def test_floatnumber_literal():
    x = 42.0
    SINK(x) #$ flow="42.0, l:-1 -> x"


def test_imagnumber_literal():
    x = 42j
    SINK(x) #$ MISSING:flow="42j, l:-1 -> x"


# 6.2.3. Parenthesized forms
def test_parenthesized_form():
    x = (SOURCE)
    SINK(x) #$ flow="SOURCE, l:-1 -> x"


# 6.2.5. List displays
def test_list_display():
    x = [SOURCE]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


def test_list_display_negative():
    x = [SOURCE]
    SINK_F(x)


def test_list_comprehension():
    x = [SOURCE for y in [NONSOURCE]]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


def test_list_comprehension_flow():
    x = [y for y in [SOURCE]]
    SINK(x[0]) #$  flow="SOURCE, l:-1 -> x[0]"


def test_list_comprehension_inflow():
    l = [SOURCE]
    x = [y for y in l]
    SINK(x[0]) #$ flow="SOURCE, l:-2 -> x[0]"


def test_nested_list_display():
    x = [*[SOURCE]]
    SINK(x[0]) #$ MISSING:flow="SOURCE, l:-1 -> x[0]"


# 6.2.6. Set displays
def test_set_display():
    x = {SOURCE}
    SINK(x.pop()) #$ flow="SOURCE, l:-1 -> x.pop()"


def test_set_comprehension():
    x = {SOURCE for y in [NONSOURCE]}
    SINK(x.pop()) #$ flow="SOURCE, l:-1 -> x.pop()"


def test_set_comprehension_flow():
    x = {y for y in [SOURCE]}
    SINK(x.pop()) #$ flow="SOURCE, l:-1 -> x.pop()"


def test_set_comprehension_inflow():
    l = {SOURCE}
    x = {y for y in l}
    SINK(x.pop()) #$ flow="SOURCE, l:-2 -> x.pop()"


def test_nested_set_display():
    x = {*{SOURCE}}
    SINK(x.pop()) #$ MISSING:flow="SOURCE, l:-1 -> x.pop()"


# 6.2.7. Dictionary displays
def test_dict_display():
    x = {"s": SOURCE}
    SINK(x["s"]) #$ flow="SOURCE, l:-1 -> x['s']"


def test_dict_display_pop():
    x = {"s": SOURCE}
    SINK(x.pop("s")) #$ flow="SOURCE, l:-1 -> x.pop(..)"


def test_dict_comprehension():
    x = {y: SOURCE for y in ["s"]}
    SINK(x["s"]) #$ MISSING:flow="SOURCE, l:-1 -> x['s']"


def test_dict_comprehension_pop():
    x = {y: SOURCE for y in ["s"]}
    SINK(x.pop("s")) #$ MISSING:flow="SOURCE, l:-1 -> x.pop()"


def test_nested_dict_display():
    x = {**{"s": SOURCE}}
    SINK(x["s"]) #$ MISSING:flow="SOURCE, l:-1 -> x['s']"


def test_nested_dict_display_pop():
    x = {**{"s": SOURCE}}
    SINK(x.pop("s")) #$ MISSING:flow="SOURCE, l:-1 -> x.pop()"


# Nested comprehensions
def test_nested_comprehension():
    x = [y for z in [[SOURCE]] for y in z]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


def test_nested_comprehension_deep_with_local_flow():
    x = [y for v in [[[[SOURCE]]]] for u in v for z in u for y in z]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


def test_nested_comprehension_dict():
    d = {"s": [SOURCE]}
    x = [y for k, v in d.items() for y in v]
    SINK(x[0]) #$ MISSING:flow="SOURCE, l:-2 -> x[0]"


def test_nested_comprehension_paren():
    x = [y for y in (z for z in [SOURCE])]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


# Iterable unpacking in comprehensions
def test_unpacking_comprehension():
    x = [a for (a, b) in [(SOURCE, NONSOURCE)]]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


def test_star_unpacking_comprehension():
    x = [a[0] for (*a, b) in [(SOURCE, NONSOURCE)]]
    SINK(x[0]) #$ flow="SOURCE, l:-1 -> x[0]"


# 6.2.8. Generator expressions
def test_generator():
    x = (SOURCE for y in [NONSOURCE])
    SINK([*x][0]) #$ MISSING:flow="SOURCE, l:-1 -> List[0]"


# 6.2.9. Yield expressions
def gen(x):
    yield x


def test_yield():
    g = gen(SOURCE)
    SINK(next(g)) #$ MISSING:flow="SOURCE, l:-1 -> next()"


def gen_from(x):
    yield from gen(x)


def test_yield_from():
    g = gen_from(SOURCE)
    SINK(next(g)) #$ MISSING:flow="SOURCE, l:-1 -> next()"


# a statement rather than an expression, but related to generators
def test_for():
    for x in gen(SOURCE):
        SINK(x) #$ MISSING:flow="SOURCE, l:-1 -> x"


# 6.2.9.1. Generator-iterator methods
def test___next__():
    g = gen(SOURCE)
    SINK(g.__next__()) #$ MISSING:flow="SOURCE, l:-1 -> g.__next__()"


def gen2(x):
    # argument of `send` has to flow to value of `yield x` (and so to `m`)
    m = yield x
    yield m


def test_send():
    g = gen2(NONSOURCE)
    n = next(g)
    SINK(g.send(SOURCE)) #$ MISSING:flow="SOURCE -> g.send()"


def gen_ex(x):
    try:
        yield NONSOURCE
    except:
        yield x  # `x` has to flow to call to `throw`


def test_throw():
    g = gen_ex(SOURCE)
    n = next(g)
    SINK(g.throw(TypeError)) #$ MISSING:flow="SOURCE, l:-2 -> g.throw()"


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
    SINK(await g.__anext__()) #$ MISSING:flow="SOURCE, l:-1 -> g.__anext__()"


def test___anext__():
    runa(atest___anext__())


async def agen2(x):
    # argument of `send` has to flow to value of `yield x` (and so to `m`)
    m = yield x
    yield m


async def atest_asend():
    g = agen2(NONSOURCE)
    n = await g.__anext__()
    SINK(await g.asend(SOURCE)) #$ MISSING:flow="SOURCE -> g.asend()"


def test_asend():
    runa(atest_asend())


async def agen_ex(x):
    try:
        yield NONSOURCE
    except:
        yield x  # `x` has to flow to call to `athrow`


async def atest_athrow():
    g = agen_ex(SOURCE)
    n = await g.__anext__()
    SINK(await g.athrow(TypeError)) #$ MISSING:flow="SOURCE, l:-2 -> g.athrow()"


def test_athrow():
    runa(atest_athrow())


# 6.3.1. Attribute references
class C:
    a = SOURCE


@expects(2)
def test_attribute_reference():
    SINK(C.a) #$ MISSING:flow="SOURCE, l:-4 -> C.a"
    c = C()
    SINK(c.a) #$ MISSING:flow="SOURCE, l:-6 -> c.a"

# overriding __getattr__ should be tested by the class coverage tests

# 6.3.2. Subscriptions
def test_subscription_tuple():
    SINK((SOURCE,)[0]) #$ flow="SOURCE -> Tuple[0]"


def test_subscription_list():
    SINK([SOURCE][0]) #$ flow="SOURCE -> List[0]"


def test_subscription_mapping():
    SINK({"s": SOURCE}["s"]) #$ flow="SOURCE -> Dict['s']"


# overriding __getitem__ should be tested by the class coverage tests


# 6.3.3. Slicings
l = [SOURCE]


def test_slicing():
    s = l[0:1:1]
    SINK(s[0]) #$ MISSING:flow="SOURCE -> s[0]"


# The grammar seems to allow `l[0:1:1, 0:1]`, but the interpreter does not like it

# 6.3.4. Calls
def second(a, b):
    return b


def test_call_positional():
    SINK(second(NONSOURCE, SOURCE)) #$ flow="SOURCE -> second(..)"


def test_call_positional_negative():
    SINK_F(second(SOURCE, NONSOURCE))


def test_call_keyword():
    SINK(second(NONSOURCE, b=SOURCE)) #$ flow="SOURCE -> second(..)"


def test_call_unpack_iterable():
    SINK(second(NONSOURCE, *[SOURCE])) #$ MISSING:flow="SOURCE -> second(..)"


def test_call_unpack_mapping():
    SINK(second(NONSOURCE, **{"b": SOURCE})) #$ flow="SOURCE -> second(..)"


def f_extra_pos(a, *b):
    return b[0]


def test_call_extra_pos():
    SINK(f_extra_pos(NONSOURCE, SOURCE)) #$ flow="SOURCE -> f_extra_pos(..)"


def f_extra_keyword(a, **b):
    return b["b"]


def test_call_extra_keyword():
    SINK(f_extra_keyword(NONSOURCE, b=SOURCE)) #$ flow="SOURCE -> f_extra_keyword(..)"


# return the name of the first extra keyword argument
def f_extra_keyword_flow(**a):
    return [*a][0]


# call the function with our source as the name of the keyword arguemnt
def test_call_extra_keyword_flow():
    SINK(f_extra_keyword_flow(**{SOURCE: None})) #$ MISSING:flow="SOURCE -> f_extra_keyword(..)"


# 6.11. Boolean operations

def test_or(x = False):
    # if we don't know the value of the lhs, we should always add flow
    SINK(x or SOURCE) #$ flow="SOURCE -> BoolExpr"


def test_and(x = True):
    # if we don't know the value of the lhs, we should always add flow
    SINK(x and SOURCE) #$ flow="SOURCE -> BoolExpr"


# 6.12. Assignment expressions
def test_assignment_expression():
    x = NONSOURCE
    SINK(x := SOURCE) #$ MISSING:flow="SOURCE -> x"


# 6.13. Conditional expressions
def test_conditional_true():
    SINK(SOURCE if True else NONSOURCE) #$ flow="SOURCE -> IfExp"


def test_conditional_true_guards():
    SINK_F(NONSOURCE if True else SOURCE)


def test_conditional_false():
    SINK(NONSOURCE if False else SOURCE) #$ flow="SOURCE -> IfExp"


def test_conditional_false_guards():
    SINK_F(SOURCE if False else NONSOURCE)


# Condition is evaluated first, so x is SOURCE once chosen
def test_conditional_evaluation_true():
    x = NONSOURCE
    SINK(x if (SOURCE == (x := SOURCE)) else NONSOURCE) #$ MISSING:flow="SOURCE -> IfExp"


# Condition is evaluated first, so x is SOURCE once chosen
def test_conditional_evaluation_false():
    x = NONSOURCE
    SINK(NONSOURCE if (NONSOURCE == (x := SOURCE)) else x) #$ MISSING:flow="SOURCE -> IfExp"


# 6.14. Lambdas
def test_lambda():
    def f(x):
        return x

    SINK(f(SOURCE)) #$ flow="SOURCE -> f(..)"


def test_lambda_positional():
    def second(a, b):
        return b

    SINK(second(NONSOURCE, SOURCE)) #$ flow="SOURCE -> second(..)"


def test_lambda_positional_negative():
    def second(a, b):
        return b

    SINK_F(second(SOURCE, NONSOURCE))


def test_lambda_keyword():
    def second(a, b):
        return b

    SINK(second(NONSOURCE, b=SOURCE)) #$ flow="SOURCE -> second(..)"


def test_lambda_unpack_iterable():
    def second(a, b):
        return b

    SINK(second(NONSOURCE, *[SOURCE])) #$ MISSING:flow="SOURCE -> second(..)"  # Flow missing


def test_lambda_unpack_mapping():
    def second(a, b):
        return b

    SINK(second(NONSOURCE, **{"b": SOURCE})) #$ flow="SOURCE -> second(..)"


def test_lambda_extra_pos():
    f_extra_pos = lambda a, *b: b[0]
    SINK(f_extra_pos(NONSOURCE, SOURCE)) #$ flow="SOURCE -> f_extra_pos(..)"


def test_lambda_extra_keyword():
    f_extra_keyword = lambda a, **b: b["b"]
    SINK(f_extra_keyword(NONSOURCE, b=SOURCE)) #$ flow="SOURCE -> f_extra_keyword(..)"


# call the function with our source as the name of the keyword argument
def test_lambda_extra_keyword_flow():
    # return the name of the first extra keyword argument
    f_extra_keyword_flow = lambda **a: [*a][0]
    SINK(f_extra_keyword_flow(**{SOURCE: None})) #$ MISSING:flow="SOURCE -> f_extra_keyword(..)"


@expects(4)
def test_swap():
    a = SOURCE
    b = NONSOURCE
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)

    a, b = b, a
    SINK_F(a)
    SINK(b) #$ flow="SOURCE, l:-7 -> b"


@expects(2)
def test_unpacking_assignment():
    t = (SOURCE, NONSOURCE)
    a, b = t
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)


@expects(3)
def test_nested_unpacking_assignment():
    t = (SOURCE, (NONSOURCE, SOURCE))
    a, (b, c) = t
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)
    SINK(c) #$ flow="SOURCE, l:-4 -> c"


@expects(2)
def test_deeply_nested_unpacking_assignment():
    t = [[[[SOURCE]]], NONSOURCE]
    [[[a]]], b = t
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)


@expects(4)
def test_iterated_unpacking_assignment():
    t = (SOURCE, SOURCE, NONSOURCE)
    a, *b, c = t
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)
    SINK(b[0]) #$ flow="SOURCE, l:-4 -> b[0]"
    SINK_F(c) #$ SPURIOUS: flow="SOURCE, l:-5 -> c"  # We do not track tuple sizes


@expects(3)
def test_iterated_unpacking_assignment_shrink():
    t = (SOURCE, SOURCE)
    a, *b, c = t
    SINK(a) #$ flow="SOURCE, l:-2 -> a"
    SINK_F(b)
    SINK(c) #$ flow="SOURCE, l:-4 -> c"


@expects(15)
def test_unpacking_assignment_conversion():
    ll = [[SOURCE, NONSOURCE, SOURCE], [SOURCE], [NONSOURCE]]

    # tuple
    ((a1, a2, a3), b, c) = ll
    SINK(a1) #$ flow="SOURCE, l:-4 -> a1"
    SINK_F(a2) #$ SPURIOUS: flow="SOURCE, l:-5 -> a2"  # We expect an FP as all elements are tainted
    SINK(a3) #$ flow="SOURCE, l:-6 -> a3"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(c)

    # mixed
    [(a1, a2, a3), b, c] = ll
    SINK(a1) #$ flow="SOURCE, l:-12 -> a1"
    SINK_F(a2) #$ SPURIOUS: flow="SOURCE, l:-13 -> a2"  # We expect an FP as all elements are tainted
    SINK(a3) #$ flow="SOURCE, l:-14 -> a3"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(c)

    # mixed differently
    ([a1, a2, a3], b, c) = ll
    SINK(a1) #$ flow="SOURCE, l:-20 -> a1"
    SINK_F(a2) #$ SPURIOUS: flow="SOURCE, l:-21 -> a2"  # We expect an FP as all elements are tainted
    SINK(a3) #$ flow="SOURCE, l:-22 -> a3"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(c)

@expects(24)
def test_iterated_unpacking_assignment_conversion():
    tt = ((SOURCE, NONSOURCE, SOURCE),NONSOURCE)

    # list
    [[a1, *a2], *b] = tt
    SINK(a1) #$ flow="SOURCE, l:-4 -> a1"
    SINK_F(a2)  # The list itself is not tainted
    SINK_F(a2[0]) #$ SPURIOUS: flow="SOURCE, l:-6 -> a2[0]"  # FP here due to list abstraction
    SINK(a2[1]) #$ flow="SOURCE, l:-7 -> a2[1]"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(b[0])

    # tuple
    ((a1, *a2), *b) = tt
    SINK(a1) #$ flow="SOURCE, l:-13 -> a1"
    SINK_F(a2)  # The list itself is not tainted
    SINK_F(a2[0]) #$ SPURIOUS: flow="SOURCE, l:-15 -> a2[0]"  # FP here due to list abstraction
    SINK(a2[1]) #$ flow="SOURCE, l:-16 -> a2[1]"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(b[0])

    # mixed
    [(a1, *a2), *b] = tt
    SINK(a1) #$ flow="SOURCE, l:-22 -> a1"
    SINK_F(a2)  # The list itself is not tainted
    SINK_F(a2[0]) #$ SPURIOUS: flow="SOURCE, l:-24 -> a2[0]"  # FP here due to list abstraction
    SINK(a2[1]) #$ flow="SOURCE, l:-25 -> a2[1]"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(b[0])

    # mixed differently
    ([a1, *a2], *b) = tt
    SINK(a1) #$ flow="SOURCE, l:-31 -> a1"
    SINK_F(a2)  # The list itself is not tainted
    SINK_F(a2[0]) #$ SPURIOUS: flow="SOURCE, l:-33 -> a2[0]"  # FP here due to list abstraction
    SINK(a2[1]) #$ flow="SOURCE, l:-34 -> a2[1]"
    SINK_F(b)  # The list itself is not tainted
    SINK_F(b[0])


@expects(3)
def test_iterable_repacking():
    a, *(b, c) = (SOURCE, NONSOURCE, SOURCE)
    SINK(a) #$ flow="SOURCE, l:-1 -> a"
    SINK_F(b)
    SINK(c) #$ MISSING: flow="SOURCE, l:-3 -> c"


@expects(4)
def test_iterable_unpacking_in_for():
    tl = [(SOURCE, NONSOURCE), (SOURCE, NONSOURCE)]
    for x,y in tl:
        SINK(x) #$ flow="SOURCE, l:-2 -> x"
        SINK_F(y)


@expects(6)
def test_iterable_star_unpacking_in_for():
    tl = [(SOURCE, NONSOURCE), (SOURCE, NONSOURCE)]
    for *x,y in tl:
        SINK_F(x)
        SINK(x[0]) #$ flow="SOURCE, l:-3 -> x[0]"
        SINK_F(y) #$ SPURIOUS: flow="SOURCE, l:-4 -> y"  # FP here since we do not track the tuple lenght and so `*x` could be empty


@expects(6)
def test_iterable_star_unpacking_in_for_2():
    tl = [(SOURCE, NONSOURCE), (SOURCE, NONSOURCE)]
    for x,*y,z in tl:
        SINK(x) #$ flow="SOURCE, l:-2 -> x"
        SINK_F(y)  # The list itself is not tainted (and is here empty)
        SINK_F(z)

def iterate_star_args(first, second, *args):
  for arg in args:
    SINK(arg) #$ flow="SOURCE, l:+5 -> arg" flow="SOURCE, l:+6 -> arg"

# FP reported here: https://github.com/github/codeql-python-team/issues/49
@expects(2)
def test_overflow_iteration():
  s = SOURCE
  iterate_star_args(NONSOURCE, NONSOURCE, SOURCE, s)

def test_deep_callgraph():
    # port of python/ql/test/library-tests/taint/general/deep.py

    def f1(arg):
        return arg

    def f2(arg):
        return f1(arg)

    def f3(arg):
        return f2(arg)

    def f4(arg):
        return f3(arg)

    def f5(arg):
        return f4(arg)

    def f6(arg):
        return f5(arg)

    x = f6(SOURCE)
    SINK(x) #$ MISSING:flow="SOURCE, l:-1 -> x"


@expects(2)
def test_dynamic_tuple_creation_1():
    tup = tuple()
    tup += (SOURCE,)
    tup += (NONSOURCE,)

    SINK(tup[0]) #$ MISSING:flow="SOURCE, l:-3 -> tup[0]"
    SINK_F(tup[1])


@expects(2)
def test_dynamic_tuple_creation_2():
    tup = ()
    tup += (SOURCE,)
    tup += (NONSOURCE,)

    SINK(tup[0]) #$ MISSING:flow="SOURCE, l:-3 -> tup[0]"
    SINK_F(tup[1])


@expects(2)
def test_dynamic_tuple_creation_3():
    tup1 = (SOURCE,)
    tup2 = (NONSOURCE,)
    tup = tup1 + tup2

    SINK(tup[0]) #$ MISSING:flow="SOURCE, l:-4 -> tup[0]"
    SINK_F(tup[1])


# Inspired by FP-report https://github.com/github/codeql/issues/4239
@expects(2)
def test_dynamic_tuple_creation_4():
    tup = ()
    for item in [SOURCE, NONSOURCE]:
        tup += (item,)

    SINK(tup[0]) #$ MISSING:flow="SOURCE, l:-3 -> tup[0]"
    SINK_F(tup[1])

def return_from_inner_scope(x):
    try:
        return x[0]
    except IndexError:
        return SOURCE

def test_return_from_inner_scope():
    SINK(return_from_inner_scope([]))  #$ flow="SOURCE, l:-3 -> return_from_inner_scope(..)"


# Inspired by reverse read inconsistency check
def insertAtA(d):
    d["a"] = SOURCE

def test_reverse_read_subscript():
    d = {"a": NONSOURCE}
    l = [d]
    insertAtA(l[0])
    SINK(d["a"])  #$ MISSING:flow="SOURCE, l-6 -> d['a']""

def test_reverse_read_dict_arg():
    d = {"a": NONSOURCE}
    dd = {"d": d}
    insertAtA(**dd)
    SINK(d["a"])  #$ MISSING:flow="SOURCE, l-12 -> d['a']""


class WithA:
    def setA(self, v):
        self.a = v

    def __init__(self):
        self.a = ""


def test_reverse_read_subscript_cls():
    withA = WithA()
    l = [withA]
    l[0].setA(SOURCE)
    SINK(withA.a) #$ MISSING:flow="SOURCE, l:-1 -> self.a"

@expects(3)
def test_with_default_param_value(x=SOURCE, /, y=SOURCE, *, z=SOURCE):
    SINK(x) #$ flow="SOURCE, l:-1 -> x"
    SINK(y) #$ flow="SOURCE, l:-2 -> y"
    SINK(z) #$ flow="SOURCE, l:-3 -> z"
