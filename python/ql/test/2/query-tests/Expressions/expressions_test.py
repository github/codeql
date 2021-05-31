def use_of_apply(func, args):
    apply(func, args)


def use_of_input():
    return input() # NOT OK


def not_use_of_input():
    input = raw_input
    return input() # OK


if __name__ == "__main__":
    # if you enter 4+4 each time, you'll see that results are: 8, '4+4', 8
    print("result:", use_of_input())
    print("result:", not_use_of_input())
    print("result:", use_of_input())
