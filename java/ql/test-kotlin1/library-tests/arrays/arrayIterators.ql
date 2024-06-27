import java

query predicate iterator(MethodCall ma, string mn, string t) {
  exists(Method m |
    ma.getMethod() = m and
    m.getName() = "iterator" and
    mn = m.getSignature() and
    t = ma.getMethod().getDeclaringType().getQualifiedName()
  )
}
