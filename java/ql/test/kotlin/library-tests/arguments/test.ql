import java

query predicate arguments(MethodAccess ma, int i, Expr e) { ma.getArgument(i) = e }

query predicate parameter_arg(Method m, int i, Expr e) {
  m.fromSource() and m.getParameter(i).getAnArgument() = e
}
