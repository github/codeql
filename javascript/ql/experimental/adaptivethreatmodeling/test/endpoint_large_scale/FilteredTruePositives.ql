/*
 * FilteredTruePositives.ql
 *
 * This test checks several components of the endpoint filters for each query to see whether they
 * filter out any known sinks. It explicitly does not check the endpoint filtering step that's based
 * on whether the endpoint is an argument to a modeled function, since this necessarily filters out
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
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
import experimental.adaptivethreatmodeling.XssATM as XssAtm
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
import experimental.adaptivethreatmodeling.ShellCommandInjectionFromEnvironmentATM as ShellCommandInjectionFromEnvironmentAtm

query predicate nosqlFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof NosqlInjection::Sink and
  reason = any(NosqlInjectionAtm::NosqlInjectionAtmConfig cfg).getAReasonSinkExcluded(endpoint) and
  not reason = ["argument to modeled function", "modeled sink", "modeled database access"]
}

query predicate sqlFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof SqlInjection::Sink and
  reason = any(SqlInjectionAtm::SqlInjectionAtmConfig cfg).getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate taintedPathFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof TaintedPath::Sink and
  reason = any(TaintedPathAtm::TaintedPathAtmConfig cfg).getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate xssFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof DomBasedXss::Sink and
  reason = any(XssAtm::DomBasedXssAtmConfig cfg).getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate xssThroughDomFilteredTruePositives(DataFlow::Node endpoint, string reason) {
  endpoint instanceof DomBasedXss::Sink and
  reason = any(XssThroughDomAtm::XssThroughDomAtmConfig cfg).getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}

query predicate shellCommandInjectionFromEnvironmentAtmFilteredTruePositives(
  DataFlow::Node endpoint, string reason
) {
  endpoint instanceof ShellCommandInjectionFromEnvironment::Sink and
  reason =
    any(ShellCommandInjectionFromEnvironmentAtm::ShellCommandInjectionFromEnvironmentAtmConfig cfg)
        .getAReasonSinkExcluded(endpoint) and
  reason != "argument to modeled function"
}
