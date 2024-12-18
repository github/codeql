import java

from MethodCall ma, Method m
where m = ma.getMethod()
select ma, m

query predicate methods(Method m, string sig) {
  m.fromSource() and
  m.getSignature() = sig
}

query predicate overrides(Method m1, Method m2) {
  m1.fromSource() and
  m1.overrides(m2)
}

query predicate signature_mismatch(Method m, string sig) {
  m.getDeclaringType().getQualifiedName() = "Base" and
  m.getName() = "fn1" and
  m.getSignature() = sig
}
