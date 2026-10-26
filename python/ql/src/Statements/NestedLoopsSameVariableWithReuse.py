def largest_elements(l):
    for x in l:
        maxnum = 0
        for x in x:
            maxnum = max(x, maxnum)
        # The outer loop variable x has now been overwritten by the inner loop.
        print "The largest element in the list", x, "is", maxnum


def largest_elements_correct(l):
    for x in l:
        maxnum = 0
        for y in x:
            maxnum = max(y, maxnum)
        print "The largest element in the list", x, "is", maxnum

