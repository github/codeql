import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.security.dataflow.CommandInjection
import semmle.javascript.security.dataflow.IndirectCommandInjection
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironment
import semmle.javascript.security.dataflow.UnsafeShellCommandConstruction

class CommandInjectionConsistency extends ConsistencyConfiguration {
  CommandInjectionConsistency() { this = "ComandInjection" }

  override File getAFile() { not result.getBaseName() = "uselesscat.js" }
}

import semmle.javascript.security.UselessUseOfCat

class UselessCatConsistency extends ConsistencyConfiguration {
  UselessCatConsistency() { this = "Cat" }

  override DataFlow::Node getAnAlert() { result instanceof UselessCat }

  override File getAFile() { result.getBaseName() = "uselesscat.js" }
}
