import java

query predicate test(Method m1, Method m2) {
  m1.getName() = "iterator" and
  m1.getDeclaringType().getQualifiedName() = "java.util.List" and
  m1.overrides(m2)
}

query predicate test1(Method m1) {
  m1.getName() = "iterator" and
  m1.getDeclaringType().getQualifiedName() = "java.util.List"
}
