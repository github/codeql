"""Basic expression evaluation order.

These tests verify that sub-expressions within a single expression
are evaluated in the expected order (typically left to right for
operands of binary operators, elements of collection literals, etc.)

Every evaluated expression has a timestamp annotation, except the
timer mechanism itself (t[n], t.dead[n]).
"""

from timer import test


@test
def test_sequential_statements(t):
    """Statements execute top to bottom."""
    x = 1 @ t[0]
    y = 2 @ t[1]
    z = 3 @ t[2]


@test
def test_binary_add(t):
    """In a + b, left operand evaluates before right."""
    x = (1 @ t[0] + 2 @ t[1]) @ t[2]


@test
def test_binary_subtract(t):
    """In a - b, left operand evaluates before right."""
    x = (10 @ t[0] - 3 @ t[1]) @ t[2]


@test
def test_binary_multiply(t):
    """In a * b, left operand evaluates before right."""
    x = ((3 @ t[0]) * (4 @ t[1])) @ t[2]


@test
def test_nested_binary(t):
    """Sub-expressions evaluate before their containing expression."""
    x = ((1 @ t[0] + 2 @ t[1]) @ t[2] + (3 @ t[3] + 4 @ t[4]) @ t[5]) @ t[6]


@test
def test_chained_add(t):
    """a + b + c is (a + b) + c: left to right."""
    x = ((1 @ t[0] + 2 @ t[1]) @ t[2] + 3 @ t[3]) @ t[4]


@test
def test_mixed_precedence(t):
    """In a + b * c, all operands still evaluate left to right."""
    x = (1 @ t[0] + ((2 @ t[1]) * (3 @ t[2])) @ t[3]) @ t[4]


@test
def test_string_concat(t):
    """String concatenation operands: left to right."""
    x = (("hello" @ t[0] + " " @ t[1]) @ t[2] + "world" @ t[3]) @ t[4]


@test
def test_comparison(t):
    """In a < b, left operand evaluates before right."""
    x = (1 @ t[0] < 2 @ t[1]) @ t[2]


@test
def test_chained_comparison(t):
    """Chained a < b < c: all evaluated left to right (b only once)."""
    x = (1 @ t[0] < 2 @ t[1] < 3 @ t[2]) @ t[3]


@test
def test_list_elements(t):
    """List elements evaluate left to right."""
    x = [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]


@test
def test_dict_entries(t):
    """Dict: key before value, entries left to right."""
    d = {1 @ t[0]: "a" @ t[1], 2 @ t[2]: "b" @ t[3]} @ t[4]


@test
def test_tuple_elements(t):
    """Tuple elements evaluate left to right."""
    x = (1 @ t[0], 2 @ t[1], 3 @ t[2]) @ t[3]


@test
def test_set_elements(t):
    """Set elements evaluate left to right."""
    x = {1 @ t[0], 2 @ t[1], 3 @ t[2]} @ t[3]


@test
def test_subscript(t):
    """In obj[idx], object evaluates before index."""
    x = ([10 @ t[0], 20 @ t[1], 30 @ t[2]] @ t[3])[1 @ t[4]] @ t[5]


@test
def test_slice(t):
    """Slice parameters: object, then start, then stop."""
    x = ([1 @ t[0], 2 @ t[1], 3 @ t[2], 4 @ t[3], 5 @ t[4]] @ t[5])[1 @ t[6]:3 @ t[7]] @ t[8]


@test
def test_method_call(t):
    """Object evaluated, then attribute lookup, then arguments left to right, then call."""
    x = (("hello world" @ t[0]).replace @ t[1])("world" @ t[2], "there" @ t[3]) @ t[4]


@test
def test_method_chaining(t):
    """Chained method calls: left to right."""
    x = ((((" hello " @ t[0]).strip @ t[1])() @ t[2]).upper @ t[3])() @ t[4]


@test
def test_unary_not(t):
    """Unary not: operand evaluated first."""
    x = (not True @ t[0]) @ t[1]


@test
def test_unary_neg(t):
    """Unary negation: operand evaluated first."""
    x = (-(3 @ t[0])) @ t[1]


@test
def test_multiple_assignment(t):
    """RHS evaluated once in x = y = expr."""
    x = y = (1 @ t[0] + 2 @ t[1]) @ t[2]


@test
def test_callable_syntax(t):
    """t(value, n) is equivalent to value @ t[n]."""
    x = (1 @ t[0] + 2 @ t[1]) @ t[2]
    y = (x @ t[3] * 3 @ t[4]) @ t[5]


@test
def test_subscript_assign(t):
    """In obj[idx] = val, value is evaluated before target sub-expressions."""
    lst = [0 @ t[0], 0 @ t[1], 0 @ t[2]] @ t[3]
    (lst @ t[5])[1 @ t[6]] = 42 @ t[4]
    x = lst @ t[7]


@test
def test_attribute_assign(t):
    """In obj.attr = val, value is evaluated before the object."""
    class Obj:
        pass
    o = (Obj @ t[0])() @ t[1]
    (o @ t[3]).x = 42 @ t[2]
    y = (o @ t[4]).x @ t[5]


@test
def test_nested_subscript_assign(t):
    """Nested subscript assignment: val, then outer obj, then keys."""
    d = {"a" @ t[0]: [0 @ t[1], 0 @ t[2]] @ t[3]} @ t[4]
    (d @ t[6])["a" @ t[7]][1 @ t[8]] = 99 @ t[5]
    x = d @ t[9]


@test
def test_unreachable_after_return(t):
    """Code after return has no CFG node."""
    def f():
        x = 1 @ t[1]
        return x @ t[2]
        y = 2 @ t.never
    result = (f @ t[0])() @ t[3]


@test
def test_none_literal(t):
    """None is a name constant."""
    x = None @ t[0]
    y = (x @ t[1] is None @ t[2]) @ t[3]


@test
def test_delete(t):
    """del statement removes a variable binding."""
    x = 1 @ t[0]
    del x
    y = 2 @ t[1]


@test
def test_global(t):
    """global statement allows writing to module-level variable."""
    global _test_global_var
    _test_global_var = 1 @ t[0]
    x = _test_global_var @ t[1]


@test
def test_nonlocal(t):
    """nonlocal statement allows inner function to rebind outer variable."""
    x = 0 @ t[0]
    def inner():
        nonlocal x
        x = 1 @ t[2]
    (inner @ t[1])() @ t[3]
    y = x @ t[4]


@test
def test_walrus(t):
    """Walrus operator := evaluates the RHS and binds it."""
    if (y := 1 @ t[0]) @ t[1]:
        z = y @ t[2]
