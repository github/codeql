/**
 * @name Java EE directory and file exposure from remote source
 * @description File and directory exposure based on unvalidated user-input may allow attackers
 *              to access arbitrary configuration files and source code of Java EE applications.
 * @kind path-problem
 * @id java/unsafe-request-dispatch
 * @tags security
 *       external/cwe/cwe-552
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** The Java class `javax.servlet.RequestDispatcher` or `jakarta.servlet.RequestDispatcher`. */
class RequestDispatcher extends RefType {
  RequestDispatcher() {
    this.hasQualifiedName("javax.servlet", "RequestDispatcher") or
    this.hasQualifiedName("jakarta.servlet", "RequestDispatcher")
  }
}

/** The `getRequestDispatcher` method. */
class GetRequestDispatcherMethod extends Method {
  GetRequestDispatcherMethod() {
    this.getReturnType() instanceof RequestDispatcher and
    this.getName() = "getRequestDispatcher"
  }
}

/** The request dispatch method. */
class RequestDispatchMethod extends Method {
  RequestDispatchMethod() {
    this.getDeclaringType() instanceof RequestDispatcher and
    this.hasName(["forward", "include"])
  }
}

/** Request dispatcher sink. */
class RequestDispatcherSink extends DataFlow::Node {
  RequestDispatcherSink() {
    exists(MethodAccess ma, MethodAccess ma2 |
      ma.getMethod() instanceof GetRequestDispatcherMethod and
      this.asExpr() = ma.getArgument(0) and
      ma2.getMethod() instanceof RequestDispatchMethod and
      DataFlow::localExprFlow(ma, ma2.getQualifier())
    )
  }
}

class RequestDispatchConfig extends TaintTracking::Configuration {
  RequestDispatchConfig() { this = "RequestDispatchConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RequestDispatcherSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestDispatchConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe request dispatcher due to $@.", source.getNode(),
  "user-provided value"
