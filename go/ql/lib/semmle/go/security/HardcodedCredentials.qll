/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * hardcoded credentials, as well as extension points
 * for adding your own.
 */

import go
private import semmle.go.StringOps
private import semmle.go.dataflow.ExternalFlow
private import semmle.go.security.SensitiveActions

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * hardcoded credentials, as well as extension points
 * for adding your own.
 */
module HardcodedCredentials {
  /** A data flow source for hardcoded credentials. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for hardcoded credentials. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for hardcoded credentials. */
  abstract class Sanitizer extends DataFlow::Node { }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Tracks taint flow for reasoning about hardcoded credentials. */
  module Flow = TaintTracking::Global<Config>;

  /** A hardcoded string literal as a source for hardcoded credentials. */
  private class HardcodedStringSource extends Source {
    HardcodedStringSource() { this.asExpr() instanceof StringLit }
  }

  /** A use of a credential. */
  private class CredentialsSink extends Sink {
    CredentialsSink() { exists(string s | s.matches("credentials-%") | sinkNode(this, s)) }
  }

  /**
   * Holds if the guard `g` in its branch `branch` validates the expression `e`
   * by comparing it to a literal.
   */
  private predicate constantValueCheck(DataFlow::Node g, Expr e, boolean branch) {
    exists(Literal lit, DataFlow::EqualityTestNode eq | eq = g |
      eq.getAnOperand().asExpr() = e and
      eq.getAnOperand().asExpr() = lit and
      e != lit and
      branch = eq.getPolarity().booleanNot()
    )
  }

  /**
   * A value validated by comparing it to a constant value.
   * For example, in the context `if key != "invalid_key" { ... }`,
   * if `"invalid_key"` is indeed the only dangerous key then guarded uses of `key` are likely
   * to be safe.
   */
  private class CompareExprSanitizer extends Sanitizer {
    CompareExprSanitizer() {
      this = DataFlow::BarrierGuard<constantValueCheck/3>::getABarrierNode()
    }
  }

  /**
   * A value returned with an error.
   *
   * Typically this means contexts like `return "", errors.New("Oh no")`,
   * where we can be reasonably confident downstream users will not mistake
   * that empty string for a usable key.
   */
  private class ReturnedWithErrorSanitizer extends Sanitizer {
    ReturnedWithErrorSanitizer() { DataFlow::isReturnedWithError(this) }
  }

  /** The result of a formatting string call. */
  private class FormattingSanitizer extends Sanitizer {
    FormattingSanitizer() { any(StringOps::Formatting::StringFormatCall s).getAResult() = this }
  }

  private string getRandIntFunctionName() {
    result =
      [
        "ExpFloat64", "Float32", "Float64", "Int", "Int31", "Int31n", "Int63", "Int63n", "Intn",
        "NormFloat64", "Uint32", "Uint64"
      ]
  }

  private DataFlow::CallNode getARandIntCall() {
    exists(Function f | f = result.getTarget() |
      f.hasQualifiedName("math/rand", getRandIntFunctionName()) or
      f.(Method).hasQualifiedName("math/rand", "Rand", getRandIntFunctionName()) or
      f.hasQualifiedName("crypto/rand", "Int")
    )
  }

  private DataFlow::CallNode getARandReadCall() {
    result.getTarget().hasQualifiedName("crypto/rand", "Read")
  }

  /**
   * Holds if taint flows in one local step from `prev` to `succ`, or
   * through a binary operation such as a modulo `%` operation or an addition `+` operation.
   */
  private predicate localTaintStepIncludingBinaryExpr(DataFlow::Node prev, DataFlow::Node succ) {
    TaintTracking::localTaintStep(prev, succ)
    or
    exists(BinaryExpr b | b.getAnOperand() = prev.asExpr() | succ.asExpr() = b)
  }

  /** A read from a slice with a random index. */
  private class RandSliceSanitizer extends Sanitizer, DataFlow::ElementReadNode {
    RandSliceSanitizer() {
      exists(DataFlow::Node randomValue, DataFlow::Node index |
        randomValue = getARandIntCall().getAResult()
        or
        randomValue.(DataFlow::PostUpdateNode).getPreUpdateNode() =
          getARandReadCall().getArgument(0)
      |
        localTaintStepIncludingBinaryExpr*(randomValue, index) and
        this.reads(_, index)
      )
    }
  }
}
