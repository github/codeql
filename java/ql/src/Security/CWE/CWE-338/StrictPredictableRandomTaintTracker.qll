import java
import types
import utilities
import PredictableRandomNumberGeneratorSource
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

abstract class StrictPredictableRandomConfig extends TaintTracking2::Configuration {
  StrictPredictableRandomConfig() { this = "StrictPredictableRandomConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JavaStdlibInsecureRandomTypeKnownCreation
  }

  private predicate testSanitizer(DataFlow::Node node) {
    // TODO: Don't merge with this
    // Helps get test logic out of the results
    node.asExpr().getFile().getAbsolutePath().toLowerCase().matches("%test%")
  }

  override predicate isSanitizerOut(DataFlow::Node node) { testSanitizer(node) }

  override predicate isSanitizerIn(DataFlow::Node node) { testSanitizer(node) }

  private predicate isTaintedRandomMethodCall(Expr expSource, Expr expDest) {
    exists(PredictableJavaStdlibRandomMethodAcccess ma |
      ma.getMethod().hasName("nextBytes") and
      ma.getArgument(0) = expDest and
      ma.getQualifier() = expSource
      or
      ma.getQualifier() = expSource and ma = expDest
    )
  }

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
    isTaintedCharArrayAccess(node1.asExpr(), node2.asExpr()) or
    isTaintedRandomMethodCall(node1.asExpr(), node2.asExpr())
  }
}

class StrictPredictableToAnyRandomConfig extends StrictPredictableRandomConfig {
  StrictPredictableToAnyRandomConfig() { this = "StrictPredictableToAnyRandomConfig" }

  override predicate isSink(DataFlow::Node source) { any() }
}
