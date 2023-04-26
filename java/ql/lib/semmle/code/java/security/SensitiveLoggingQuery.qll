/** Provides configurations for sensitive logging queries. */

import java
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import semmle.code.java.frameworks.android.Compose
import DataFlow

/** A variable that may hold sensitive information, judging by its name. */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch(getCommonSensitiveInfoRegex()) and
      not this instanceof CompileTimeConstantExpr
    )
  }
}

/** An instantiation of a (reflexive, transitive) subtype of `java.lang.reflect.Type`. */
private class TypeType extends RefType {
  pragma[nomagic]
  TypeType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.lang.reflect", "Type")
  }
}

/**
 * DEPRECATED: Use `SensitiveLoggerConfiguration` module instead.
 *
 * A data-flow configuration for identifying potentially-sensitive data flowing to a log output.
 */
deprecated class SensitiveLoggerConfiguration extends TaintTracking::Configuration {
  SensitiveLoggerConfiguration() { this = "SensitiveLoggerConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, "logging") }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer.asExpr() instanceof LiveLiteral or
    sanitizer.getType() instanceof PrimitiveType or
    sanitizer.getType() instanceof BoxedType or
    sanitizer.getType() instanceof NumberType or
    sanitizer.getType() instanceof TypeType
  }

  override predicate isSanitizerIn(Node node) { this.isSource(node) }
}

/** A data-flow configuration for identifying potentially-sensitive data flowing to a log output. */
module SensitiveLoggerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "logging") }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer.asExpr() instanceof LiveLiteral or
    sanitizer.getType() instanceof PrimitiveType or
    sanitizer.getType() instanceof BoxedType or
    sanitizer.getType() instanceof NumberType or
    sanitizer.getType() instanceof TypeType
  }

  predicate isBarrierIn(Node node) { isSource(node) }
}

module SensitiveLoggerFlow = TaintTracking::Global<SensitiveLoggerConfig>;
