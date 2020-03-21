/**
 * @kind problem
 */

import javascript
import experimental.PoI.PoI::PoI
import semmle.javascript.security.dataflow.ReflectedXss
import semmle.javascript.security.dataflow.StoredXss
import semmle.javascript.security.dataflow.DomBasedXss
import semmle.javascript.security.dataflow.ExceptionXss

class Config extends StandardPoIConfigurations::DataFlowConfigurationPoIConfiguration {
  Config() { this = "Config" }
}

query predicate problems = alertQuery/6;