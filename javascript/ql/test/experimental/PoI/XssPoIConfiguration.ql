/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.ReflectedXss
import semmle.javascript.security.dataflow.StoredXss
import semmle.javascript.security.dataflow.DomBasedXss
import semmle.javascript.security.dataflow.ExceptionXss

class Config extends PoIConfiguration {
  Config() { this = "Config" }

  override predicate enabled(PoI poi) { poi instanceof DataFlowConfigurationPoI }
}

query predicate problems = alertQuery/6;
