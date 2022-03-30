/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.TaintedPath

class MyDataflowRelatedPoIs extends DataFlowConfigurationPoI, ActivePoI { }

query predicate problems = alertQuery/6;
