def sum_length_product1(l):
    if l == []:
        return 0, 0                              # this tuple has the wrong length
    else:
        val = l[0]
        restsum, restlength, restproduct = sum_length_product1(l[1:])
        return restsum + val, restlength + 1, restproduct * val

def sum_length_product2(l):
    if l == []:
        return 0, 0, 1                           # this tuple has the correct length
    else:
        val = l[0]
        restsum, restlength, restproduct = sum_length_product2(l[1:])
        return restsum + val, restlength + 1, restproduct * val
