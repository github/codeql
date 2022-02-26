/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @problem.severity error
 * @id cs/hash-without-salt
 * @tags security
 *       external/cwe-759
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow2
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.TaintTracking2
import DataFlow::PathGraph

/** The C# class `Windows.Security.Cryptography.Core.HashAlgorithmProvider`. */
class HashAlgorithmProvider extends RefType {
  HashAlgorithmProvider() {
    this.hasQualifiedName("Windows.Security.Cryptography.Core", "HashAlgorithmProvider")
  }
}

/** The C# class `System.Security.Cryptography.HashAlgorithm`. */
class HashAlgorithm extends RefType {
  HashAlgorithm() { this.hasQualifiedName("System.Security.Cryptography", "HashAlgorithm") }
}

/** The C# class `System.Security.Cryptography.KeyedHashAlgorithm`. */
class KeyedHashAlgorithm extends RefType {
  KeyedHashAlgorithm() {
    this.hasQualifiedName("System.Security.Cryptography", "KeyedHashAlgorithm")
  }
}

/**
 * The method `ComputeHash()`, `ComputeHashAsync`, `TryComputeHash`, `HashData`, or
 * `TryHashData` declared in `System.Security.Cryptography.HashAlgorithm` and the method
 * `HashData()` declared in `Windows.Security.Cryptography.Core.HashAlgorithmProvider`.
 */
class HashMethod extends Method {
  HashMethod() {
    this.getDeclaringType().getABaseType*() instanceof HashAlgorithm and
    this.getName().matches(["%ComputeHash%", "%HashData"])
    or
    this.getDeclaringType().getABaseType*() instanceof HashAlgorithmProvider and
    this.hasName("HashData")
  }
}

/**
 * Gets a regular expression for matching common names of variables that indicate the
 * value being held is a password.
 */
string getPasswordRegex() { result = "(?i)pass(wd|word|code|phrase)" }

/** Finds variables that hold password information judging by their names. */
class PasswordVarExpr extends Expr {
  PasswordVarExpr() {
    exists(Variable v | this = v.getAnAccess() | v.getName().regexpMatch(getPasswordRegex()))
  }
}

/**
 * Holds if `mc` is a hashing method call or invokes a hashing method call
 * directly or indirectly.
 */
predicate isHashCall(MethodCall mc) {
  mc.getTarget() instanceof HashMethod
  or
  exists(MethodCall mcc |
    mc.getTarget().calls(mcc.getTarget()) and
    isHashCall(mcc) and
    DataFlow::localExprFlow(mc.getTarget().getAParameter().getAnAccess(), mcc.getAnArgument())
  )
}

/** Holds if there is another hashing method call. */
predicate hasAnotherHashCall(MethodCall mc) {
  exists(MethodCall mc2, DataFlow2::Node src, DataFlow2::Node sink |
    isHashCall(mc2) and
    mc2 != mc and
    (
      src.asExpr() = mc.getQualifier() or
      src.asExpr() = mc.getAnArgument() or
      src.asExpr() = mc
    ) and
    (
      sink.asExpr() = mc2.getQualifier() or
      sink.asExpr() = mc2.getAnArgument()
    ) and
    DataFlow::localFlow(src, sink)
  )
}

/** Holds if a password hash without salt is further processed in another method call. */
predicate hasFurtherProcessing(MethodCall mc) {
  mc.getTarget().fromLibrary() and
  (
    mc.getTarget().hasQualifiedName("System.Array", "Copy") or // Array.Copy(passwordHash, 0, password.Length), 0, key, 0, keyLen);
    mc.getTarget().hasQualifiedName("System.String", "Concat") or // string.Concat(passwordHash, saltkey)
    mc.getTarget().hasQualifiedName("System.Buffer", "BlockCopy") or // Buffer.BlockCopy(passwordHash, 0, allBytes, 0, 20)
    mc.getTarget().hasQualifiedName("System.String", "Format") // String.Format("{0}:{1}:{2}", username, salt, password)
  )
}

/**
 * Holds if `mc` is part of a call graph that satisfies `isHashCall` but is not at the
 * top of the call hierarchy.
 */
predicate hasHashAncestor(MethodCall mc) {
  exists(MethodCall mpc |
    mpc.getTarget().calls(mc.getTarget()) and
    isHashCall(mpc) and
    DataFlow::localExprFlow(mpc.getTarget().getAParameter().getAnAccess(), mc.getAnArgument())
  )
}

/**
 * Taint configuration tracking flow from an expression whose name suggests it holds
 * password data to a method call that generates a hash without a salt.
 */
class HashWithoutSaltConfiguration extends TaintTracking::Configuration {
  HashWithoutSaltConfiguration() { this = "HashWithoutSaltConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      sink.asExpr() = mc.getArgument(0) and
      isHashCall(mc) and
      not hasAnotherHashCall(mc) and
      not hasHashAncestor(mc) and
      not exists(MethodCall mmc |
        hasFurtherProcessing(mmc) and
        DataFlow::localExprFlow(mc, mmc.getAnArgument())
      ) and
      not exists(Call c |
        (
          c.getTarget().getDeclaringType().getABaseType*() instanceof HashAlgorithm or
          c.getTarget()
              .getDeclaringType()
              .getABaseType*()
              .hasQualifiedName("System.Security.Cryptography", "DeriveBytes")
        ) and
        DataFlow::localExprFlow(mc, c.getAnArgument())
      )
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
   * Holds if a password is concatenated with a salt then hashed together through calls such as `System.Array.CopyTo()`, for example,
   *  `byte[] rawSalted  = new byte[passBytes.Length + salt.Length];`
   *  `passBytes.CopyTo(rawSalted, 0);`
   *  `salt.CopyTo(rawSalted, passBytes.Length);`
   *  `byte[] saltedPassword = sha256.ComputeHash(rawSalted);`
   *  Or the password is concatenated with a salt as a string.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodCall mc |
      hasFurtherProcessing(mc) and
      mc.getAnArgument() = node.asExpr()
    )
    or
    exists(AddExpr e | node.asExpr() = e.getAnOperand()) // password+salt
    or
    exists(InterpolatedStringExpr e | node.asExpr() = e.getAnInsert())
    or
    exists(Call c |
      c.getTarget()
          .getDeclaringType()
          .getABaseType*()
          .hasQualifiedName("System.Security.Cryptography", "DeriveBytes")
    )
    or
    // a salt or key is included in subclasses of `KeyedHashAlgorithm`
    exists(MethodCall mc, Assignment a, ObjectCreation oc |
      a.getRValue() = oc and
      oc.getObjectType().getABaseType+() instanceof KeyedHashAlgorithm and
      mc.getTarget() instanceof HashMethod and
      a.getLValue() = mc.getQualifier().(VariableAccess).getTarget().getAnAccess() and
      mc.getArgument(0) = node.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HashWithoutSaltConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is hashed without a salt.", source.getNode(),
  "The password"
