/** Provides classes and predicates to reason about cleartext storage vulnerabilities. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SensitiveActions

/** A sink representing persistent storage that saves data in clear text. */
abstract class CleartextStorageSink extends DataFlow::Node {
  /**
   * Gets a location that will be selected in the diff-informed query where
   * this sink is found. If this has no results for any sink, that's taken to
   * mean the query is not diff-informed.
   */
  Location getASelectedLocation() { none() }
}

/** A sanitizer for flows tracking sensitive data being stored in persistent storage. */
abstract class CleartextStorageSanitizer extends DataFlow::Node { }

/** An additional taint step for sensitive data flowing into cleartext storage. */
class CleartextStorageAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/** Class for expressions that may represent 'sensitive' information */
class SensitiveSource extends Expr instanceof SensitiveExpr {
  /** Holds if this source flows to the `sink`. */
  predicate flowsTo(Expr sink) {
    SensitiveSourceFlow::flow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

/**
 *  Class representing entities that may be stored/written, with methods
 *  for finding values that are stored within them, and cases
 *  of the entity being stored.
 */
abstract class Storable extends Call {
  /** Gets an "input" that is stored in an instance of this class. */
  abstract Expr getAnInput();

  /** Gets an expression where an instance of this class is stored (e.g. to disk). */
  abstract Expr getAStore();
}

private module SensitiveSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) { sink instanceof CleartextStorageSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof CleartextStorageSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CleartextStorageAdditionalTaintStep c).step(n1, n2)
  }

  predicate observeDiffInformedIncrementalMode() {
    // This configuration is used by several queries. A query can opt in to
    // diff-informed mode by implementing `getASelectedLocation` on its sinks,
    // indicating that it has considered which sinks are selected.
    exists(CleartextStorageSink sink | exists(sink.getASelectedLocation()))
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(CleartextStorageSink).getASelectedLocation()
  }
}

private module SensitiveSourceFlow = TaintTracking::Global<SensitiveSourceFlowConfig>;

private class DefaultCleartextStorageSanitizer extends CleartextStorageSanitizer {
  DefaultCleartextStorageSanitizer() {
    this.getType() instanceof NumericType or
    this.getType() instanceof BooleanType or
    EncryptedValueFlow::flowTo(this)
  }
}

/**
 * Method call for encrypting sensitive information. As there are various implementations of
 * encryption (reversible and non-reversible) from both JDK and third parties, this class simply
 * checks method name to take a best guess to reduce false positives.
 */
private class EncryptedSensitiveMethodCall extends MethodCall {
  EncryptedSensitiveMethodCall() {
    this.getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%", "%digest%"])
  }
}

/** Flow configuration for encryption methods flowing to inputs of persistent storage. */
private module EncryptedValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof EncryptedSensitiveMethodCall }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SensitiveExpr }
}

private module EncryptedValueFlow = DataFlow::Global<EncryptedValueFlowConfig>;
