/**
 * @name Android fragment injection
 * @description Instantiating an Android fragment from a user-provided value
 *              may allow a malicious application to bypass access controls,  exposing the application to unintended effects.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/android/fragment-injection
 * @tags security
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.security.FragmentInjectionQuery
private import semmle.code.java.dataflow.DataFlowFiltering

module FragmentInjectionTaintFlow =
  TaintTracking::Global<FilteredConfig<FragmentInjectionTaintConfig>>;

import FragmentInjectionTaintFlow::PathGraph

from FragmentInjectionTaintFlow::PathNode source, FragmentInjectionTaintFlow::PathNode sink
where FragmentInjectionTaintFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Fragment depends on a $@, which may allow a malicious application to bypass access controls.",
  source.getNode(), "user-provided value"
