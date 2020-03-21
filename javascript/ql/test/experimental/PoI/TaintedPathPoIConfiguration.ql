/**
 * @kind problem
 */

import javascript
import experimental.PoI.PoI::PoI
import semmle.javascript.security.dataflow.TaintedPath

class Config extends StandardPoIConfigurations::DataFlowConfigurationPoIConfiguration {
  Config() { this = "Config" }
}

query predicate problems = alertQuery/6;