/**
 * @kind path-problem
 */

import rust
import utils.InlineFlowTest
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.FlowSummary
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.FlowSummaryImpl
import PathGraph

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

private class SummarizedCallableIdentity extends SummarizedCallable::Range {
  SummarizedCallableIdentity() { this = "repo::test::_::crate::identity" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableGetVarPos extends SummarizedCallable::Range {
  SummarizedCallableGetVarPos() { this = "repo::test::_::crate::get_var_pos" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0].Variant[crate::MyPosEnum::A(0)]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableSetVarPos extends SummarizedCallable::Range {
  SummarizedCallableSetVarPos() { this = "repo::test::_::crate::set_var_pos" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue.Variant[crate::MyPosEnum::B(0)]" and
    preservesValue = true
  }
}

private class SummarizedCallableGetVarField extends SummarizedCallable::Range {
  SummarizedCallableGetVarField() { this = "repo::test::_::crate::get_var_field" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0].Variant[crate::MyFieldEnum::C::field_c]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableSetVarField extends SummarizedCallable::Range {
  SummarizedCallableSetVarField() { this = "repo::test::_::crate::set_var_field" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue.Variant[crate::MyFieldEnum::D::field_d]" and
    preservesValue = true
  }
}

module CustomConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import ValueFlowTest<CustomConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
