/**
 * @id java/hash-without-salt
 * @name Use of a One-Way Hash without a Salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @tags security
 *       external/cwe-759
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** The Java class `java.security.MessageDigest` */
class MessageDigest extends RefType {
  MessageDigest() { this.hasQualifiedName("java.security", "MessageDigest") }
}

/** The method `digest()` declared in `java.security.MessageDigest`. */
class MDDigestMethod extends Method {
  MDDigestMethod() {
    getDeclaringType() instanceof MessageDigest and
    hasName("digest")
  }
}

/** The method `update()` declared in `java.security.MessageDigest`. */
class MDUpdateMethod extends Method {
  MDUpdateMethod() {
    getDeclaringType() instanceof MessageDigest and
    hasName("update")
  }
}

/**
 * Gets a regular expression for matching common names of variables that indicate the value being held is a password.
 */
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
      MethodAccess mda, MethodAccess mua // invoke `md.digest()` with only one call of `md.update(password)`, that is, without the call of `md.update(digest)`
    |
      sink.asExpr() = mda.getQualifier() and
      mda.getMethod() instanceof MDDigestMethod and
      mda.getNumArgument() = 0 and // md.digest()
      mua.getMethod() instanceof MDUpdateMethod and // md.update(password)
      mua.getQualifier() = mda.getQualifier().(VarAccess).getVariable().getAnAccess() and
      not exists(MethodAccess mua2 |
        mua2.getMethod() instanceof MDUpdateMethod and // md.update(salt)
        mua2.getQualifier() = mua.getQualifier().(VarAccess).getVariable().getAnAccess() and
        mua2 != mua
      )
    )
    or
    // invoke `md.digest(password)` without another call of `md.update(salt)`
    exists(MethodAccess mda |
      sink.asExpr() = mda and
      mda.getMethod() instanceof MDDigestMethod and // md.digest(password)
      mda.getNumArgument() = 1 and
      not exists(MethodAccess mua |
        mua.getMethod() instanceof MDUpdateMethod and // md.update(salt)
        mua.getQualifier() = mda.getQualifier().(VarAccess).getVariable().getAnAccess()
      )
    )
  }

  /** Holds for additional steps such as `passwordStr.getBytes()` */
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      pred.asExpr() = ma.getAnArgument() and
      (succ.asExpr() = ma or succ.asExpr() = ma.getQualifier())
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is hashed without a salt.", source.getNode(),
  "The password"
