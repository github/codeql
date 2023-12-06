/**
 * Provides classes and predicates for reasoning about use of inappropriate
 * cryptographic hashing algorithms on passwords.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking

class WeakPasswordHashingSink extends DataFlow::Node {
  string algorithm;

  WeakPasswordHashingSink() {
    // a call to System.Security.Cryptography.MD5/SHA*.ComputeHash/ComputeHashAsync/HashData/HashDataAsync
    exists(MethodCall call, string name |
      (
        call.getTarget().getName() = name
        and name in ["ComputeHash", "ComputeHashAsync", "HashData", "HashDataAsync"]
      )
      // with this as the first argument - not arg 0, since arg 0 is 'this' for methods
      and call.getArgument(0) = this.asExpr()
      and
      // the call is to a method in the System.Security.Cryptography.MD* class
      // or the System.Security.Cryptography.SHA* classes
      (
        call.getQualifier().getType().getName() = algorithm
        and algorithm.matches(["MD%","SHA%"])
      )
    )
  }

  string getAlgorithm() {
    result = algorithm
  }
}
