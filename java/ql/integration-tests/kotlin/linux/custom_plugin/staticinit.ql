import java

from Field f, Expr init
where init = f.getInitializer()
select f, init
