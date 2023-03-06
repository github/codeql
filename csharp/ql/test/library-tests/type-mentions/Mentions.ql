import csharp
import TestUtilities.InlineExpectationsTest

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
      value = td.getQualifiedName()
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
      value = tm.getType().getQualifiedName() and
      tag = "TypeMention"
    )
  }
}
