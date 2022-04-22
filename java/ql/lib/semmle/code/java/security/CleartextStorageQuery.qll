/** Provides classes and predicates to reason about cleartext storage vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow4
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.TaintTracking2
private import semmle.code.java.security.SensitiveActions

/** A sink representing persistent storage that saves data in clear text. */
abstract class CleartextStorageSink extends DataFlow::Node { }

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
    exists(SensitiveSourceFlowConfig conf |
      conf.hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
    )
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

private class SensitiveSourceFlowConfig extends TaintTracking2::Configuration {
  SensitiveSourceFlowConfig() { this = "SensitiveSourceFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CleartextStorageSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof CleartextStorageSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CleartextStorageAdditionalTaintStep c).step(n1, n2)
  }
}

private class DefaultCleartextStorageSanitizer extends CleartextStorageSanitizer {
  DefaultCleartextStorageSanitizer() {
    this.getType() instanceof NumericType or
    this.getType() instanceof BooleanType or
    exists(EncryptedValueFlowConfig conf | conf.hasFlow(_, this))
  }
}

/**
 * Method call for encrypting sensitive information. As there are various implementations of
 * encryption (reversible and non-reversible) from both JDK and third parties, this class simply
 * checks method name to take a best guess to reduce false positives.
 */
private class EncryptedSensitiveMethodAccess extends MethodAccess {
  EncryptedSensitiveMethodAccess() {
    this.getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%", "%digest%"])
  }
}

/** Flow configuration for encryption methods flowing to inputs of persistent storage. */
private class EncryptedValueFlowConfig extends DataFlow4::Configuration {
  EncryptedValueFlowConfig() { this = "EncryptedValueFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof EncryptedSensitiveMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SensitiveExpr }
}

/** A taint step for `EditText.toString` in Android. */
private class AndroidEditTextCleartextStorageStep extends CleartextStorageAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    // EditText.getText() return type is parsed as `Object`, so we need to
    // add a taint step for `Object.toString` to model `editText.getText().toString()`
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeObject and
      m.hasName("toString")
    |
      n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma
    )
  }
}
