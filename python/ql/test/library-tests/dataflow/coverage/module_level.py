# this test has code on module level, which works in slightly different ways than when
# inside a function

t = (SOURCE, NONSOURCE)
a, b = t
SINK(a) #$ flow="SOURCE, l:-2 -> a"
SINK_F(b)
