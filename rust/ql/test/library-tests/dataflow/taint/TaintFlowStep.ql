import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.TaintTrackingImpl

query predicate additionalTaintStep = RustTaintTracking::defaultAdditionalTaintStep/3;
