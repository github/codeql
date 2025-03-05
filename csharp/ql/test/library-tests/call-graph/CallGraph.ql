import csharp
import TestUtilities.InlineExpectationsTest

string getQualifiedNameType(Type t) {
  exists(string prefix, string typeArgsSuffix |
    (
      typeArgsSuffix = "`" + t.(UnboundGeneric).getNumberOfTypeParameters()
      or
      not t instanceof Generic and
      typeArgsSuffix = ""
    ) and
    result = prefix + typeArgsSuffix
  |
    prefix = getQualifiedNameType(t.(NestedType).getDeclaringType()) + "+" + t.getUndecoratedName()
    or
    prefix = getQualifiedNameType(t.(TypeParameter).getGeneric()) + "#" + t.getName()
    or
    prefix = getQualifiedNameCallable(t.(TypeParameter).getGeneric()) + "#" + t.getName()
    or
    not t instanceof NestedType and
    prefix =
      any(Namespace n | n.getATypeDeclaration() = t).getQualifiedName() + "." +
        t.getUndecoratedName()
  )
}

string getUndecoratedName(Callable c) {
  result = c.(Constructor).getName()
  or
  not c instanceof Constructor and
  result = c.getUndecoratedName()
}

string getQualifiedNameCallable(Callable c) {
  exists(string typeArgsSuffix |
    (
      typeArgsSuffix = "`" + c.(UnboundGeneric).getNumberOfTypeParameters()
      or
      not c instanceof Generic and
      typeArgsSuffix = ""
    )
  |
    result =
      getQualifiedNameType(c.getDeclaringType()) + "." + getUndecoratedName(c) + typeArgsSuffix
  )
}

// string getParameterType(Parameter p) { result = p.getType().getQualifiedName() }
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
      target = c.getTarget().getUnboundDeclaration() and
      (if isOverloaded(target) then sig = "(" + printSig(target) + ")" else sig = "") and
      value = getQualifiedNameCallable(target) + sig and
      c.getLocation() = location and
      not c.isImplicit()
    )
  }
}
