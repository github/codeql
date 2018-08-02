/**
 * @name Information exposure through transmitted data
 * @description Transmitting sensitive information to the user is a potential security risk.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/sensitive-data-transmission
 * @tags security
 *       external/cwe/cwe-201
 */

import csharp
import semmle.code.csharp.security.SensitiveActions
import semmle.code.csharp.security.dataflow.XSS
import semmle.code.csharp.security.dataflow.Email
import semmle.code.csharp.frameworks.system.data.Common
import semmle.code.csharp.frameworks.System

class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() {
    this = "Exposure through transmitted data"
  }

  override predicate isSource(DataFlow::Node source) {
    // `source` may contain a password
    source.asExpr() instanceof PasswordExpr
    or
    // `source` is from a `DbException` property
    exists(PropertyRead pr, Property prop |
      source.asExpr() = pr and
      pr.getQualifier().getType() = any(SystemDataCommon::DbException de).getASubType*() and
      prop = pr.getTarget() |
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

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof XSS::Sink
    or
    sink instanceof Email::Sink
  }
}

from TaintTrackingConfiguration configuration, DataFlow::Node source, DataFlow::Node sink
where configuration.hasFlow(source, sink)
select sink, "Sensitive information from $@ flows to here, and is transmitted to the user.", source, source.toString()
