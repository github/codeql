/**
 * Provides classes and predicates for working with generator functions.
 */

import javascript
private import semmle.javascript.dataflow.internal.PreCallGraphStep

/**
 * Classes and predicates for modeling data-flow for generator functions.
 */
private module GeneratorDataFlow {
  private import DataFlow::PseudoProperties

  private class ArrayIteration extends LegacyPreCallGraphStep {
    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DataFlow::FunctionNode f | f.getFunction().isGenerator() |
        prop = iteratorElement() and
        exists(YieldExpr yield |
          yield.getContainer() = f.getFunction() and not yield.isDelegating()
        |
          pred.asExpr() = yield.getOperand()
        ) and
        succ = f.getReturnNode()
      )
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DataFlow::FunctionNode f | f.getFunction().isGenerator() |
        prop = iteratorElement() and
        exists(YieldExpr yield | yield.getContainer() = f.getFunction() and yield.isDelegating() |
          pred.asExpr() = yield.getOperand()
        ) and
        succ = f.getReturnNode()
      )
    }
  }
}
