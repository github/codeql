
#String concat in loop
def y(seq):
    y_accum = ''
    for s in seq:
        y_accum += s # $ Alert[py/string-concatenation-in-loop]


def z(seq):
    z_accum = ''
    for s in seq:
        z_accum = z_accum + s # $ Alert[py/string-concatenation-in-loop]
