import cil
import semmle.code.cil.ConsistencyChecks

deprecated query predicate consistencyViolation(ConsistencyViolation v, string message) {
  message = v.getMessage()
}
