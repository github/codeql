/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * random values that are not cryptographically secure, as well as
 * extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module InsecureRandomness {
  /**
   * A data flow source for random values that are not cryptographically secure.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for random values that are not cryptographically secure.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for random values that are not cryptographically secure.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A simple random number generator that is not cryptographically secure.
   */
  class DefaultSource extends Source, DataFlow::ValueNode {
    override InvokeExpr astNode;

    DefaultSource() {
      exists(DataFlow::ModuleImportNode mod, string name | mod.getPath() = name |
        // require("random-number")();
        name = "random-number" and
        this = mod.getACall()
        or
        // require("random-int")();
        name = "random-int" and
        this = mod.getACall()
        or
        // require("random-float")();
        name = "random-float" and
        this = mod.getACall()
        or
        // require('random-seed').create()();
        name = "random-seed" and
        this = mod.getAMemberCall("create").getACall()
        or
        // require('unique-random')()();
        name = "unique-random" and
        this = mod.getACall().getACall()
      )
      or
      // Math.random()
      this = DataFlow::globalVarRef("Math").getAMemberCall("random")
      or
      // (new require('chance')).<name>()
      this = DataFlow::moduleImport("chance").getAnInstantiation().getAMemberInvocation(_)
      or
      // require('crypto').pseudoRandomBytes()
      this = DataFlow::moduleMember("crypto", "pseudoRandomBytes").getAnInvocation()
    }
  }

  /**
   * A sensitive write, considered as a sink for random values that are not cryptographically
   * secure.
   */
  class SensitiveWriteSink extends Sink {
    SensitiveWriteSink() { this instanceof SensitiveWrite }
  }

  /**
   * A cryptographic key, considered as a sink for random values that are not cryptographically
   * secure.
   */
  class CryptoKeySink extends Sink {
    CryptoKeySink() { this instanceof CryptographicKey }
  }

  /**
   * Holds if the step `pred` -> `succ` is an additional taint-step for random values that are not cryptographically secure.
   */
  predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Assume that all operations on tainted values preserve taint: crypto is hard
    succ.asExpr().(BinaryExpr).getAnOperand() = pred.asExpr()
    or
    succ.asExpr().(UnaryExpr).getOperand() = pred.asExpr()
    or
    exists(DataFlow::MethodCallNode mc |
      mc = DataFlow::globalVarRef("Math").getAMemberCall(_) and
      pred = mc.getAnArgument() and
      succ = mc
    )
  }
}
