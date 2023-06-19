private import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.ApiGraphs

private class StepsFromModel extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "Foo;Member[MS_identity];Argument[0];ReturnValue;value",
        "Foo;Member[MS_apply_lambda];Argument[1];Argument[0].Parameter[0];value",
        "Foo;Member[MS_apply_lambda];Argument[0].ReturnValue;ReturnValue;value",
        "Foo;Member[MS_reversed];Argument[0];ReturnValue;taint",
        "Foo;Member[MS_list_map];Argument[1];ReturnValue;taint",
        "Foo;Member[MS_append_to_list];Argument[0];ReturnValue;taint",
        "json;Member[MS_loads];Argument[0];ReturnValue;taint"
      ]
  }
}
