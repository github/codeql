/**
 * @name Use of constant `state` value in OAuth 2.0 URL
 * @description Using a constant value for the `state` in the OAuth 2.0 URL makes the application
 *              susceptible to CSRF attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
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
 * A flow of a constant string value to a call to `AuthCodeURL` as the
 * `state` parameter.
 */
class ConstantStateFlowConf extends DataFlow::Configuration {
  ConstantStateFlowConf() { this = "ConstantStateFlowConf" }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | sink = call.getArgument(0))
  }

  override predicate isSource(DataFlow::Node source) {
    source.isConst() and not DataFlow::isReturnedWithError(source)
  }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/**
 * A flow of a URL indicating the OAuth redirect doesn't point to a publicly
 * accessible address, to the receiver of an `AuthCodeURL` call.
 *
 * Note we accept localhost and 127.0.0.1 on the assumption this is probably a transient
 * listener; if it actually is a persistent server then that really is vulnerable to CSRF.
 */
class PrivateUrlFlowsToAuthCodeUrlCall extends DataFlow::Configuration {
  PrivateUrlFlowsToAuthCodeUrlCall() { this = "PrivateUrlFlowsToConfig" }

  override predicate isSource(DataFlow::Node source) {
    // The following are all common ways to indicate out-of-band OAuth2 flow, in which case
    // the authenticating party does not redirect but presents a code for the user to copy
    // instead.
    source.asExpr().(StringLit).getValue() in ["urn:ietf:wg:oauth:2.0:oob",
          "urn:ietf:wg:oauth:2.0:oob:auto", "oob", "code"] or
    // Alternatively some non-web tools will create a temporary local webserver to handle the
    // OAuth2 redirect:
    source.asExpr().(StringLit).getValue().matches("%://localhost%") or
    source.asExpr().(StringLit).getValue().matches("%://127.0.0.1%")
  }

  /**
   * Holds if `pred` writes a URL to the `RedirectURL` field of the `succ` `Config` object.
   *
   * This propagates flow from the RedirectURL field to the whole Config object.
   */
  predicate isUrlTaintingConfigStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Write w, Field f | f.hasQualifiedName("golang.org/x/oauth2", "Config", "RedirectURL") |
      w.writesField(succ.(DataFlow::PostUpdateNode).getPreUpdateNode(), f, pred)
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Propagate from a RedirectURL field to a whole Config
    isUrlTaintingConfigStep(pred, succ)
    or
    // Propagate across deref and address-taking steps
    TaintTracking::referenceStep(pred, succ)
    or
    // Propagate across Sprintf and similar calls
    exists(DataFlow::CallNode c |
      c = any(Fmt::Sprinter s).getACall() and
      pred = c.getAnArgument() and
      succ = c.getResult()
    )
  }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | sink = call.getReceiver())
  }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/**
 * Holds if a URL indicating the OAuth redirect doesn't point to a publicly
 * accessible address, to the receiver of an `AuthCodeURL` call.
 *
 * Note we accept localhost and 127.0.0.1 on the assumption this is probably a transient
 * listener; if it actually is a persistent server then that really is vulnerable to CSRF.
 */
predicate privateUrlFlowsToAuthCodeUrlCall(DataFlow::CallNode call) {
  exists(PrivateUrlFlowsToAuthCodeUrlCall flowConfig, DataFlow::Node receiver |
    flowConfig.hasFlowTo(receiver) and
    flowConfig.isSink(receiver, call)
  )
}

/** A flow from `golang.org/x/oauth2.Config.AuthCodeURL`'s result to a logging function. */
class FlowToPrint extends DataFlow::Configuration {
  FlowToPrint() { this = "FlowToPrint" }

  predicate isSource(DataFlow::Node source, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | source = call.getResult())
  }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(Fmt::Printer printer | call = printer.getACall() | sink = call.getArgument(_))
    or
    exists(LoggerCall logCall | call = logCall | sink = logCall.getAMessageComponent())
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/** Holds if the provided `CallNode`'s result flows to an argument of a printer call. */
predicate resultFlowsToPrinter(DataFlow::CallNode authCodeURLCall) {
  exists(FlowToPrint cfg, DataFlow::PathNode source, DataFlow::PathNode sink |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), authCodeURLCall)
  )
}

/** Get a data-flow node that reads the value of `os.Stdin`. */
DataFlow::Node getAStdinNode() {
  result = any(ValueEntity v | v.hasQualifiedName("os", "Stdin")).getARead()
}

/**
 * Gets a call to a scanner function that reads from `os.Stdin`, or which creates a scanner
 * instance wrapping `os.Stdin`.
 */
DataFlow::CallNode getAScannerCall() {
  result instanceof Fmt::ScannerCall or
  result.(Fmt::FScannerCall).getReader() = getAStdinNode() or
  result.(Bufio::NewScannerCall).getReader() = getAStdinNode()
}

/**
 * Holds if the provided `CallNode` is within the same root as a call
 * to a scanner that reads from `os.Stdin`.
 */
predicate containsCallToStdinScanner(FuncDef funcDef) {
  exists(DataFlow::CallNode call | call = getAScannerCall() | call.getRoot() = funcDef)
}

/**
 * Holds if the `authCodeURLCall` seems to be done within a terminal
 * because there are calls to a printer (`fmt.Println` and similar),
 * and a call to a scanner (`fmt.Scan` and similar),
 * all of which are typically done within a terminal session.
 */
predicate seemsLikeDoneWithinATerminal(DataFlow::CallNode authCodeURLCall) {
  resultFlowsToPrinter(authCodeURLCall) and
  containsCallToStdinScanner(authCodeURLCall.getRoot())
}

from
  ConstantStateFlowConf cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::CallNode sinkCall
where
  cfg.hasFlowPath(source, sink) and
  cfg.isSink(sink.getNode(), sinkCall) and
  // Exclude cases that seem to be oauth flows done from within a terminal:
  not seemsLikeDoneWithinATerminal(sinkCall) and
  not privateUrlFlowsToAuthCodeUrlCall(sinkCall)
select sink.getNode(), source, sink, "Using a constant $@ to create oauth2 URLs.", source.getNode(),
  "state string"
