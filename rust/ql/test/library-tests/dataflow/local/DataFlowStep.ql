import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl
import utils.test.TranslateModels

private predicate provenance(string model) { RustDataFlow::simpleLocalFlowStep(_, _, model) }

private module Tm = TranslateModels<provenance/1>;

query predicate models = Tm::models/2;

query predicate localStep(Node nodeFrom, Node nodeTo, string model) {
  exists(string madId |
    RustDataFlow::simpleLocalFlowStep(nodeFrom, nodeTo, madId) and
    Tm::translateModels(madId, model)
  )
}

query predicate storeStep = RustDataFlow::storeStep/3;

query predicate readStep = RustDataFlow::readStep/3;
