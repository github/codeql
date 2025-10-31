/** Provides configurations for sensitive logging queries. */

import java
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import semmle.code.java.frameworks.android.Compose
private import semmle.code.java.security.Sanitizers
import semmle.code.java.Constants

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

/** A sanitizer that may remove sensitive information from a string before logging.
 * 
 *  It allows for substring operations taking the first N (or last N, for Kotlin) characters, limited to 7 or fewer.
 */
private class SensitiveLoggerSanitizerCalled extends SensitiveLoggerBarrier {
  SensitiveLoggerSanitizerCalled() {
    exists(MethodCall mc, Method m, int limit |
      limit = 7 and
      mc.getMethod() = m and
      (
        // substring in Java
        (
          m.hasQualifiedName("java.lang", "String", "substring") or
          m.hasQualifiedName("java.lang", "StringBuffer", "substring") or
          m.hasQualifiedName("java.lang", "StringBuilder", "substring")
        ) and
        twoArgLimit(mc, limit, false) and
        this.asExpr() = mc.getQualifier()
        or
        // Kotlin string operations, which use extension methods (so the string is the first argument)
        (
          m.hasQualifiedName("kotlin.text", "StringsKt", "substring") and twoArgLimit(mc, limit, true)
          or
          m.hasQualifiedName("kotlin.text", "StringsKt", ["take", "takeLast"]) and
          singleArgLimit(mc, limit, true)
        ) and
        this.asExpr() = mc.getArgument(0)
      )
    )
  }
}

bindingset[limit, isKotlin]
predicate singleArgLimit(MethodCall mc, int limit, boolean isKotlin) {
  exists(int argIndex, int staticInt |
    (if isKotlin = true then argIndex = 1 else argIndex = 0) and
    (
      staticInt <= limit and
      staticInt > 0 and
      mc.getArgument(argIndex).getUnderlyingExpr().(CompileTimeConstantExpr).getIntValue() = staticInt
      or exists(CompileTimeConstantExpr cte, DataFlow::Node source, DataFlow::Node sink |
        source.asExpr() = cte and
        cte.getIntValue() = staticInt and
        sink.asExpr() = mc.getArgument(argIndex) and
        IntegerToArgFlow::flow(source, sink)
      )
    )
  )
}

bindingset[limit, isKotlin]
predicate twoArgLimit(MethodCall mc, int limit, boolean isKotlin) {
  exists(int firstArgIndex, int secondArgIndex, int staticInt |
    staticInt <= limit and
    staticInt > 0 and
    (
      (isKotlin = true and firstArgIndex = 1 and secondArgIndex = 2)
      or
      (isKotlin = false and firstArgIndex = 0 and secondArgIndex = 1)
    )
    and
    mc.getArgument(firstArgIndex).getUnderlyingExpr().(CompileTimeConstantExpr).getIntValue() = 0 and
    (
      mc.getArgument(secondArgIndex).getUnderlyingExpr().(CompileTimeConstantExpr).getIntValue() = staticInt
      or exists(CompileTimeConstantExpr cte, DataFlow::Node source, DataFlow::Node sink |
        source.asExpr() = cte and
        cte.getIntValue() = staticInt and
        sink.asExpr() = mc.getArgument(secondArgIndex) and
        IntegerToArgFlow::flow(source, sink)
      )
    )
  )
}

module IntegerToArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getUnderlyingExpr() instanceof CompileTimeConstantExpr and
    source.asExpr().getType() instanceof IntegralType and
    source.asExpr().(CompileTimeConstantExpr).getIntValue() > 0
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      sink.asExpr() = mc.getAnArgument()
      and sink.asExpr().getType() instanceof IntegralType
    )
  }

  predicate isBarrier(DataFlow::Node sanitizer) { none() }

  predicate isBarrierIn(DataFlow::Node node) { none() }
}

private class GenericSanitizer extends SensitiveLoggerBarrier {
  GenericSanitizer() {
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
module IntegerToArgFlow = TaintTracking::Global<IntegerToArgConfig>;
