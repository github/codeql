import java

query predicate fields(Field f, Expr init) { f.getInitializer() = init }

from Callable c
where c.fromSource()
select c, c.getDeclaringType()
