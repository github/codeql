import python

// this can be quick-eval to see which ones have splitting. But that's basically just
// anything from line 39 and further.
predicate exprWithSplitting(Expr e) {
  exists(e.getLocation().getFile().getRelativePath()) and
  1 < count(ControlFlowNode cfn | cfn.getNode() = e)
}

from File f, string msg
where
  exists(f.getRelativePath()) and
  if exists(Expr e | e.getLocation().getFile() = f and exprWithSplitting(e))
  then msg = "has splitting"
  else msg = "does not have splitting"
select f.toString(), msg
