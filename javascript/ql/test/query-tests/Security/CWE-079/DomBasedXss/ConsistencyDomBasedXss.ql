import javascript
deprecated import utils.test.ConsistencyChecking
import semmle.javascript.security.dataflow.DomBasedXssQuery

deprecated class ConsistencyConfig extends ConsistencyConfiguration {
  ConsistencyConfig() { this = "ConsistencyConfig" }

  override DataFlow::Node getAnAlert() { DomBasedXssFlow::flow(_, result) }
}
