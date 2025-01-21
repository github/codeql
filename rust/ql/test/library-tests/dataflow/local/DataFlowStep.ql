import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl

query predicate localStep = DataFlow::localFlowStep/2;

query predicate storeStep = RustDataFlow::storeStep/3;

query predicate readStep = RustDataFlow::readStep/3;
