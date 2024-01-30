import java

RefType getARelevantCollectionType() {
  result
      .hasQualifiedName(["java.util", "kotlin.collections"],
        ["Abstract", ""] + ["Mutable", ""] + ["Collection", "List", "Map"])
}

class RelevantMethod extends Method {
  RelevantMethod() { this.getDeclaringType().getSourceDeclaration() = getARelevantCollectionType() }
}

// Check for methods with suspicious twins -- probably another extraction of the same method outline which was given a different trap key.
// It so happens the collections methods of interest to this test don't use overloads with the same parameter count.
query predicate methodWithDuplicate(string methodName, string typeName) {
  exists(RelevantMethod m, RelevantMethod dup |
    dup.getName() = m.getName() and
    not dup.getName() = ["of", "remove", "toArray"] and // These really do have overloads with the same parameter count, so it isn't trivial to tell if they are intentional overloads or inappropriate duplicates.
    dup.getNumberOfParameters() = m.getNumberOfParameters() and
    dup.getDeclaringType() = m.getDeclaringType() and
    dup != m and
    methodName = m.getName() and
    typeName = m.getDeclaringType().getName()
  )
}

from RelevantMethod m
select m.getDeclaringType().getName(), m.getName(), m.getAParamType().getName()
