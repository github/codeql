/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.ReflectedXss
import semmle.javascript.security.dataflow.StoredXss
import semmle.javascript.security.dataflow.DomBasedXss
import semmle.javascript.security.dataflow.ExceptionXss

class MyDataFlowConfigurationPoIs extends DataFlowConfigurationPoI, ActivePoI { }

query predicate problems = alertQuery/6;
