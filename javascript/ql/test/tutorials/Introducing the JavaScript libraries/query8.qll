import javascript

query predicate test_query8(
  ObjectExpr oe, string res0, Property p1, string res1, Property p2, string res2
) {
  exists(int i, int j |
    p1 = oe.getProperty(i) and
    p2 = oe.getProperty(j) and
    i < j and
    p1.getName() = p2.getName() and
    not oe.getTopLevel().isMinified()
  |
    res0 = "Property " + p1.getName() + " is defined both $@ and $@." and
    res1 = "here" and
    res2 = "here"
  )
}
