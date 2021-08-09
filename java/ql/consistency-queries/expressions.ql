import java

from Expr e, int n
where n = count(e.getType())
  and n != 1
  // Java #144
  and not e instanceof ReflectiveAccessAnnotation
select e, n

