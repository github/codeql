/**
 * @name Information exposure through transmitted data
 * @description Transmitting sensitive information to the user is a potential security risk.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 4.3
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
import ExposureInTransmittedData::PathGraph

module ExposureInTransmittedDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
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

  predicate isSink(DataFlow::Node sink) { sink instanceof RemoteFlowSink }
}

module ExposureInTransmittedData = TaintTracking::Global<ExposureInTransmittedDataConfig>;

from ExposureInTransmittedData::PathNode source, ExposureInTransmittedData::PathNode sink
where ExposureInTransmittedData::flowPath(source, sink)
select sink.getNode(), source, sink, "This data transmitted to the user depends on $@.",
  source.getNode(), "sensitive information"
