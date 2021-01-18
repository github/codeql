/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @id java/hash-without-salt
 * @tags security
 *       external/cwe-759
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** The Java class `java.security.MessageDigest`. */
class MessageDigest extends RefType {
  MessageDigest() { this.hasQualifiedName("java.security", "MessageDigest") }
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

/** Gets a regular expression for matching common names of variables that indicate the value being held is a password. */
string getPasswordRegex() { result = "(?i).*pass(wd|word|code|phrase).*" }

/** Finds variables that hold password information judging by their names. */
class PasswordVarExpr extends Expr {
  PasswordVarExpr() {
    exists(Variable v | this = v.getAnAccess() |
      (
        v.getName().toLowerCase().regexpMatch(getPasswordRegex()) and
        not v.getName().toLowerCase().matches("%hash%") // Exclude variable names such as `passwordHash` since their values were already hashed
      )
    )
  }
}

/** Taint configuration tracking flow from an expression whose name suggests it holds password data to a method call that generates a hash without a salt. */
class HashWithoutSaltConfiguration extends TaintTracking::Configuration {
  HashWithoutSaltConfiguration() { this = "HashWithoutSaltConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(
      MethodAccess mua // invoke `md.update(password)` without the call of `md.update(digest)`
    |
      sink.asExpr() = mua.getArgument(0) and
      mua.getMethod() instanceof MDUpdateMethod // md.update(password)
    )
    or
    // invoke `md.digest(password)` without another call of `md.update(salt)`
    exists(MethodAccess mda |
      sink.asExpr() = mda.getArgument(0) and
      mda.getMethod() instanceof MDDigestMethod and // md.digest(password)
      mda.getNumArgument() = 1
    )
  }

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
    exists(AddExpr e | node.asExpr() = e.getAnOperand()) // password+salt
    or
    exists(MethodAccess mua, MethodAccess ma |
      ma.getArgument(0) = node.asExpr() and // Detect wrapper methods that invoke `md.update(salt)`
      ma != mua and
      (
        ma.getQualifier().getType() instanceof Interface
        or
        mua.getQualifier().(VarAccess).getVariable().getAnAccess() = ma.getQualifier()
        or
        mua.getAnArgument().(VarAccess).getVariable().getAnAccess() = ma.getQualifier()
        or
        mua.getQualifier().(VarAccess).getVariable().getAnAccess() = ma.getAnArgument()
        or
        mua.getArgument(0).(VarAccess).getVariable().getAnAccess() = ma.getAnArgument()
      ) and
      isMDUpdateCall(mua.getMethod())
    )
  }
}

/** Holds if a method invokes `md.update(salt)`. */
predicate isMDUpdateCall(Callable caller) {
  caller instanceof MDUpdateMethod
  or
  exists(Callable callee |
    caller.polyCalls(callee) and
    (
      callee instanceof MDUpdateMethod or
      isMDUpdateCall(callee)
    )
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is hashed without a salt.", source.getNode(),
  "The password"
