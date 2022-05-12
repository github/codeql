import java

from Expr e, int n
where
  n = count(e.getType()) and
  n != 1 and
  // Java #144
  not e instanceof ReflectiveAccessAnnotation
select e, n
