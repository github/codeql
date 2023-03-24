private import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.ApiGraphs

private class StepsFromModel extends ModelInput::SummaryModelCsv {
  override predicate row(string row) { none() }
}
