/*
 * ATMQuery.ql
 *
 * This test surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config,
 * and which codex predicts to in fact be sinks for the relevant sink type. It can be used to determine the alerts codex
 * will surface for each query.
 */

private import javascript as JS
import extraction.NoFeaturizationRestrictionsConfig
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.XssATM as XssAtm
private import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling::ATM::ResultsInfo as AtmResultsInfo

from
  AtmConfig::AtmConfig cfg, JS::DataFlow::PathNode source, JS::DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select cfg, cfg.getASinkEndpointType().getEncoding(), sink.getNode(), source.getNode(), score
