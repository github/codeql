/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.ReflectedXssQuery as ReflectedXss
import semmle.javascript.security.dataflow.StoredXssQuery as StoredXss
import semmle.javascript.security.dataflow.DomBasedXssQuery as DomBasedXss
import semmle.javascript.security.dataflow.ExceptionXssQuery as ExceptionXss

class MyDataFlowConfigurationPoIs extends DataFlowConfigurationPoI, ActivePoI { }

query predicate problems = alertQuery/6;
