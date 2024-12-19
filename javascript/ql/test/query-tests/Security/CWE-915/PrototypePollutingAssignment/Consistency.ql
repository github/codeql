import javascript
deprecated import utils.test.ConsistencyChecking
import semmle.javascript.security.dataflow.PrototypePollutingAssignmentQuery

deprecated class Config extends ConsistencyConfiguration {
  Config() { this = "Config" }

  override File getAFile() { any() }

  override DataFlow::Node getAnAlert() {
    exists(DataFlow::Node source |
      PrototypePollutingAssignmentFlow::flow(source, result) and
      not isIgnoredLibraryFlow(source, result)
    )
  }
}
