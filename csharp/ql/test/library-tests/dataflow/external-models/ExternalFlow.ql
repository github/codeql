/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph
import semmle.code.csharp.dataflow.ExternalFlow
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind;provenance",
        "My.Qltest;D;false;StepArgRes;(System.Object);;Argument[0];ReturnValue;taint;manual",
        "My.Qltest;D;false;StepArgArg;(System.Object,System.Object);;Argument[0];Argument[1];taint;manual",
        "My.Qltest;D;false;StepArgQual;(System.Object);;Argument[0];Argument[this];taint;manual",
        "My.Qltest;D;false;StepFieldGetter;();;Argument[this].Field[My.Qltest.D.Field];ReturnValue;value;manual",
        "My.Qltest;D;false;StepFieldSetter;(System.Object);;Argument[0];Argument[this].Field[My.Qltest.D.Field];value;manual",
        "My.Qltest;D;false;StepFieldSetter;(System.Object);;Argument[this];ReturnValue.Field[My.Qltest.D.Field2];value;manual",
        "My.Qltest;D;false;StepPropertyGetter;();;Argument[this].Property[My.Qltest.D.Property];ReturnValue;value;manual",
        "My.Qltest;D;false;StepPropertySetter;(System.Object);;Argument[0];Argument[this].Property[My.Qltest.D.Property];value;manual",
        "My.Qltest;D;false;StepElementGetter;();;Argument[this].Element;ReturnValue;value;manual",
        "My.Qltest;D;false;StepElementSetter;(System.Object);;Argument[0];Argument[this].Element;value;manual",
        "My.Qltest;D;false;Apply<,>;(System.Func<S,T>,S);;Argument[1];Argument[0].Parameter[0];value;manual",
        "My.Qltest;D;false;Apply<,>;(System.Func<S,T>,S);;Argument[0].ReturnValue;ReturnValue;value;manual",
        "My.Qltest;D;false;Apply2<>;(System.Action<S>,S,S);;Argument[1].Field[My.Qltest.D.Field];Argument[0].Parameter[0];value;manual",
        "My.Qltest;D;false;Apply2<>;(System.Action<S>,S,S);;Argument[2].Field[My.Qltest.D.Field2];Argument[0].Parameter[0];value;manual",
        "My.Qltest;D;false;Map<,>;(S[],System.Func<S,T>);;Argument[0].Element;Argument[1].Parameter[0];value;manual",
        "My.Qltest;D;false;Map<,>;(S[],System.Func<S,T>);;Argument[1].ReturnValue;ReturnValue.Element;value;manual",
        "My.Qltest;D;false;Parse;(System.String,System.Int32);;Argument[0];Argument[1];taint;manual",
        "My.Qltest;D;false;Reverse;(System.Object[]);;Argument[0].WithElement;ReturnValue;value;manual",
        "My.Qltest;E;true;get_MyProp;();;Argument[this].Field[My.Qltest.E.MyField];ReturnValue;value;manual",
        "My.Qltest;E;true;set_MyProp;(System.Object);;Argument[0];Argument[this].Field[My.Qltest.E.MyField];value;manual",
        "My.Qltest;G;false;GeneratedFlow;(System.Object);;Argument[0];ReturnValue;value;generated",
        "My.Qltest;G;false;GeneratedFlowArgs;(System.Object,System.Object);;Argument[0];ReturnValue;value;generated",
        "My.Qltest;G;false;GeneratedFlowArgs;(System.Object,System.Object);;Argument[1];ReturnValue;value;generated",
        "My.Qltest;G;false;MixedFlowArgs;(System.Object,System.Object);;Argument[0];ReturnValue;value;generated",
        "My.Qltest;G;false;MixedFlowArgs;(System.Object,System.Object);;Argument[1];ReturnValue;value;manual",
      ]
  }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "ExternalFlow" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

/**
 * Simulate that methods with summaries are not included in the source code.
 * This is relevant for dataflow analysis using summaries tagged as generated.
 */
private class MyMethod extends Method {
  override predicate fromSource() { none() }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
