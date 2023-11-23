import python
import semmle.python.dataflow.new.FlowSummary
import semmle.python.dataflow.new.internal.FlowSummaryImpl

from SummarizedCallable sc, string s, string c, string attr
where
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c) and
  c = "Attribute[" + attr + "]"
select "The attribute \"" + attr +
    "\" is not a valid TAttributeContent, please add it to the hardcoded list of TAttributeContent in the dataflow library."
