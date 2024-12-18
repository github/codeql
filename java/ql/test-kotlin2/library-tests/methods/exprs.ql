import java

from Expr e
where e.getFile().isSourceFile()
select e, e.getPrimaryQlClasses()
