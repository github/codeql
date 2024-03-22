import python
private import semmle.python.dataflow.new.DataFlow
import FindUses
// import EntryPointsForAll::EntryPointsForHardcodedCredentialsQuery
import EntryPointsForAll

// query predicate summaries(string madSummary) {
//   exists(
//     EntryPointsByQuery e, DataFlow::Node argument, string parameter, string functionName,
//     DataFlow::Node outNode, string alreadyModelled
//   |
//     e.entryPoint(argument, parameter, functionName, outNode, alreadyModelled, madSummary) and
//     alreadyModelled = "no"
//   )
// }
//
// predicate debug(
//   DataFlow::Node nodeFrom, DataFlow::Node nodeTo, FlowSummaryImpl::Public::SummarizedCallable sc
// ) {
//   FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, sc)
// }
// string fullyQualifiedName(DataFlow::Node def) {
//   exists(Module mod, string relevantName | ImportResolution::module_export(mod, relevantName, def) |
//     mod.isPackageInit() and
//     result = mod.getPackageName() + "." + relevantName
//     or
//     not mod.isPackageInit() and
//     result = mod.getName() + "." + relevantName
//   )
// }
from
  EntryPointsByQuery e, DataFlow::Node argument, string parameter, string functionName,
  DataFlow::Node outNode, string alreadyModeled, string madSummary
where
  e.entryPoint(argument, parameter, functionName, outNode, alreadyModeled, madSummary) and
  alreadyModeled = "no"
// select e, functionName
select e, argument, parameter, functionName, outNode, madSummary
// select parameter, functionName, madSummary
// select parameter, madSummary
