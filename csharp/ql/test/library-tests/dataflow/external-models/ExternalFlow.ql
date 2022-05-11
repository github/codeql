/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow
import DataFlow::PathGraph
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "My.Qltest;D;false;StepArgRes;(System.Object);;Argument[0];ReturnValue;taint",
        "My.Qltest;D;false;StepArgArg;(System.Object,System.Object);;Argument[0];Argument[1];taint",
        "My.Qltest;D;false;StepArgQual;(System.Object);;Argument[0];Argument[Qualifier];taint",
        "My.Qltest;D;false;StepFieldGetter;();;Argument[Qualifier].Field[My.Qltest.D.Field];ReturnValue;value",
        "My.Qltest;D;false;StepFieldSetter;(System.Object);;Argument[0];Argument[Qualifier].Field[My.Qltest.D.Field];value",
        "My.Qltest;D;false;StepFieldSetter;(System.Object);;Argument[Qualifier];ReturnValue.Field[My.Qltest.D.Field2];value",
        "My.Qltest;D;false;StepPropertyGetter;();;Argument[Qualifier].Property[My.Qltest.D.Property];ReturnValue;value",
        "My.Qltest;D;false;StepPropertySetter;(System.Object);;Argument[0];Argument[Qualifier].Property[My.Qltest.D.Property];value",
        "My.Qltest;D;false;StepElementGetter;();;Argument[Qualifier].Element;ReturnValue;value",
        "My.Qltest;D;false;StepElementSetter;(System.Object);;Argument[0];Argument[Qualifier].Element;value",
        "My.Qltest;D;false;Apply<,>;(System.Func<S,T>,S);;Argument[1];Argument[0].Parameter[0];value",
        "My.Qltest;D;false;Apply<,>;(System.Func<S,T>,S);;Argument[0].ReturnValue;ReturnValue;value",
        "My.Qltest;D;false;Apply2<>;(System.Action<S>,S,S);;Argument[1].Field[My.Qltest.D.Field];Argument[0].Parameter[0];value",
        "My.Qltest;D;false;Apply2<>;(System.Action<S>,S,S);;Argument[2].Field[My.Qltest.D.Field2];Argument[0].Parameter[0];value",
        "My.Qltest;D;false;Map<,>;(S[],System.Func<S,T>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "My.Qltest;D;false;Map<,>;(S[],System.Func<S,T>);;Argument[1].ReturnValue;ReturnValue.Element;value",
        "My.Qltest;D;false;Parse;(System.String,System.Int32);;Argument[0];Argument[1];taint",
        "My.Qltest;E;true;get_MyProp;();;Argument[Qualifier].Field[My.Qltest.E.MyField];ReturnValue;value",
        "My.Qltest;E;true;set_MyProp;(System.Object);;Argument[0];Argument[Qualifier].Field[My.Qltest.E.MyField];value",
        "My.Qltest;G;false;GeneratedFlow;(System.Object);;Argument[0];ReturnValue;generated:value",
        "My.Qltest;G;false;GeneratedFlowArgs;(System.Object,System.Object);;Argument[0];ReturnValue;generated:value",
        "My.Qltest;G;false;GeneratedFlowArgs;(System.Object,System.Object);;Argument[1];ReturnValue;generated:value",
        "My.Qltest;G;false;MixedFlowArgs;(System.Object,System.Object);;Argument[0];ReturnValue;generated:value",
        "My.Qltest;G;false;MixedFlowArgs;(System.Object,System.Object);;Argument[1];ReturnValue;value",
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

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
