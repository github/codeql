/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @id java/hash-without-salt
 * @tags security
 *       external/cwe-759
 */

import java
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.TaintTracking3
import DataFlow::PathGraph

/** The Java class `java.security.MessageDigest`. */
class MessageDigest extends RefType {
  MessageDigest() { this.hasQualifiedName("java.security", "MessageDigest") }
}

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
class PasswordHashConfiguration extends TaintTracking3::Configuration {
  PasswordHashConfiguration() { this = "PasswordHashConfiguration" }

  override predicate isSource(DataFlow3::Node source) { source.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow3::Node sink) {
    exists(
      MethodAccess ma // invoke `md.update(password)` without the call of `md.update(digest)`
    |
      sink.asExpr() = ma.getArgument(0) and
      (
        ma.getMethod() instanceof MDUpdateMethod or // md.update(password)
        ma.getMethod() instanceof MDDigestMethod // md.digest(password)
      )
    )
  }

  /**
   * Holds if a password is concatenated with a salt then hashed together through the call `System.arraycopy(password.getBytes(), ...)`, for example,
   *  `System.arraycopy(password.getBytes(), 0, allBytes, 0, password.getBytes().length);`
   *  `System.arraycopy(salt, 0, allBytes, password.getBytes().length, salt.length);`
   *  `byte[] messageDigest = md.digest(allBytes);`
   * Or the password is concatenated with a salt as a string.
   */
  override predicate isSanitizer(DataFlow3::Node node) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "System") and
      ma.getMethod().hasName("arraycopy") and
      ma.getArgument(0) = node.asExpr()
    ) // System.arraycopy(password.getBytes(), ...)
    or
    exists(AddExpr e | node.asExpr() = e.getAnOperand()) // password+salt
  }
}

class PasswordDigestConfiguration extends TaintTracking2::Configuration {
  PasswordDigestConfiguration() { this = "PasswordDigestConfiguration" }

  override predicate isSource(DataFlow2::Node source) {
    exists(MDConstructor mc | source.asExpr() = mc)
  }

  override predicate isSink(DataFlow2::Node sink) {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof MDUpdateMethod or
        ma.getMethod() instanceof MDDigestMethod
      ) and
      exists(PasswordHashConfiguration cc | cc.hasFlowToExpr(ma.getAnArgument())) and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

class HashWithoutSaltConfiguration extends TaintTracking::Configuration {
  HashWithoutSaltConfiguration() { this = "HashWithoutSaltConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(PasswordDigestConfiguration pc | pc.hasFlow(source, _))
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MDDigestMethod and // md.digest(password)
      sink.asExpr() = ma.getQualifier()
    )
  }

  /** Holds if `md.update` or `md.digest` calls integrate something other than the password, perhaps a salt. */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof MDUpdateMethod
        or
        ma.getMethod() instanceof MDDigestMethod and ma.getNumArgument() != 0
      ) and
      node.asExpr() = ma.getQualifier() and
      not exists(PasswordHashConfiguration cc | cc.hasFlowToExpr(ma.getAnArgument()))
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration cc
where cc.hasFlowPath(source, sink)
select sink, source, sink, "$@ is hashed without a salt.", source, "The password"
