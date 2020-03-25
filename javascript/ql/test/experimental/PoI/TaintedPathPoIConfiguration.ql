/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.TaintedPath

class Config extends DataFlowConfigurationPoIConfiguration { }

query predicate problems = alertQuery/6;
