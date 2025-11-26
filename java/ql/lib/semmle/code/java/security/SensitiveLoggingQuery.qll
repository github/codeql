/** Provides configurations for sensitive logging queries. */

import java
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import semmle.code.java.frameworks.android.Compose
private import semmle.code.java.security.Sanitizers
private import semmle.code.java.dataflow.RangeAnalysis

/** A data flow source node for sensitive logging sources. */
abstract class SensitiveLoggerSource extends DataFlow::Node { }

/** A data flow barrier node for sensitive logging sanitizers. */
abstract class SensitiveLoggerBarrier extends DataFlow::Node { }

/** A variable that may hold sensitive information, judging by its name. */
class VariableWithSensitiveName extends Variable {
  VariableWithSensitiveName() {
    exists(string name | name = this.getName() |
      name.regexpMatch(getCommonSensitiveInfoRegex()) and
      not name.regexpMatch(getCommonSensitiveInfoFPRegex())
    )
  }
}

/** A reference to a variable that may hold sensitive information, judging by its name. */
class CredentialExpr extends VarAccess {
  CredentialExpr() {
    this.getVariable() instanceof VariableWithSensitiveName and
    not this instanceof CompileTimeConstantExpr
  }
}

private class CredentialExprSource extends SensitiveLoggerSource {
  CredentialExprSource() { this.asExpr() instanceof CredentialExpr }
}

/** An instantiation of a (reflexive, transitive) subtype of `java.lang.reflect.Type`. */
private class TypeType extends RefType {
  pragma[nomagic]
  TypeType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.lang.reflect", "Type")
  }
}

/**
 * A sanitizer that may remove sensitive information from a string before logging.
 *
 * It allows for substring operations taking the first N (or last N, for Kotlin) characters, limited to 7 or fewer.
 */
private class PrefixSuffixBarrier extends SensitiveLoggerBarrier {
  PrefixSuffixBarrier() {
    exists(MethodCall mc, Method m, int limit |
      limit = 7 and
      mc.getMethod() = m
    |
      // substring in Java
      (
        m.hasQualifiedName("java.lang", "String", "substring") or
        m.hasQualifiedName("java.lang", "StringBuffer", "substring") or
        m.hasQualifiedName("java.lang", "StringBuilder", "substring")
      ) and
      (
        twoArgLimit(mc, limit, false) or
        singleArgLimit(mc, limit, false)
      ) and
      this.asExpr() = mc.getQualifier()
      or
      // Kotlin string operations, which use extension methods (so the string is the first argument)
      (
        m.hasQualifiedName("kotlin.text", "StringsKt", "substring") and
        (
          twoArgLimit(mc, limit, true) or
          singleArgLimit(mc, limit, true)
        )
        or
        m.hasQualifiedName("kotlin.text", "StringsKt", ["take", "takeLast"]) and
        singleArgLimit(mc, limit, true)
      ) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** A predicate to check single-argument method calls for a constant integer below a set limit. */
bindingset[limit, isKotlin]
private predicate singleArgLimit(MethodCall mc, int limit, boolean isKotlin) {
  mc.getNumArgument() = 1 and
  exists(int firstArgIndex, int delta |
    if isKotlin = true then firstArgIndex = 1 else firstArgIndex = 0
  |
    bounded(mc.getArgument(firstArgIndex), any(ZeroBound z), delta, true, _) and
    delta <= limit
  )
}

/** A predicate to check two-argument method calls for zero and a constant integer below a set limit. */
bindingset[limit, isKotlin]
private predicate twoArgLimit(MethodCall mc, int limit, boolean isKotlin) {
  mc.getNumArgument() = 2 and
  exists(int firstArgIndex, int secondArgIndex, int delta |
    isKotlin = true and firstArgIndex = 1 and secondArgIndex = 2
    or
    isKotlin = false and firstArgIndex = 0 and secondArgIndex = 1
  |
    // mc.getArgument(firstArgIndex).(CompileTimeConstantExpr).getIntValue() = 0 and
    bounded(mc.getArgument(firstArgIndex), any(ZeroBound z), 0, true, _) and
    bounded(mc.getArgument(firstArgIndex), any(ZeroBound z), 0, false, _) and
    bounded(mc.getArgument(secondArgIndex), any(ZeroBound z), delta, true, _) and
    delta <= limit
  )
}

private class DefaultSensitiveLoggerBarrier extends SensitiveLoggerBarrier {
  DefaultSensitiveLoggerBarrier() {
    this.asExpr() instanceof LiveLiteral or
    this instanceof SimpleTypeSanitizer or
    this.getType() instanceof TypeType
  }
}

/** A data-flow configuration for identifying potentially-sensitive data flowing to a log output. */
module SensitiveLoggerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SensitiveLoggerSource }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "log-injection") }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof SensitiveLoggerBarrier }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module SensitiveLoggerFlow = TaintTracking::Global<SensitiveLoggerConfig>;
