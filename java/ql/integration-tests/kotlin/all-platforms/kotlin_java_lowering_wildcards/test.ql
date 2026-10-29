import java

predicate isInterestingClass(Class c) {
  [c, c.(NestedType).getEnclosingType()].getName().matches(["KotlinDefns%", "JavaDefns%"])
}

from Callable c, string paramOrReturnName, Type paramOrReturnType
where
  isInterestingClass(c.getDeclaringType()) and
  (
    exists(Parameter p |
      p = c.getAParameter() and
      paramOrReturnName = p.getName() and
      paramOrReturnType = p.getType()
    )
    or
    paramOrReturnName = "return" and
    paramOrReturnType = c.getReturnType() and
    not paramOrReturnType instanceof VoidType
  )
select c.getDeclaringType().getQualifiedName(), c.getName(), paramOrReturnName,
  paramOrReturnType.toString()
