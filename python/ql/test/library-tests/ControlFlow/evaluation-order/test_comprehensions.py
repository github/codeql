"""Evaluation order tests for comprehensions and generator expressions."""

from timer import test


@test
def test_list_comprehension(t):
    items = [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]
    result = [x @ t[5, 6, 7] for x in items @ t[4]] @ t[8]


@test
def test_filtered_comprehension(t):
    items = [1 @ t[0], 2 @ t[1], 3 @ t[2], 4 @ t[3]] @ t[4]
    result = [x @ t[14, 23] for x in items @ t[5] if (x @ t[6, 10, 15, 19] % 2 @ t[7, 11, 16, 20] == 0 @ t[8, 12, 17, 21]) @ t[9, 13, 18, 22]] @ t[24]


@test
def test_dict_comprehension(t):
    items = [("a" @ t[0], 1 @ t[1]) @ t[2], ("b" @ t[3], 2 @ t[4]) @ t[5]] @ t[6]
    result = {k @ t[8, 10]: v @ t[9, 11] for k, v in items @ t[7]} @ t[12]


@test
def test_set_comprehension(t):
    items = [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]
    result = {x @ t[5, 6, 7] for x in items @ t[4]} @ t[8]


@test
def test_generator_expression(t):
    items = [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]
    gen = (x @ t[8, 9, 10] for x in items @ t[4]) @ t[5]
    result = (list @ t[6])(gen @ t[7]) @ t[11]


@test
def test_nested_comprehension(t):
    matrix = [[1 @ t[0], 2 @ t[1]] @ t[2], [3 @ t[3], 4 @ t[4]] @ t[5]] @ t[6]
    result = [x @ t[9, 10, 12, 13] for row in matrix @ t[7] for x in row @ t[8, 11]] @ t[14]


@test
def test_comprehension_with_call(t):
    items = [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]
    result = [(str @ t[5, 8, 11])(x @ t[6, 9, 12]) @ t[7, 10, 13] for x in items @ t[4]] @ t[14]
