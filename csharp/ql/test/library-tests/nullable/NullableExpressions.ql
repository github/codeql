import csharp

from Expr e, Location loc
where e.getLocation() = loc and e.fromSource()
select loc.getStartLine(), loc.getStartColumn(), e.getParent(), e, e.getType().toString()
