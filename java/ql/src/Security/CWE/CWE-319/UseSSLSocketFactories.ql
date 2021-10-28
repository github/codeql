/**
 * @name Failure to use SSL socket factories
 * @description Connections that are specified by non-SSL socket factories can be intercepted by
 *              third parties.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/non-ssl-socket-factory
 * @tags security
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.Encryption

class NetworkClass extends Class {
  NetworkClass() {
    this.getAnAncestor().getQualifiedName().matches("java.rmi.%") or
    this.getAnAncestor().getQualifiedName().matches("java.net.%") or
    this.getAnAncestor().getQualifiedName().matches("javax.net.%")
  }
}

class SocketFactoryType extends RefType {
  SocketFactoryType() {
    this.getQualifiedName() = "java.rmi.server.RMIServerSocketFactory" or
    this.getQualifiedName() = "java.rmi.server.RMIClientSocketFactory" or
    this.getQualifiedName() = "javax.net.SocketFactory" or
    this.getQualifiedName() = "java.net.SocketImplFactory"
  }
}

/** Holds if the method `m` has a factory parameter at location `p`. */
cached
predicate usesFactory(Method m, int p) {
  m.getParameter(p).getType().(RefType).getAnAncestor() instanceof SocketFactoryType
}

/** Holds if the method `m` has an overloaded method with a factory parameter. */
predicate overloadUsesFactories(Method m, Method overload) {
  overload.getAParamType().(RefType).getAnAncestor() instanceof SocketFactoryType and
  overloads(m, overload)
}

predicate overloads(Method m1, Method m2) {
  m1 != m2 and
  exists(RefType t, string name |
    methodInfo(m1, t, name) and
    methodInfo(m2, t, name)
  )
}

predicate methodInfo(Method m, RefType t, string name) {
  m.getDeclaringType() = t and
  m.getName() = name
}

predicate query(MethodAccess m, Method def, int paramNo, string message, Element evidence) {
  m.getMethod() = def and
  // Using a networking method.
  def.getDeclaringType() instanceof NetworkClass and
  (
    // Either the method has a factory parameter that is used, but not with
    // an SSL factory, ...
    usesFactory(def, paramNo) and
    evidence = m.getArgument(paramNo) and
    not evidence.(Expr).getType() instanceof SSLClass and
    message = "has a non-SSL factory argument "
    or
    // ... or there is an overloaded method on the same type that does take a factory,
    // which could be used for SSL.
    overloadUsesFactories(def, evidence) and
    paramNo = 0 and
    message = "could use custom factories via overloaded method "
  )
}

from MethodAccess m, Method def, int param, string message, Element evidence
where query(m, def, param, message, evidence)
select m, "Method " + message + ": use an SSL factory."
