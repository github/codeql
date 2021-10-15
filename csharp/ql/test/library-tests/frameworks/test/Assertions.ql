import csharp
import semmle.code.csharp.commons.Assertions

query predicate assertTrue(BooleanAssertMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getParameter(m.getAnAssertionIndex(true))
}

query predicate assertFalse(BooleanAssertMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getParameter(m.getAnAssertionIndex(false))
}

query predicate assertNull(NullnessAssertMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getParameter(m.getAnAssertionIndex(true))
}

query predicate assertNonNull(NullnessAssertMethod m, Parameter p) {
  m.fromSource() and m.fromSource() and p = m.getParameter(m.getAnAssertionIndex(false))
}
