/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind path-problem
 * @problem.severity error
 * @id cs/hash-without-salt
 * @tags security
 *       experimental
 *       external/cwe/cwe-759
 */

import csharp
import HashWithoutSalt::PathGraph

/** The C# class `Windows.Security.Cryptography.Core.HashAlgorithmProvider`. */
class HashAlgorithmProvider extends RefType {
  HashAlgorithmProvider() {
    this.hasFullyQualifiedName("Windows.Security.Cryptography.Core", "HashAlgorithmProvider")
  }
}

/** The C# class `System.Security.Cryptography.HashAlgorithm`. */
class HashAlgorithm extends RefType {
  HashAlgorithm() { this.hasFullyQualifiedName("System.Security.Cryptography", "HashAlgorithm") }
}

/** The C# class `System.Security.Cryptography.KeyedHashAlgorithm`. */
class KeyedHashAlgorithm extends RefType {
  KeyedHashAlgorithm() {
    this.hasFullyQualifiedName("System.Security.Cryptography", "KeyedHashAlgorithm")
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
  exists(MethodCall mc2, DataFlow::Node src, DataFlow::Node sink |
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
    mc.getTarget().hasFullyQualifiedName("System", "Array", "Copy") or // Array.Copy(passwordHash, 0, password.Length), 0, key, 0, keyLen);
    mc.getTarget().hasFullyQualifiedName("System", "String", "Concat") or // string.Concat(passwordHash, saltkey)
    mc.getTarget().hasFullyQualifiedName("System", "Buffer", "BlockCopy") or // Buffer.BlockCopy(passwordHash, 0, allBytes, 0, 20)
    mc.getTarget().hasFullyQualifiedName("System", "String", "Format") // String.Format("{0}:{1}:{2}", username, salt, password)
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
module HashWithoutSaltConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PasswordVarExpr }

  predicate isSink(DataFlow::Node sink) {
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
              .hasFullyQualifiedName("System.Security.Cryptography", "DeriveBytes")
        ) and
        DataFlow::localExprFlow(mc, c.getAnArgument())
      )
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall mc |
      mc.getTarget()
          .hasFullyQualifiedName("Windows.Security.Cryptography", "CryptographicBuffer",
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
  predicate isBarrier(DataFlow::Node node) {
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
          .hasFullyQualifiedName("System.Security.Cryptography", "DeriveBytes")
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

module HashWithoutSalt = TaintTracking::Global<HashWithoutSaltConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, HashWithoutSalt::PathNode source, HashWithoutSalt::PathNode sink,
  string message, DataFlow::Node sourceNode, string password
) {
  sinkNode = sink.getNode() and
  sourceNode = source.getNode() and
  HashWithoutSalt::flowPath(source, sink) and
  message = "$@ is hashed without a salt." and
  password = "The password"
}
