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
    exists(Variable v | this = v.getAnAccess() | v.getName().regexpMatch(getPasswordRegex()))
  }
}

/** Taint configuration tracking flow from an expression whose name suggests it holds password data to a method call that generates a hash without a salt. */
class HashWithoutSaltConfiguration extends TaintTracking::Configuration {
  HashWithoutSaltConfiguration() { this = "HashWithoutSaltConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(
      MethodAccess mua, MethodAccess mda // invoke `md.digest()` with only one call of `md.update(password)`, that is, without the call of `md.update(digest)`
    |
      sink.asExpr() = mua.getArgument(0) and
      mua.getMethod() instanceof MDUpdateMethod and // md.update(password)
      mda.getMethod() instanceof MDDigestMethod and
      mda.getNumArgument() = 0 and // md.digest()
      mda.getQualifier() = mua.getQualifier().(VarAccess).getVariable().getAnAccess() and
      not exists(MethodAccess mua2 |
        mua2.getMethod() instanceof MDUpdateMethod and // md.update(salt)
        mua2.getQualifier() = mua.getQualifier().(VarAccess).getVariable().getAnAccess() and
        mua2 != mua
      )
    )
    or
    // invoke `md.digest(password)` without another call of `md.update(salt)`
    exists(MethodAccess mda |
      sink.asExpr() = mda.getArgument(0) and
      mda.getMethod() instanceof MDDigestMethod and // md.digest(password)
      mda.getNumArgument() = 1 and
      not exists(MethodAccess mua |
        mua.getMethod() instanceof MDUpdateMethod and // md.update(salt)
        mua.getQualifier() = mda.getQualifier().(VarAccess).getVariable().getAnAccess()
      )
    )
  }

  /**
   * Holds if a password is concatenated with a salt then hashed together through the call `System.arraycopy(password.getBytes(), ...)`. For example,
   *  `System.arraycopy(password.getBytes(), 0, allBytes, 0, password.getBytes().length);`
   *  `System.arraycopy(salt, 0, allBytes, password.getBytes().length, salt.length);`
   *  `byte[] messageDigest = md.digest(allBytes);`
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "System") and
      ma.getMethod().hasName("arraycopy") and
      ma.getArgument(0) = node.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is hashed without a salt.", source.getNode(),
  "The password"
