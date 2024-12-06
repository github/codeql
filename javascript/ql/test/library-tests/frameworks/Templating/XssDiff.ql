import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
deprecated import testUtilities.LegacyDataFlowDiff

deprecated query predicate legacyDataFlowDifference =
  DataFlowDiff<DomBasedXssFlow, Configuration>::legacyDataFlowDifference/3;

query predicate flow = DomBasedXssFlow::flow/2;
