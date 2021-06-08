/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision low
 * @id java/hash-without-salt
 * @tags security
 *       external/cwe-759
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * Gets a regular expression for matching common names of variables
 * that indicate the value being held is a password.
 */
string getPasswordRegex() { result = "(?i).*pass(wd|word|code|phrase).*" }

/** Finds variables that hold password information judging by their names. */
class PasswordVarExpr extends VarAccess {
  PasswordVarExpr() {
    exists(string name | name = this.getVariable().getName().toLowerCase() |
      name.regexpMatch(getPasswordRegex()) and not name.matches("%hash%") // Exclude variable names such as `passwordHash` since their values were already hashed
    )
  }
}

/** Holds if `Expr` e is a direct or indirect operand of `ae`. */
predicate hasAddExprAncestor(AddExpr ae, Expr e) { ae.getAnOperand+() = e }

/** The Java class `java.security.MessageDigest`. */
class MessageDigest extends RefType {
  MessageDigest() { this.hasQualifiedName("java.security", "MessageDigest") }
}

/** The method call `MessageDigest.getInstance(...)` */
class MDConstructor extends StaticMethodAccess {
  MDConstructor() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof MessageDigest and
      m.hasName("getInstance")
    )
  }
}

/** The method `digest()` declared in `java.security.MessageDigest`. */
class MDDigestMethod extends Method {
  MDDigestMethod() {
    this.getDeclaringType() instanceof MessageDigest and
    this.hasName("digest")
  }
}

/** The method `update()` declared in `java.security.MessageDigest`. */
class MDUpdateMethod extends Method {
  MDUpdateMethod() {
    this.getDeclaringType() instanceof MessageDigest and
    this.hasName("update")
  }
}

/** The hashing method that could taint the input. */
class MDHashMethodAccess extends MethodAccess {
  MDHashMethodAccess() {
    (
      this.getMethod() instanceof MDDigestMethod or
      this.getMethod() instanceof MDUpdateMethod
    ) and
    this.getNumArgument() != 0
  }
}

/**
 * Holds if `MethodAccess` ma is a method access of `MDHashMethodAccess` or
 * invokes a method access of `MDHashMethodAccess` directly or indirectly.
 */
predicate isHashAccess(MethodAccess ma) {
  ma instanceof MDHashMethodAccess
  or
  exists(MethodAccess mca |
    ma.getMethod().calls(mca.getMethod()) and
    isHashAccess(mca) and
    DataFlow::localExprFlow(ma.getMethod().getAParameter().getAnAccess(), mca.getAnArgument())
  )
}

/**
 * Holds if there is a second method access that satisfies `isHashAccess` whose qualifier or argument
 * is the same as the method call `ma` that satisfies `isHashAccess`.
 */
predicate hasAnotherHashCall(MethodAccess ma) {
  isHashAccess(ma) and
  exists(MethodAccess ma2, VarAccess va |
    ma2 != ma and
    isHashAccess(ma2) and
    not va.getVariable().getType() instanceof PrimitiveType and
    (
      ma.getQualifier() = va and
      ma2.getQualifier() = va.getVariable().getAnAccess()
      or
      ma.getQualifier() = va and
      ma2.getAnArgument() = va.getVariable().getAnAccess()
      or
      ma.getAnArgument() = va and
      ma2.getQualifier() = va.getVariable().getAnAccess()
      or
      ma.getAnArgument() = va and
      ma2.getAnArgument() = va.getVariable().getAnAccess()
    )
  )
}

/**
 * Holds if `MethodAccess` ma is part of a call graph that satisfies `isHashAccess`
 * but is not at the top of the call hierarchy.
 */
predicate hasHashAncestor(MethodAccess ma) {
  exists(MethodAccess mpa |
    mpa.getMethod().calls(ma.getMethod()) and
    isHashAccess(mpa) and
    DataFlow::localExprFlow(mpa.getMethod().getAParameter().getAnAccess(), ma.getAnArgument())
  )
}

/** Holds if `MethodAccess` ma is a hashing call without a sibling node making another hashing call. */
predicate isSingleHashMethodCall(MethodAccess ma) {
  isHashAccess(ma) and not hasAnotherHashCall(ma)
}

/** Holds if `MethodAccess` ma is a single hashing call that is not invoked by a wrapper method. */
predicate isSink(MethodAccess ma) { isSingleHashMethodCall(ma) and not hasHashAncestor(ma) }

/** Sink of hashing calls. */
class HashWithoutSaltSink extends DataFlow::ExprNode {
  HashWithoutSaltSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getAnArgument() and
      isSink(ma)
    )
  }
}

/**
 * Taint configuration tracking flow from an expression whose name suggests it holds password data
 * to a method call that generates a hash without a salt.
 */
class HashWithoutSaltConfiguration extends TaintTracking::Configuration {
  HashWithoutSaltConfiguration() { this = "HashWithoutSaltConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof HashWithoutSaltSink }

  /**
   * Holds if a password is concatenated with a salt then hashed together through the call `System.arraycopy(password.getBytes(), ...)`, for example,
   *  `System.arraycopy(password.getBytes(), 0, allBytes, 0, password.getBytes().length);`
   *  `System.arraycopy(salt, 0, allBytes, password.getBytes().length, salt.length);`
   *  `byte[] messageDigest = md.digest(allBytes);`
   * Or the password is concatenated with a salt as a string.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "System") and
      ma.getMethod().hasName("arraycopy") and
      ma.getArgument(0) = node.asExpr()
    ) // System.arraycopy(password.getBytes(), ...)
    or
    exists(AddExpr e | hasAddExprAncestor(e, node.asExpr())) // password+salt
    or
    exists(ConditionalExpr ce | ce.getAChildExpr() = node.asExpr()) // useSalt?password+":"+salt:password
    or
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "StringBuilder") and
      ma.getMethod().hasName("append") and
      ma.getArgument(0) = node.asExpr() // stringBuilder.append(password).append(salt)
    )
    or
    exists(MethodAccess ma |
      ma.getQualifier().(VarAccess).getVariable().getType() instanceof Interface and
      ma.getAnArgument() = node.asExpr() // Method access of interface type variables requires runtime determination thus not handled
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration cc
where cc.hasFlowPath(source, sink)
select sink, source, sink, "$@ is hashed without a salt.", source, "The password"
