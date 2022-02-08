/*
 * FilteredTruePositives.ql
 *
 * This test checks several components of the endpoint filters for each query to see whether they
 * filter out any known sinks. It explicitly does not check the endpoint filtering step that's based
 * on whether the endpoint is an argument to a modelled function, since this necessarily filters out
 * all known sinks. However, we can test all the other filtering steps against the set of known
 * sinks.
 *
 * Ideally, the sink endpoint filters would have perfect recall and therefore each of the predicates
 * in this test would have zero results. However, in some cases we have chosen to sacrifice recall
 * when we perceive the improved precision of the results to be worth the drop in recall.
 */

import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import experimental.adaptivethreatmodeling.StandardEndpointFilters as StandardEndpointFilters
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM

query predicate nosqlFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof NosqlInjection::Sink and
  reason = NosqlInjectionATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint) and
  not reason = ["argument to modeled function", "modeled sink", "modeled database access"]
}

query predicate sqlFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof SqlInjection::Sink and
  reason = SqlInjectionATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate taintedPathFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof TaintedPath::Sink and
  reason = TaintedPathATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate xssFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof DomBasedXss::Sink and
  reason = XssATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}
