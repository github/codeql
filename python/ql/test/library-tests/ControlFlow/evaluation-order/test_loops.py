"""Loop control flow evaluation order tests."""

from timer import test, dead


# 1. Simple while loop (fixed iterations)
@test
def test_while_loop(t):
    i = 0 @ t[0]
    while (i @ t[1, 7, 13, 19] < 3 @ t[2, 8, 14, 20]) @ t[3, 9, 15, 21]:  # 4 checks: 3 true + 1 false
        i = (i @ t[4, 10, 16] + 1 @ t[5, 11, 17]) @ t[6, 12, 18]
    done = True @ t[22]


# 2. While loop with break
@test
def test_while_break(t):
    i = 0 @ t[0]
    while (i @ t[1, 10, 19] < 5 @ t[2, 11, 20]) @ t[3, 12, 21]:
        if (i @ t[4, 13, 22] == 2 @ t[5, 14, 23]) @ t[6, 15, 24]:
            break
        i = (i @ t[7, 16] + 1 @ t[8, 17]) @ t[9, 18]
    done = True @ t[25]


# 3. While loop with continue
@test
def test_while_continue(t):
    i = 0 @ t[0]
    total = 0 @ t[1]
    while (i @ t[2, 14, 23, 35] < 3 @ t[3, 15, 24, 36]) @ t[4, 16, 25, 37]:
        i = (i @ t[5, 17, 26] + 1 @ t[6, 18, 27]) @ t[7, 19, 28]
        if (i @ t[8, 20, 29] == 2 @ t[9, 21, 30]) @ t[10, 22, 31]:
            continue
        total = (total @ t[11, 32] + i @ t[12, 33]) @ t[13, 34]
    done = True @ t[38]


# 4. While/else (no break — else executes)
@test
def test_while_else(t):
    i = 0 @ t[0]
    while (i @ t[1, 7, 13] < 2 @ t[2, 8, 14]) @ t[3, 9, 15]:
        i = (i @ t[4, 10] + 1 @ t[5, 11]) @ t[6, 12]
    else:
        done = True @ t[16]


# 5. While/else (with break — else skipped)
@test
def test_while_else_break(t):
    i = 0 @ t[0]
    while (i @ t[1, 10] < 5 @ t[2, 11]) @ t[3, 12]:
        if (i @ t[4, 13] == 1 @ t[5, 14]) @ t[6, 15]:
            break
        i = (i @ t[7] + 1 @ t[8]) @ t[9]
    else:
        never = True @ t[dead(16)]
    after = True @ t[16]


# 6. Simple for loop over a list
@test
def test_for_list(t):
    for x in [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]:
        x @ t[4, 5, 6]
    done = True @ t[7]


# 7. For loop with range
@test
def test_for_range(t):
    for i in (range @ t[0])(3 @ t[1]) @ t[2]:
        i @ t[3, 4, 5]
    done = True @ t[6]


# 8. For loop with break
@test
def test_for_break(t):
    for x in [1 @ t[0], 2 @ t[1], 3 @ t[2], 4 @ t[3]] @ t[4]:
        if (x @ t[5, 9, 13] == 3 @ t[6, 10, 14]) @ t[7, 11, 15]:
            break
        x @ t[8, 12]
    done = True @ t[16]


# 9. For loop with continue
@test
def test_for_continue(t):
    total = 0 @ t[0]
    for x in [1 @ t[1], 2 @ t[2], 3 @ t[3]] @ t[4]:
        if (x @ t[5, 11, 14] == 2 @ t[6, 12, 15]) @ t[7, 13, 16]:
            continue
        total = (total @ t[8, 17] + x @ t[9, 18]) @ t[10, 19]
    done = True @ t[20]


# 10. For/else (no break — else executes)
@test
def test_for_else(t):
    for x in [1 @ t[0], 2 @ t[1]] @ t[2]:
        x @ t[3, 4]
    else:
        done = True @ t[5]


# 11. For/else (with break — else skipped)
@test
def test_for_else_break(t):
    for x in [1 @ t[0], 2 @ t[1], 3 @ t[2]] @ t[3]:
        if (x @ t[4, 8] == 2 @ t[5, 9]) @ t[6, 10]:
            break
        x @ t[7]
    else:
        never = True @ t[dead(11)]
    after = True @ t[11]


# 12. Nested loops
@test
def test_nested_loops(t):
    for i in [1 @ t[0], 2 @ t[1]] @ t[2]:
        for j in [10 @ t[3, 12], 20 @ t[4, 13]] @ t[5, 14]:
            (i @ t[6, 9, 15, 18, dead(21)] + j @ t[7, 10, 16, 19]) @ t[8, 11, 17, 20]
    done = True @ t[dead(3), dead(6), dead(9), dead(12), dead(15), dead(18), 21]


# 13. While True with conditional break
@test
def test_while_true_break(t):
    i = 0 @ t[0]
    while True @ t[1, 8, 15]:
        i = (i @ t[2, 9, 16] + 1 @ t[3, 10, 17]) @ t[4, 11, 18]
        if (i @ t[5, 12, 19] == 3 @ t[6, 13, 20]) @ t[7, 14, 21]:
            break
    done = True @ t[22]


# 14. For with enumerate
@test
def test_for_enumerate(t):
    for idx, val in (enumerate @ t[0])(["a" @ t[1], "b" @ t[2], "c" @ t[3]] @ t[4]) @ t[5]:
        idx @ t[6, 8, 10]
        val @ t[7, 9, 11]
    done = True @ t[12]
