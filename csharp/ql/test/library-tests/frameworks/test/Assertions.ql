import csharp
import semmle.code.csharp.commons.Assertions

query predicate assertTrue(AssertTrueMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getAnAssertedParameter()
}

query predicate assertFalse(AssertFalseMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getAnAssertedParameter()
}

query predicate assertNull(AssertNullMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getAnAssertedParameter()
}

query predicate assertNonNull(AssertNonNullMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getAnAssertedParameter()
}
