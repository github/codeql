import python
import semmle.python.dependencies.Dependencies

from DependencyKind dk, AstNode src, Object target
where dk.isADependency(src, target)
select dk.toString(), src.getLocation().getFile().getShortName(), src.getLocation().getStartLine(),
  src.toString(), target.toString()
