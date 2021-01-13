/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @id cs/hash-without-salt
 * @tags security
 *       external/cwe-759
 */

import csharp
import semmle.code.csharp.dataflow.TaintTracking
import DataFlow::PathGraph

/** The C# class `System.Security.Cryptography.SHA...` other than the weak `SHA1`. */
class SHA extends RefType {
  SHA() { this.getQualifiedName().regexpMatch("System\\.Security\\.Cryptography\\.SHA\\d{2,3}") }
}

class HashAlgorithmProvider extends RefType {
  HashAlgorithmProvider() {
    this.hasQualifiedName("Windows.Security.Cryptography.Core", "HashAlgorithmProvider")
  }
}

/** The method call `ComputeHash()` declared in `System.Security.Cryptography.SHA...`. */
class ComputeHashMethodCall extends MethodCall {
  ComputeHashMethodCall() {
    this.getQualifier().getType() instanceof SHA and
    this.getTarget().hasName("ComputeHash")
  }
}

/** The method call `ComputeHash()` declared in `System.Security.Cryptography.SHA...`. */
class HashDataMethodCall extends MethodCall {
  HashDataMethodCall() {
    this.getQualifier().getType() instanceof HashAlgorithmProvider and
    this.getTarget().hasName("HashData")
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
    exists(ComputeHashMethodCall mc |
      sink.asExpr() = mc.getArgument(0) // sha256Hash.ComputeHash(rawDatabytes)
    ) or
    exists(HashDataMethodCall mc |
      sink.asExpr() = mc.getArgument(0) // algProv.HashData(rawDatabytes)
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall mc |
      mc.getTarget()
          .hasQualifiedName("Windows.Security.Cryptography.CryptographicBuffer",
            "ConvertStringToBinary") and
      mc.getArgument(0) = node1.asExpr() and
      mc = node2.asExpr()
    )
  }

  /**
   * Holds if a password is concatenated with a salt then hashed together through the call `System.Array.CopyTo()`, for example,
   *  `byte[] rawSalted  = new byte[passBytes.Length + salt.Length];`
   *  `passBytes.CopyTo(rawSalted, 0);`
   *  `salt.CopyTo(rawSalted, passBytes.Length);`
   *  `byte[] saltedPassword = sha256.ComputeHash(rawSalted);`
   *  Or the password is concatenated with a salt as a string.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodCall mc |
      mc.getTarget().fromLibrary() and
      mc.getTarget().hasQualifiedName("System.Array", "CopyTo") and
      mc.getArgument(0) = node.asExpr()
    ) // passBytes.CopyTo(rawSalted, 0)
    or
    exists(AddExpr e | node.asExpr() = e.getAnOperand()) // password+salt
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is hashed without a salt.", source.getNode(),
  "The password"
