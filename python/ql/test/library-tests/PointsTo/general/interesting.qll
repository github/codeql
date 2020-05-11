import python

predicate of_interest(ControlFlowNode n, int line) {
  exists(Location l, File f | l = n.getLocation() |
    line = l.getStartLine() and
    f = l.getFile() and
    f.getName().matches("%test.py%") and
    exists(Comment c |
      c.getLocation().getStartLine() < line and
      c.getLocation().getFile() = f
    )
  )
}
