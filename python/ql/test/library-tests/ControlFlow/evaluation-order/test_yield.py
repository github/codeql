"""Generator and yield evaluation order tests.

Generator bodies are lazy — code runs only when iterated.  The timer
annotations inside generator bodies fire interleaved with the caller's
annotations, reflecting the suspend/resume semantics of yield.
"""

from timer import test


@test
def test_simple_generator(t):
    """Basic generator: body runs on next(), not on gen()."""
    def gen():
        yield 1 @ t[4]
        yield 2 @ t[8]

    g = (gen @ t[0])() @ t[1]
    x = (next @ t[2])(g @ t[3]) @ t[5]
    y = (next @ t[6])(g @ t[7]) @ t[9]


@test
def test_multiple_yields(t):
    """Three yields interleave with three next() calls."""
    def gen():
        yield 1 @ t[4]
        yield 2 @ t[8]
        yield 3 @ t[12]

    g = (gen @ t[0])() @ t[1]
    a = (next @ t[2])(g @ t[3]) @ t[5]
    b = (next @ t[6])(g @ t[7]) @ t[9]
    c = (next @ t[10])(g @ t[11]) @ t[13]


@test
def test_generator_for_loop(t):
    """for-loop consumes generator, interleaving body and loop."""
    def gen():
        yield 1 @ t[2]
        yield 2 @ t[4]

    for val in (gen @ t[0])() @ t[1]:
        val @ t[3, 5]


@test
def test_generator_list(t):
    """list() consumes the entire generator without interleaving."""
    def gen():
        yield 10 @ t[3]
        yield 20 @ t[4]
        yield 30 @ t[5]

    result = (list @ t[0])((gen @ t[1])() @ t[2]) @ t[6]


@test
def test_yield_from(t):
    """yield from delegates to an inner generator transparently."""
    def inner():
        yield 1 @ t[6]
        yield 2 @ t[10]

    def outer():
        yield from (inner @ t[4])() @ t[5]

    g = (outer @ t[0])() @ t[1]
    x = (next @ t[2])(g @ t[3]) @ t[7]
    y = (next @ t[8])(g @ t[9]) @ t[11]


@test
def test_generator_return(t):
    """Generator return value accessed via yield from."""
    def gen():
        yield 1 @ t[6]
        return 42 @ t[10]

    def wrapper():
        result = (yield from (gen @ t[4])() @ t[5]) @ t[11]
        yield result @ t[12]

    g = (wrapper @ t[0])() @ t[1]
    x = (next @ t[2])(g @ t[3]) @ t[7]
    y = (next @ t[8])(g @ t[9]) @ t[13]


@test
def test_generator_send(t):
    """send() passes a value into the generator at the yield point."""
    def gen():
        x = (yield 1 @ t[4]) @ t[9]
        yield (x @ t[10] + 10 @ t[11]) @ t[12]

    g = (gen @ t[0])() @ t[1]
    first = (next @ t[2])(g @ t[3]) @ t[5]
    second = ((g @ t[6]).send @ t[7])(42 @ t[8]) @ t[13]


@test
def test_generator_expression(t):
    """Inline generator expression consumed by list()."""
    result = (list @ t[0])(x @ t[5, 6, 7] for x in [10 @ t[1], 20 @ t[2], 30 @ t[3]] @ t[4]) @ t[8]
