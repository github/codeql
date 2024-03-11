import semmle.code.cil.Method
import semmle.code.csharp.Location

deprecated private string getType(Setter s) {
  if s.isInitOnly() then result = "init" else result = "set"
}

deprecated query predicate setters(Setter s, string type) {
  s.getLocation().(Assembly).getName() = "cil-init-prop" and
  type = getType(s)
}
