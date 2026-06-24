/**
 * @name Information exposure through a exception throwing or control console
 * @description Remote information output through exception throwing or control console.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/exception-or-control-console-exposure
 * @tags security
 *       experimental
 *       external/cwe/cwe-209
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class ThrowRemoteMessageConfig extends TaintTracking::Configuration {
    ThrowRemoteMessageConfig() { this = "ThrowRemoteMessageConfig" }
    
    override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

    override predicate isSink(DataFlow::Node sink) {
        exists ( ClassInstanceExpr newExpr |
          newExpr.getConstructedType().getAnAncestor() instanceof TypeThrowable and
          newExpr.getAnArgument() = sink.asExpr()
        )
        or
        exists ( MethodAccess methodAccess, Class c |
            ( 
              methodAccess.getMethod().hasName("print") 
              or 
              methodAccess.getMethod().hasName("println") 
            ) and
            methodAccess.getCallee().getAParamType() = c and
            c.getASupertype*().hasQualifiedName("java.lang", "String") and
            methodAccess.getMethod().getAParameter().getAnArgument() = sink.asExpr()
        )
    }
}

from ThrowRemoteMessageConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source, sink, "Remote information exposure through a exception throwing or control console"