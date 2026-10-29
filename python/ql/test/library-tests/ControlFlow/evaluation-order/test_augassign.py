"""Augmented assignment evaluation order."""

from timer import test


@test
def test_plus_equals(t):
    x = 1 @ t[0]
    x += 2 @ t[1]
    y = x @ t[2]


@test
def test_sub_mul_div(t):
    x = 20 @ t[0]
    x -= 5 @ t[1]
    x *= 2 @ t[2]
    x /= 6 @ t[3]
    x = 17 @ t[4]
    x //= 3 @ t[5]
    x %= 3 @ t[6]
    y = x @ t[7]


@test
def test_power_equals(t):
    x = 2 @ t[0]
    x **= 3 @ t[1]
    y = x @ t[2]


@test
def test_bitwise_equals(t):
    x = 0b1111 @ t[0]
    x &= 0b1010 @ t[1]
    x |= 0b0101 @ t[2]
    x ^= 0b0011 @ t[3]
    y = x @ t[4]


@test
def test_shift_equals(t):
    x = 1 @ t[0]
    x <<= 4 @ t[1]
    x >>= 2 @ t[2]
    y = x @ t[3]


@test
def test_list_extend(t):
    x = [1 @ t[0], 2 @ t[1]] @ t[2]
    x += [3 @ t[3], 4 @ t[4]] @ t[5]
    y = x @ t[6]
