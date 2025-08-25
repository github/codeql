import java

from Method m, int n
where m.fromSource()
select m, m.getParameter(n), n

query predicate parametersWithArgs(Parameter p, int idx, Expr arg) {
  p.fromSource() and p.getPosition() = idx and p.getAnArgument() = arg
}

query predicate extensionParameter(Parameter p) { p.isExtensionParameter() }
