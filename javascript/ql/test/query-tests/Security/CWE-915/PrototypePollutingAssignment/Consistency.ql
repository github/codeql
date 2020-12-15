import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.security.dataflow.PrototypePollutingAssignment

class Config extends ConsistencyConfiguration, PrototypePollutingAssignment::Configuration {
  override File getAFile() { any() }
}
