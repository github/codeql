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
    or
    result =
      getQualifiedNameCallable(c.(LocalFunction).getEnclosingCallable()) + "." +
        getUndecoratedName(c) + typeArgsSuffix
  )
}

class NamespaceTest extends InlineExpectationsTest {
  NamespaceTest() { this = "TypesTest" }

  override string getARelevantTag() {
    result = ["Class", "Struct", "Interface", "Enum", "TypeMention"]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Type td |
      td.fromSource() and
      td.getLocation() = location and
      element = td.toString() and
      value = getQualifiedNameType(td)
    |
      td instanceof Class and tag = "Class"
      or
      td instanceof Struct and tag = "Struct"
      or
      td instanceof Interface and tag = "Interface"
      or
      td instanceof Enum and tag = "Enum"
    )
    or
    exists(TypeMention tm |
      tm.getLocation() = location and
      element = tm.toString() and
      value = getQualifiedNameType(tm.getType()) and
      tag = "TypeMention"
    )
  }
}
