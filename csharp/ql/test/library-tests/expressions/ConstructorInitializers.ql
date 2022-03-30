import csharp

private class ConstructorInitializerTarget extends Constructor {
  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    if this.fromSource()
    then this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    else (
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }
}

from Constructor c, ConstructorInitializer i, ConstructorInitializerTarget target
where c.getInitializer() = i and target = i.getTarget()
select c, i, target
