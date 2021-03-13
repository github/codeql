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
import StrictPredictableRandomTaintTracker
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

class PredictableRandomConfig extends StrictPredictableRandomConfig {
  PredictableRandomConfig() { this = "PredictableRandomConfig" }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SecureContextSink }
}

from DataFlow2::PathNode source, DataFlow2::PathNode sink, PredictableRandomConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially predictably generated random value"
