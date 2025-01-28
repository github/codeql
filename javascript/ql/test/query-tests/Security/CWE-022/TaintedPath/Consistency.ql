import javascript
import semmle.javascript.security.dataflow.TaintedPathQuery
deprecated import utils.test.ConsistencyChecking

deprecated class TaintedPathConsistency extends ConsistencyConfiguration {
  TaintedPathConsistency() { this = "TaintedPathConsistency" }

  override DataFlow::Node getAnAlert() { TaintedPathFlow::flowTo(result) }
}
