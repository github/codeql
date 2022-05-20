

def fixed_raise_tuple1():
    ex = Exception("Important diagnostic information")
    raise ex


def fixed_raise_tuple2():
    raise Exception, "Important diagnostic information"
