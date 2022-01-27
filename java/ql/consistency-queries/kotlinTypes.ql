import java

predicate badKotlinType(Element e, int i) {
  e = any(Expr expr | count(expr.getKotlinType()) = i)
}

from Element e, int i
where e.getFile().isKotlinSourceFile()
  and badKotlinType(e, i)
  and i != 1
select e, i

