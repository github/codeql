import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.security.dataflow.PrototypePollutingAssignmentQuery

class Config extends ConsistencyConfiguration, Configuration {
  override File getAFile() { any() }
}
