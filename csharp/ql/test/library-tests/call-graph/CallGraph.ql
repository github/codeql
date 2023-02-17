import csharp
import TestUtilities.InlineExpectationsTest

private predicate isOverloaded(Callable c) {
  exists(Callable other |
    c.getDeclaringType().hasCallable(other) and
    other.getName() = c.getName() and
    other != c
  )
}

private string printSig(Callable c) {
  isOverloaded(c) and
  result =
    concat(string s, int i | s = c.getParameter(i).getType().getQualifiedName() | s, "," order by i)
}

class CallGraphTest extends InlineExpectationsTest {
  CallGraphTest() { this = "CallGraphTest" }

  override string getARelevantTag() { result = "StaticTarget" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Call c, string sig, Callable target |
      element = c.toString() and
      tag = "StaticTarget" and
      target = c.getTarget() and
      (if isOverloaded(target) then sig = "(" + printSig(target) + ")" else sig = "") and
      value = target.getQualifiedName() + sig and
      c.getLocation() = location and
      not c.isImplicit()
    )
  }
}
