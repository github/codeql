import java

class RelevantAnnotationType extends AnnotationType {
  RelevantAnnotationType() { this.getCompilationUnit().hasName("AnnotationType") }
}

query predicate annotationType(
  RelevantAnnotationType t, string flagsString, string targets, string retentionPolicy
) {
  flagsString =
    concat(string s |
      t.isInherited() and s = "inherited"
      or
      t.isDocumented() and s = "documented"
      or
      t.isRepeatable() and s = "repeatable"
    |
      s, "," order by s
    ) and
  (
    // Workaround to test if no explicit @Target is specified; in that case any string except
    // TYPE_USE, which represents type contexts, is considered a target because it might be
    // added to ElementType in a future JDK version
    if t.isATargetType("<any-target>")
    then
      if t.isATargetType("TYPE_USE")
      then targets = "BUG: Includes TYPE_USE"
      else targets = "<any-target>"
    else
      targets =
        concat(string s |
          exists(EnumConstant elementType |
            elementType.getDeclaringType().hasQualifiedName("java.lang.annotation", "ElementType") and
            s = elementType.getName() and
            t.isATargetType(s)
          )
        |
          s, "," order by s
        )
  ) and
  retentionPolicy = t.getRetentionPolicy()
}

query AnnotationType containingAnnotationType(RelevantAnnotationType t) {
  result = t.getContainingAnnotationType()
}
