import python
import semmle.python.types.Extensions

/*
 * Customise: Claim any function called has_type_XXX return any class
 * whose name matches XXX
 */

class HasTypeFact extends CustomPointsToOriginFact {
  HasTypeFact() {
    exists(FunctionObject func, string name |
      func.getACall() = this and
      name = func.getName() and
      name.prefix("has_type_".length()) = "has_type_"
    )
  }

  override predicate pointsTo(Object value, ClassObject cls) {
    exists(FunctionObject func, string name |
      func.getACall() = this and
      name = func.getName() and
      name.prefix("has_type_".length()) = "has_type_"
    |
      cls.getName() = name.suffix("has_type_".length())
    ) and
    value = this
  }
}

from int line, ControlFlowNode f, Object o, ClassObject c
where
  f.getLocation().getStartLine() = line and
  exists(Comment ct | ct.getLocation().getStartLine() < line) and
  f.refersTo(o, c, _)
select line, f.toString(), o.toString(), c.toString()
