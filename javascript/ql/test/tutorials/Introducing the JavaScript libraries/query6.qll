import javascript

query predicate test_query6(Function fun, string res) {
  exists(Parameter p, Parameter q, int i, int j |
    p = fun.getParameter(i) and
    q = fun.getParameter(j) and
    i < j and
    p.getAVariable() = q.getAVariable()
  |
    res = "This function has two parameters that bind the same variable."
  )
}
