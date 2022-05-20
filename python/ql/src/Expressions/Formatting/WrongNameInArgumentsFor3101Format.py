def unsafe_named_format():
    the_format = "{spam} {eggs}"
    if unlikely_condition():
        return the_format.format(spam="spam", completely_different="eggs")
    else:
        return the_format.format(spam="spam", eggs="eggs")
