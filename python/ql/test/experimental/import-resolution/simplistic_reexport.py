# we might consider anything imported to also be exported, but this is not the case

from trace import *
enter(__file__)

from bar import bar_attr
check("bar_attr", bar_attr, "bar_attr", globals()) #$ prints=bar_attr

bar_attr = "overwritten"
check("bar_attr", bar_attr, "overwritten", globals()) #$ prints=overwritten


from baz import *
check("baz_attr", baz_attr, "baz_attr", globals()) #$ MISSING: prints=baz_attr

baz_attr = "overwritten"
check("baz_attr", baz_attr, "overwritten", globals()) #$ prints=overwritten

exit(__file__)
