/**
 * @kind problem
 */

import javascript
import experimental.PoI.PoI::PoI
import semmle.javascript.security.dataflow.CommandInjection
import semmle.javascript.security.dataflow.IndirectCommandInjection
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironment

class Config extends StandardPoIConfigurations::DataFlowConfigurationPoIConfiguration {
  Config() { this = "Config" }
}

query predicate problems = alertQuery/6;