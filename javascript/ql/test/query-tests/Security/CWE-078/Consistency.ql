import javascript
deprecated import utils.test.ConsistencyChecking
import semmle.javascript.security.dataflow.CommandInjectionQuery as CommandInjection
import semmle.javascript.security.dataflow.IndirectCommandInjectionQuery as IndirectCommandInjection
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentQuery as ShellCommandInjectionFromEnvironment
import semmle.javascript.security.dataflow.UnsafeShellCommandConstructionQuery as UnsafeShellCommandConstruction
import semmle.javascript.security.dataflow.SecondOrderCommandInjectionQuery as SecondOrderCommandInjectionQuery

deprecated class CommandInjectionConsistency extends ConsistencyConfiguration {
  CommandInjectionConsistency() { this = "ComandInjection" }

  override File getAFile() { not result.getBaseName() = "uselesscat.js" }
}

import semmle.javascript.security.UselessUseOfCat

deprecated class UselessCatConsistency extends ConsistencyConfiguration {
  UselessCatConsistency() { this = "Cat" }

  override DataFlow::Node getAnAlert() { result instanceof UselessCat }

  override File getAFile() { result.getBaseName() = "uselesscat.js" }
}
