"""Abstract timer for self-validating CFG evaluation-order tests.

Provides a Timer context manager and a @test decorator for writing tests
that verify the order in which Python evaluates expressions.

Usage with @test decorator (preferred):

    from timer import test

    @test
    def test_sequential(t):
        x = 1 @ t[0]
        y = 2 @ t[1]
        z = (x + y) @ t[2]

Usage with context manager (manual):

    from timer import Timer

    with Timer("my_test") as t:
        x = 1 @ t[0]

Timer API:
    t[n]          - assert current timestamp is n, return marker
    t[n, m, ...]  - assert current timestamp is one of {n, m, ...}
    t["label"]    - record current timestamp under label (development aid)
    t(value, n)   - equivalent to: value @ t[n]

Run a test file directly to self-validate: python test_file.py
"""

import atexit
import sys

_results = []


class _Check:
    """Marker returned by t[n] — asserts the current timestamp."""

    __slots__ = ("_timer", "_expected")

    def __init__(self, timer, expected):
        self._timer = timer
        self._expected = expected

    def __rmatmul__(self, value):
        ts = self._timer._tick()
        if ts not in self._expected:
            self._timer._error(
                f"expected {sorted(self._expected)}, got {ts}"
            )
        return value


class _Label:
    """Marker returned by t["name"] — records the timestamp under a label."""

    __slots__ = ("_timer", "_name")

    def __init__(self, timer, name):
        self._timer = timer
        self._name = name

    def __rmatmul__(self, value):
        ts = self._timer._tick()
        self._timer._labels.setdefault(self._name, []).append(ts)
        return value


class _NeverCheck:
    """Marker returned by t.never — fails if the expression is ever evaluated."""

    def __init__(self, timer):
        self._timer = timer

    def __rmatmul__(self, value):
        self._timer._error("expression annotated with t.never was evaluated")
        return value


class _DeadCheck:
    """Marker returned by t.dead[n] — fails if the expression is ever evaluated."""

    def __init__(self, timer):
        self._timer = timer

    def __rmatmul__(self, value):
        self._timer._error("expression annotated with t.dead was evaluated")
        return value


class _DeadSubscript:
    """Subscriptable returned by t.dead — produces _DeadCheck markers."""

    def __init__(self, timer):
        self._timer = timer

    def __getitem__(self, key):
        return _DeadCheck(self._timer)


class Timer:
    """Context manager tracking abstract evaluation timestamps.

    Each Timer instance maintains a counter starting at 0. Every time an
    annotation (@ t[n] or t(value, n)) is encountered, the counter is
    compared against the expected value and then incremented.
    """

    def __init__(self, name="<unnamed>"):
        self._name = name
        self._counter = 0
        self._errors = []
        self._labels = {}
        self.dead = _DeadSubscript(self)
        self.never = _NeverCheck(self)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self._labels:
            for name, timestamps in sorted(self._labels.items()):
                print(f"  {name}: {', '.join(map(str, timestamps))}")
        _results.append((self._name, list(self._errors)))
        if self._errors:
            print(f"{self._name}: FAIL")
            for err in self._errors:
                print(f"  {err}")
        else:
            print(f"{self._name}: ok")
        return False

    def _tick(self):
        ts = self._counter
        self._counter += 1
        return ts

    def _error(self, msg):
        self._errors.append(msg)

    def __getitem__(self, key):
        if isinstance(key, str):
            return _Label(self, key)
        elif isinstance(key, tuple):
            return _Check(self, list(key))
        else:
            return _Check(self, [key])

    def __call__(self, value, key):
        """Alternative to @ operator: t(value, 4) or t(value, [1, 2, 3])."""
        if isinstance(key, list):
            key = tuple(key)
        marker = self[key]
        return marker.__rmatmul__(value)


def test(fn):
    """Decorator that creates a Timer and runs the test function immediately.

    The function receives a fresh Timer as its sole argument. Errors are
    collected (not raised) and reported after the function completes.
    """
    with Timer(fn.__name__) as t:
        try:
            fn(t)
        except Exception as e:
            t._error(f"exception: {type(e).__name__}: {e}")
    return fn


def _report():
    """Print summary at interpreter exit."""
    if not _results:
        return
    total = len(_results)
    passed = sum(1 for _, errors in _results if not errors)
    print("---")
    print(f"{passed}/{total} tests passed")
    if passed < total:
        sys.exit(1)


atexit.register(_report)
