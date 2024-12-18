import java
import semmle.code.java.Diagnostics

query predicate diag(Diagnostic d) { d.getMessage() = "Unexpected IrVararg" }

query predicate varargsParams(Parameter p, Type t) {
  p.getCallable().fromSource() and
  p.isVarargs() and
  t = p.getType()
}

query predicate explicitVarargsArguments(Argument a, Call c) {
  a.isExplicitVarargsArray() and
  a.getCall() = c
}

query predicate implicitVarargsArguments(Argument a, Call c, int pos) {
  a.isNthVararg(pos) and
  a.getCall() = c
}

from Call c, int i
select c, i, c.getArgument(i)
