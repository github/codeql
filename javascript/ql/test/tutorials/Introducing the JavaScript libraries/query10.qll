import javascript

query predicate test_query10(Function f, string res) {
  exists(GlobalVariable gv |
    gv.getAnAccess().getEnclosingFunction() = f and not f.getStartBB().isLiveAtEntry(gv, _)
  |
    res = "This function uses " + gv.toString() + " like a local variable."
  )
}
