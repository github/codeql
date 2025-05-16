import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
deprecated import utils.test.LegacyDataFlowDiff

query predicate flow = DomBasedXssFlow::flow/2;
