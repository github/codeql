import javascript

from ObjectExpr oe, Property p1, Property p2, int i, int j
where p1 = oe.getProperty(i) and
    p2 = oe.getProperty(j) and
    i < j and
    p1.getName() = p2.getName() and
    not oe.getTopLevel().isMinified()
select oe, "Property " + p1.getName() + " is defined both $@ and $@.", p1, "here", p2, "here"
