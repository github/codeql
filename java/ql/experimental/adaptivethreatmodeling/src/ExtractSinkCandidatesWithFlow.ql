/**
 * Surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config, and are
 * therefore used as candidates for classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * TODO: Produce CSV/JSON/SARIF output describing these endpoints (probably just a URL for each endpoint).
 *
 * @name SQL database query built from user-controlled sources (experimental)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @id java/ml-powered/sql-injection
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
// private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm

// private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
// private import experimental.adaptivethreatmodeling.XssATM as XssAtm
// private import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
from DataFlow::PathNode sink
where exists(AtmConfig::AtmConfig queryConfig | queryConfig.isSinkCandidateWithFlow(sink))
select sink.getNode(), "SQL injection sink candidate"
