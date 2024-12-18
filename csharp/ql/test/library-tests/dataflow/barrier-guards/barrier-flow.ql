/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.controlflow.Guards

private predicate stringConstCompare(Guard guard, Expr testedNode, AbstractValue value) {
  guard
      .isEquality(any(StringLiteral lit), testedNode,
        value.(AbstractValues::BooleanValue).getValue())
}

class StringConstCompareBarrier extends DataFlow::Node {
  StringConstCompareBarrier() {
    this = DataFlow::BarrierGuard<stringConstCompare/3>::getABarrierNode()
  }
}

import utils.test.InlineFlowTest
import PathGraph

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate isBarrier(DataFlow::Node n) { n instanceof StringConstCompareBarrier }
}

import ValueFlowTest<FlowConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
