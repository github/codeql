import javascript
import semmle.javascript.security.dataflow.TaintedPathQuery
import testUtilities.ConsistencyChecking

class TaintedPathConsistency extends ConsistencyConfiguration {
  TaintedPathConsistency() { this = "TaintedPathConsistency" }

  override DataFlow::Node getAnAlert() { TaintedPathFlow::flowTo(result) }
}
