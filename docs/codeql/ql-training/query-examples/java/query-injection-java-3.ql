import java

predicate isStringConcat(AddExpr ae) {
  ae.getType() instanceof TypeString
}

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m and
  isStringConcat(ma.getArgument(0))
select ma, "SPARQL query vulnerable to injection."