/**
 * @name Information exposure through transmitted data
 * @description Transmitting sensitive information to the user is a potential security risk.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/sensitive-data-transmission
 * @tags security
 *       external/cwe/cwe-201
 */

import csharp
import semmle.code.csharp.security.SensitiveActions
import semmle.code.csharp.security.dataflow.flowsinks.Remote
import semmle.code.csharp.frameworks.system.data.Common
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "Exposure through transmitted data" }

  override predicate isSource(DataFlow::Node source) {
    // `source` may contain a password
    source.asExpr() instanceof PasswordExpr
    or
    // `source` is from a `DbException` property
    exists(PropertyRead pr, Property prop |
      source.asExpr() = pr and
      pr.getQualifier().getType() = any(SystemDataCommon::DbException de).getASubType*() and
      prop = pr.getTarget()
    |
      prop.getName() = "Message" or
      prop.getName() = "Data"
    )
    or
    // `source` is from `DbException.ToString()`
    exists(MethodCall mc |
      source.asExpr() = mc and
      mc.getQualifier().getType() = any(SystemDataCommon::DbException de).getASubType*() and
      mc.getTarget() = any(SystemObjectClass c).getToStringMethod().getAnOverrider*()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RemoteFlowSink }
}

from TaintTrackingConfiguration configuration, DataFlow::PathNode source, DataFlow::PathNode sink
where configuration.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Sensitive information from $@ flows to here, and is transmitted to the user.", source.getNode(),
  source.toString()
