/**
 * @name Predictable Random Number Generation in Sensitive Location
 * @description The use of predictable random number generation in a security sensitive location can
 *              can leave an application vulnerable to account takeover as future random values can
 *              be preditcted or computed by knowing any previous value.
 * @kind path-problem
 * @precision medium
 * @problem.severity error
 * @id java/predictable-random-number-generation
 * @tags security
 *       external/cwe/cwe-338
 *       external/cwe/cwe-330
 */

import java
import types
import utilities
import PredictableRandomNumberGeneratorSource
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

abstract class SecureContextSink extends DataFlow::Node { }

private class SensitiveVariable extends Variable {
  SensitiveVariable() { isSensitiveName(this.getName().toLowerCase()) }
}

private class SensitiveMethod extends Method {
  SensitiveMethod() { isSensitiveName(this.getName().toLowerCase()) }
}

/**
 * Assignment to a variable with a name that indicates the data is potentially sensitive.
 */
private class SensitiveVariableSink extends SecureContextSink {
  SensitiveVariableSink() {
    exists(VariableAssign va |
      va.getDestVar() instanceof SensitiveVariable and va.getSource() = this.asExpr()
    )
  }
}

/**
 * Insecure RNG leaks into the context of a method with potentially senisitve behaviour.
 */
private class SensitiveMethodSink extends SecureContextSink {
  SensitiveMethodSink() { this.getEnclosingCallable() instanceof SensitiveMethod }
}

class PredictableRandomConfig extends TaintTracking::Configuration {
  PredictableRandomConfig() { this = "PredictableRandomConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof PredictableRandomFlowSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SecureContextSink }

  private predicate testSanitizer(DataFlow::Node node) {
    // TODO: Don't merge with this
    // Helps get test logic out of the results
    node.asExpr().getFile().getAbsolutePath().toLowerCase().matches("%test%")
  }

  override predicate isSanitizerOut(DataFlow::Node node) { testSanitizer(node) }

  override predicate isSanitizerIn(DataFlow::Node node) { testSanitizer(node) }

  /**
   * A char array that holds pre-aproved characters but the elements from that
   * char array are selected with a random number generator that is insecure.
   *
   * Example:
   * ```
   * Random RANDOM = new Random()
   * char[] CHARS = "abcdefghijklmnopqrstuvwxyz".toCharArray();
   * // Insecurely chosen
   * char c = CHARS[RANDOM.nextInt(CHARS.length)];
   * ```
   */
  private predicate isTaintedCharArrayAccess(Expr expSource, Expr expDest) {
    exists(ArrayAccess aa, Array a, CharacterType charType |
      a.getComponentType() = charType and
      aa.getArray().(VarAccess).getVariable().getType() = a and
      aa.getIndexExpr() = expSource and
      aa = expDest
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isTaintedUuidCreation(node1.asExpr(), node2.asExpr()) or
    isTaintedCharArrayAccess(node1.asExpr(), node2.asExpr())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, PredictableRandomConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially predictably generated random value"
