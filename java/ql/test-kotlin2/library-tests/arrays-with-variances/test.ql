import java

class InterestingMethod extends Method {
  InterestingMethod() { this.getDeclaringType().getName() = "TakesArrayList" }
}

query predicate broken(string methodName) {
  methodName = any(InterestingMethod m).getName() and
  count(Type t, InterestingMethod m | methodName = m.getName() and t = m.getAParamType() | t) != 1
}

from InterestingMethod m
select m.getName(), m.getAParamType().toString()
