import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl
import utils.test.TranslateModels

query predicate localStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // Local flow steps that don't originate from a flow summary.
  RustDataFlow::simpleLocalFlowStep(nodeFrom, nodeTo, "")
}

query predicate storeStep = RustDataFlow::storeStep/3;

query predicate readStep = RustDataFlow::readStep/3;
