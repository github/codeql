import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import CsvValidation
import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

private class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind;provenance",
        "My.Qltest;C;false;StepArgRes;(System.Object);;Argument[0];ReturnValue;taint;manual",
        "My.Qltest;C;false;StepArgArg;(System.Object,System.Object);;Argument[0];Argument[1];taint;manual",
        "My.Qltest;C;false;StepArgQual;(System.Object);;Argument[0];Argument[this];taint;manual",
        "My.Qltest;C;false;StepQualRes;();;Argument[this];ReturnValue;taint;manual",
        "My.Qltest;C;false;StepQualArg;(System.Object);;Argument[this];Argument[0];taint;manual",
        "My.Qltest;C;false;StepFieldGetter;();;Argument[this].Field[My.Qltest.C.Field];ReturnValue;value;manual",
        "My.Qltest;C;false;StepFieldSetter;(System.Int32);;Argument[0];Argument[this].Field[My.Qltest.C.Field];value;manual",
        "My.Qltest;C;false;StepPropertyGetter;();;Argument[this].Property[My.Qltest.C.Property];ReturnValue;value;manual",
        "My.Qltest;C;false;StepPropertySetter;(System.Int32);;Argument[0];Argument[this].Property[My.Qltest.C.Property];value;manual",
        "My.Qltest;C;false;StepElementGetter;();;Argument[this].Element;ReturnValue;value;manual",
        "My.Qltest;C;false;StepElementSetter;(System.Int32);;Argument[0];Argument[this].Element;value;manual",
        "My.Qltest;C+Generic<,>;false;StepGeneric;(T);;Argument[0];ReturnValue;value;manual",
        "My.Qltest;C+Generic<,>;false;StepGeneric2<>;(S);;Argument[0];ReturnValue;value;manual",
        "My.Qltest;C+Base<>;true;StepOverride;(T);;Argument[0];ReturnValue;value;manual"
      ]
  }
}

query predicate summaryThroughStep(
  DataFlow::Node node1, DataFlow::Node node2, boolean preservesValue
) {
  FlowSummaryImpl::Private::Steps::summaryThroughStepValue(node1, node2,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc)) and
  preservesValue = true
  or
  FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc)) and
  preservesValue = false
}

query predicate summaryGetterStep(DataFlow::Node arg, DataFlow::Node out, Content c) {
  FlowSummaryImpl::Private::Steps::summaryGetterStep(arg, c, out,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc))
}

query predicate summarySetterStep(DataFlow::Node arg, DataFlow::Node out, Content c) {
  FlowSummaryImpl::Private::Steps::summarySetterStep(arg, c, out,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc))
}
