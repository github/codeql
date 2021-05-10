/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UnsafeDeserialization
import DataFlow::PathGraph

class UnsafeDeserializationConfig extends TaintTracking::Configuration {
  UnsafeDeserializationConfig() { this = "UnsafeDeserializationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node prod, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonReader and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr() and
      not exists(SafeJsonIo sji | sji.hasFlowToExpr(cie.getArgument(1)))
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof YamlReader and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr()
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof UnSafeHessianInput and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr()
    )
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof BurlapInput and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr()
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof BurlapInputInitMethod and
      ma.getArgument(0) = prod.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
<<<<<<< HEAD
=======
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeDeserializationConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(UnsafeDeserializationSink).getMethodAccess(), source, sink,
  "Unsafe deserialization of $@.", source.getNode(), "user input"
