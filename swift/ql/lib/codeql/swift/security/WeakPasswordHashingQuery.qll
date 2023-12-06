/**
 * Provides a taint tracking configuration to find use of inappropriate
 * cryptographic hashing algorithms on passwords.
 */

import csharp
import semmle.code.csharp.security.SensitiveActions
import semmle.code.csharp.dataflow.DataFlow
import semmle.code.csharp.dataflow.TaintTracking

/**
 * A taint tracking configuration from password expressions to inappropriate
 * hashing sinks.
 */
module WeakHashingPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof PasswordExpr }

  predicate isSink(DataFlow::Node node) { node instanceof WeakPasswordHashingSink }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isBarrierOut(DataFlow::Node node) {
    // make sinks barriers so that we only report the closest instance
    isSink(node)
  }
}

module WeakHashingFlow = TaintTracking::Global<WeakHashingPasswordConfig>;

// TODO: rewrite with data extensions in mind, ref the Swift implementation
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
