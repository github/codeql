import javascript
deprecated import utils.test.ConsistencyChecking
import semmle.javascript.security.dataflow.XssThroughDomQuery

deprecated class ConsistencyConfig extends ConsistencyConfiguration {
  ConsistencyConfig() { this = "ConsistencyConfig" }

  override DataFlow::Node getAnAlert() {
    exists(DataFlow::Node source |
      XssThroughDomFlow::flow(source, result) and
      not isIgnoredSourceSinkPair(source, result)
    )
  }
}
