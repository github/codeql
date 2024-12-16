import javascript
import utils.test.ConsistencyChecking
import semmle.javascript.security.dataflow.PrototypePollutingAssignmentQuery

class Config extends ConsistencyConfiguration, Configuration {
  override File getAFile() { any() }
}
