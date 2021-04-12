/**
 * @name Unsafe deserialization with RMI.
 * @description TBD
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization-rmi
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.frameworks.Rmi

private class ObjectInputStream extends RefType {
  ObjectInputStream() { hasQualifiedName("java.io", "ObjectInputStream") }
}

private class BindMethod extends Method {
  BindMethod() {
    getDeclaringType().hasQualifiedName("java.rmi", "Naming") and
    hasName(["bind", "rebind"])
  }
}

private Method getVulnerableMethod(Type type) {
  type.(RefType).getASupertype*() instanceof TypeRemote and
  exists(Method m, Type parameterType |
    m.getDeclaringType() = type and parameterType = m.getAParamType()
  |
    not parameterType instanceof PrimitiveType and
    not parameterType instanceof TypeString and
    not parameterType instanceof ObjectInputStream and
    result = m
  )
}

private class UnsafeRmiBinding extends MethodAccess {
  Method vulnerableMethod;

  UnsafeRmiBinding() {
    this.getMethod() instanceof BindMethod and
    vulnerableMethod = getVulnerableMethod(this.getArgument(1).getType())
  }

  Method getVulnerableMethod() { result = vulnerableMethod }
}

// TODO: Cover Registry.bind() and rebind() -- test these sinks first

from UnsafeRmiBinding call
select call, "Unsafe deserialization with RMI in '" + call.getVulnerableMethod() + "' method"
