/**
 * @name Use of constant `state` value in OAuth 2.0 URL.
 * @description Using a constant value for the `state` in the OAuth 2.0 URL makes the application
 *              susceptible to CSRF attacks.
 * @kind path-problem
 * @problem.severity error
 * @id go/constant-oauth2-state
 * @tags security
 *       external/cwe/cwe-352
 */

import go
import DataFlow::PathGraph

/**
 * A method that creates a new URL that will send the user
 * to the OAuth 2.0 authorization dialog of the provider.
 */
class AuthCodeURL extends Method {
  AuthCodeURL() { this.hasQualifiedName("golang.org/x/oauth2", "Config", "AuthCodeURL") }
}

/**
 * A flow of a constant string value to a call to AuthCodeURL as the
 * `state` parameter.
 */
class ConstantStateFlowConf extends DataFlow::Configuration {
  ConstantStateFlowConf() { this = "ConstantStateFlowConf" }

  predicate isSource(DataFlow::Node source, Literal state) {
    state.isConst() and source.asExpr() = state
  }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | sink = call.getArgument(0))
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/** A flow to a printer function of the fmt package. */
class FlowToPrint extends DataFlow::Configuration {
  FlowToPrint() { this = "FlowToPrint" }

  predicate isSource(DataFlow::Node source, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | source = call.getResult())
  }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(Fmt::Printer printer | call = printer.getACall() | sink = call.getArgument(_))
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/** Holds if the provided CallNode's result flows to a Printer call as argument. */
predicate flowsToPrinter(DataFlow::CallNode authCodeURLCall) {
  exists(FlowToPrint cfg, DataFlow::PathNode source, DataFlow::PathNode sink |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), authCodeURLCall)
  )
}

/**
 * Holds if the provided CallNode is within the same root as a call
 * to a scanner that reads from os.Stdin.
 */
predicate rootContainsCallToStdinScanner(DataFlow::CallNode authCodeURLCall) {
  exists(Fmt::ScannerCall scannerCall | scannerCall.getRoot() = authCodeURLCall.getRoot())
  or
  exists(Fmt::FScannerCall fScannerCall |
    fScannerCall.getReader() = any(ValueEntity v | v.hasQualifiedName("os", "Stdin")).getARead() and
    fScannerCall.getRoot() = authCodeURLCall.getRoot()
  )
}

from
  ConstantStateFlowConf cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::CallNode sinkCall
where
  cfg.hasFlowPath(source, sink) and
  cfg.isSink(sink.getNode(), sinkCall) and
  // Exclude cases that seem to be oauth flows done from within a terminal:
  not (
    flowsToPrinter(sinkCall) and
    rootContainsCallToStdinScanner(sinkCall)
  )
select sink.getNode(), source, sink, "Using a constant $@ to create oauth2 URLs.", source.getNode(),
  "state string"
