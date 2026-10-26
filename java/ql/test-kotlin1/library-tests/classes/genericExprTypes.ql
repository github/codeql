import java

from Expr e
where e.getLocation().getFile().getBaseName() = "generic_anonymous.kt"
select e, e.getType().toString()
