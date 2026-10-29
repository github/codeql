def boolops(x, y1, z1, y2, z2):
    p = not(
            x
            and not (
                     y1 or
                     z1))
    if not(
           x
           or not (
                   y2 and
                   z2)):
        return b"true"
    else:
        return b"false"
