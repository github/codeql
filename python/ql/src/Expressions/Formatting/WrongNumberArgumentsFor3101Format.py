def unsafe_format():
    the_format = "{} {} {}"
    if unlikely_condition():
        return the_format.format(1, 2)
    else:
        return the_format.format(1, 2, 3)

