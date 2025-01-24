import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.TaintTrackingImpl
import utils.test.TranslateModels

private predicate provenance(string model) {
  RustTaintTracking::defaultAdditionalTaintStep(_, _, model)
}

private module Tm = TranslateModels<provenance/1>;

query predicate models = Tm::models/2;

query predicate additionalTaintStep(DataFlow::Node pred, DataFlow::Node succ, string model) {
  exists(string madId |
    RustTaintTracking::defaultAdditionalTaintStep(pred, succ, madId) and
    Tm::translateModels(madId, model)
  )
}
