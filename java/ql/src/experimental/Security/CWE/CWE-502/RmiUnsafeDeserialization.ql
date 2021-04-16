/**
 * @name Unsafe deserialization with RMI.
 * @description If a registered remote object has a method that accepts a complex object,
 *              an attacker can take advantage of the unsafe deserialization mechanism
 *              which is used to pass parameters in RMI.
 *              In the worst case, it results in remote code execution.
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

/**
 * A method that binds a name to a remote object.
 */
private class BindMethod extends Method {
  BindMethod() {
    (
      getDeclaringType().hasQualifiedName("java.rmi", "Naming") or
      getDeclaringType().hasQualifiedName("java.rmi.registry", "Registry")
    ) and
    hasName(["bind", "rebind"])
  }
}

/**
 * Looks for a vulnerable method in a `Remote` object.
 */
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

/**
 * A method call that registers a remote object that has a vulnerable method.
 */
private class UnsafeRmiBinding extends MethodAccess {
  Method vulnerableMethod;

  UnsafeRmiBinding() {
    this.getMethod() instanceof BindMethod and
    vulnerableMethod = getVulnerableMethod(this.getArgument(1).getType())
  }

  Method getVulnerableMethod() { result = vulnerableMethod }
}

from UnsafeRmiBinding call
select call, "Unsafe deserialization with RMI in '" + call.getVulnerableMethod() + "' method"
