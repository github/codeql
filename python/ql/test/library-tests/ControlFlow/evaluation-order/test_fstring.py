"""F-string evaluation order."""

from timer import test


@test
def test_simple_fstring(t):
    name = "world" @ t[0]
    s = f"hello {name @ t[1]}" @ t[2]


@test
def test_multi_expr_fstring(t):
    a = "hello" @ t[0]
    b = "world" @ t[1]
    s = f"{a @ t[2]} {b @ t[3]}" @ t[4]


@test
def test_nested_fstring(t):
    inner = "world" @ t[0]
    s = f"hello {f'dear {inner @ t[1]}' @ t[2]}" @ t[3]


@test
def test_format_spec(t):
    x = 3.14159 @ t[0]
    s = f"{x @ t[1]:.2f}" @ t[2]


@test
def test_method_in_fstring(t):
    name = "world" @ t[0]
    s = f"hello {((name @ t[1]).upper @ t[2])() @ t[3]}" @ t[4]
