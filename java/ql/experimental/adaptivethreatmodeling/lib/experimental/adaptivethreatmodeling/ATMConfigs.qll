/**
 * For internal use only.
 *
 * Defines predicates that carry out checks over all queries that are currently supported.
 *
 * NOTE: Must import the query configurations of all queries that are supported by AI modeling.
 */

private import semmle.code.java.dataflow.TaintTracking
/* Configurations of supported queries */
import semmle.code.java.security.RequestForgeryConfig
import semmle.code.java.security.SqlInjectionQuery
import semmle.code.java.security.CommandLineQuery
import semmle.code.java.security.TaintedPathQuery

/**
 * Holds if `sanitizer` is a sanitizer for any of the supported queries.
 */
predicate isBarrier(DataFlow::Node sanitizer) {
  RequestForgeryConfig::isBarrier(sanitizer) or
  QueryInjectionFlowConfig::isBarrier(sanitizer) or
  RemoteUserInputToArgumentToExecFlowConfig::isBarrier(sanitizer) or
  TaintedPathConfig::isBarrier(sanitizer)
}

/**
 * Holds if `n1` to `n2` is an additional flow step for any of the supported queries.
 */
predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
  RequestForgeryConfig::isAdditionalFlowStep(n1, n2) or
  QueryInjectionFlowConfig::isAdditionalFlowStep(n1, n2) or
  RemoteUserInputToArgumentToExecFlowConfig::isAdditionalFlowStep(n1, n2) or
  TaintedPathConfig::isAdditionalFlowStep(n1, n2)
}
