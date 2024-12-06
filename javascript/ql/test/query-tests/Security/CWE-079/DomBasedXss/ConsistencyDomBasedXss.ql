import javascript
deprecated import testUtilities.ConsistencyChecking
import semmle.javascript.security.dataflow.DomBasedXssQuery

deprecated class ConsistencyConfig extends ConsistencyConfiguration {
  ConsistencyConfig() { this = "ConsistencyConfig" }

  override DataFlow::Node getAnAlert() { DomBasedXssFlow::flow(_, result) }
}
