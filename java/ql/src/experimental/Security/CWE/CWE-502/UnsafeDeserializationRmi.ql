/**
 * @name Unsafe deserialization in a remotely callable method.
 * @description If a registered remote object has a method that accepts a complex object,
 *              an attacker can take advantage of the unsafe deserialization mechanism
 *              which is used to pass parameters in RMI.
 *              In the worst case, it results in remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization-rmi
 * @tags security
 *       experimental
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Rmi
import BindingUnsafeRemoteObjectFlow::PathGraph

/**
 * A method that binds a name to a remote object.
 */
private class BindMethod extends Method {
  BindMethod() {
    (
      this.getDeclaringType().hasQualifiedName("java.rmi", "Naming") or
      this.getDeclaringType().hasQualifiedName("java.rmi.registry", "Registry")
    ) and
    this.hasName(["bind", "rebind"])
  }
}

/**
 * Holds if `type` has an vulnerable remote method.
 */
private predicate hasVulnerableMethod(RefType type) {
  exists(RemoteCallableMethod m, Type parameterType |
    m.getDeclaringType() = type and parameterType = m.getAParamType()
  |
    not parameterType instanceof PrimitiveType and
    not parameterType instanceof TypeString and
    not parameterType instanceof TypeObjectInputStream
  )
}

/**
 * A taint-tracking configuration for unsafe remote objects
 * that are vulnerable to deserialization attacks.
 */
private module BindingUnsafeRemoteObjectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ConstructorCall cc | cc = source.asExpr() |
      hasVulnerableMethod(cc.getConstructedType().getAnAncestor())
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma | ma.getArgument(1) = sink.asExpr() | ma.getMethod() instanceof BindMethod)
  }

  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      m.getDeclaringType().hasQualifiedName("java.rmi.server", "UnicastRemoteObject") and
      m.hasName("exportObject") and
      not m.getParameterType([2, 4]).(RefType).hasQualifiedName("java.io", "ObjectInputFilter") and
      ma.getArgument(0) = fromNode.asExpr() and
      ma = toNode.asExpr()
    )
  }
}

private module BindingUnsafeRemoteObjectFlow =
  TaintTracking::Global<BindingUnsafeRemoteObjectConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, BindingUnsafeRemoteObjectFlow::PathNode source,
  BindingUnsafeRemoteObjectFlow::PathNode sink, string message
) {
  BindingUnsafeRemoteObjectFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message = "Unsafe deserialization in a remote object."
}
