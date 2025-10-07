import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
deprecated import utils.test.LegacyDataFlowDiff

deprecated query predicate legacyDataFlowDifference =
  DataFlowDiff<DomBasedXssFlow, Configuration>::legacyDataFlowDifference/3;

query predicate flow = DomBasedXssFlow::flow/2;
