import java

query Callable callTargets(MethodCall mc) {
  result = mc.getCallee()
}

from Expr e
where e.getFile().getBaseName() = "Test.java"
select e, e.getType()

