import java

predicate badKotlinType(Element e, int i) {
  e = any(Expr expr | count(expr.getKotlinType()) = i) or
  e = any(LocalVariableDecl lvd | count(lvd.getKotlinType()) = i) or
  e = any(Parameter p | count(p.getKotlinType()) = i) or
  e = any(Constructor c | count(c.getReturnKotlinType()) = i) or
  e = any(Method m | count(m.getReturnKotlinType()) = i) or
  e = any(Field f | count(f.getKotlinType()) = i)
}

from Element e, int i
where
  // TODO: Java extractor doesn't populate these yet
  e.getFile().isKotlinSourceFile() and
  badKotlinType(e, i) and
  i != 1
select e, i
