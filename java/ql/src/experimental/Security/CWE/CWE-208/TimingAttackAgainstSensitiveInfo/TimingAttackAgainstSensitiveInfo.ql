/**
 * @name Timing attack against sensitive info
 * @description Use of a non-constant-time verification routine to check the value of an sensitive info,
 *              possibly allowing a timing attack to infer the info's expected value.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-sensitive-info
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** A string for `match` that identifies strings that look like they represent secret data. */
private string suspicious() {
  result =
    [
      "%password%", "%passwd%", "%pwd%", "%refresh%token%", "%secret%token", "%secret%key",
      "%passcode%", "%passphrase%", "%token%", "%secret%", "%credential%", "%UserPass%"
    ]
}

/** A variable that may hold sensitive information, judging by its name. * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().toLowerCase().matches(suspicious()) and
      not v.isFinal()
    )
  }
}

/**
 * A configuration that tracks data flow from variable that may hold sensitive data
 * to methods that compare data using a non-constant-time algorithm.
 */
class NonConstantTimeComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeComparisonConfig() { this = "NonConstantTimeComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible timing attack against $@ validation.",
  source.getNode(), "time constant"
