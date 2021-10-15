import javascript

/** Gets a node to which the source node annotated with `name` is tracked under state `t`. */
DataFlow::SourceNode trackNamedNode(DataFlow::TypeTracker t, string name) {
  t.start() and
  exists(Comment c, string f, int l |
    f = c.getFile().getAbsolutePath() and
    l = c.getLocation().getStartLine() and
    result.hasLocationInfo(f, l, _, _, _) and
    name = c.getText().regexpFind("(?<=name: )\\S+", _, _)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = trackNamedNode(t2, name).track(t2, t))
}

/** Holds if `name` is tracked to expression `e` starting on line `l` of file `f`. */
predicate actual(Expr e, File f, int l, string name) {
  trackNamedNode(DataFlow::TypeTracker::end(), name).flowsToExpr(e) and
  f = e.getFile() and
  l = e.getLocation().getStartLine()
}

/**
 * Holds if there is an annotation comment expecting `name` to be tracked to an expression
 * on line `l` of file `f`.
 */
predicate expected(Comment c, File f, int l, string name) {
  f = c.getFile() and
  l = c.getLocation().getStartLine() and
  name = c.getText().regexpFind("(?<=track: )\\S+", _, _)
}

from Locatable loc, File f, int l, string name, string msg
where
  expected(loc, f, l, name) and
  not actual(_, f, l, name) and
  msg = "Failed to track " + name + " here."
  or
  actual(loc, f, l, name) and
  not expected(_, f, l, name) and
  expected(_, f, l, _) and
  msg = "Unexpectedly tracked " + name + " here."
select loc, msg
