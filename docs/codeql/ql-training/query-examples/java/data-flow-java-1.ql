import java

class StringConcat extends AddExpr {
  StringConcat() { getType() instanceof TypeString }
}

from MethodCall ma
where
  ma.getMethod().getName().matches("sparql%Query") and
  ma.getArgument(0) instanceof StringConcat
select ma, "SPARQL query vulnerable to injection."
