/**
 * @name Use of constant `state` value in OAuth 2.0 URL
 * @description Using a constant value for the `state` in the OAuth 2.0 URL makes the application
 *              susceptible to CSRF attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
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
  AuthCodeURL() {
    this.hasQualifiedName(package("golang.org/x/oauth2", ""), "Config", "AuthCodeURL")
  }
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
    source.isConst() and
    not DataFlow::isReturnedWithError(source) and
    // Avoid duplicate paths by not considering reads from constants as sources themselves:
    (
      source.asExpr() instanceof StringLit
      or
      source.asExpr() instanceof AddExpr
    )
  }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }
}

/**
 * Holds if `pred` writes a URL to the `RedirectURL` field of the `succ` `Config` object.
 *
 * This propagates flow from the RedirectURL field to the whole Config object.
 */
predicate isUrlTaintingConfigStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Write w, Field f |
    f.hasQualifiedName(package("golang.org/x/oauth2", ""), "Config", "RedirectURL")
  |
    w.writesField(succ.(DataFlow::PostUpdateNode).getPreUpdateNode(), f, pred)
  )
}

/**
 * Gets a URL or pseudo-URL that suggests an out-of-band OAuth2 flow or use of a transient
 * local listener to receive an OAuth2 redirect.
 */
bindingset[result]
string getAnOobOauth2Url() {
  // The following are pseudo-URLs seen in the wild to indicate the authenticating site
  // should display a code for the user to manually convey, rather than directing:
  result in ["urn:ietf:wg:oauth:2.0:oob", "urn:ietf:wg:oauth:2.0:oob:auto", "oob", "code"] or
  // Alternatively some non-web tools will create a temporary local webserver to handle the
  // OAuth2 redirect:
  result.matches("%://localhost%") or
  result.matches("%://127.0.0.1%")
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
    source.getStringValue() = getAnOobOauth2Url() and
    // Avoid duplicate paths by excluding constant variable references from
    // themselves being sources:
    (
      source.asExpr() instanceof StringLit
      or
      source.asExpr() instanceof AddExpr
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
    any(Fmt::Sprinter s).taintStep(pred, succ)
  }

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeURL m | call = m.getACall() | sink = call.getReceiver())
  }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }
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

  predicate isSink(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(LoggerCall logCall | call = logCall | sink = logCall.getAMessageComponent())
  }

  override predicate isSource(DataFlow::Node source) {
    source = any(AuthCodeURL m).getACall().getResult()
  }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }
}

/** Holds if the provided `CallNode`'s result flows to an argument of a printer call. */
predicate resultFlowsToPrinter(DataFlow::CallNode authCodeURLCall) {
  exists(FlowToPrint cfg, DataFlow::PathNode source, DataFlow::PathNode sink |
    cfg.hasFlowPath(source, sink) and
    authCodeURLCall.getResult() = source.getNode()
  )
}

/** Get a data-flow node that reads the value of `os.Stdin`. */
DataFlow::Node getAStdinNode() {
  exists(ValueEntity v |
    v.hasQualifiedName("os", "Stdin") and result = globalValueNumber(v.getARead()).getANode()
  )
}

/**
 * Gets a call to a scanner function that reads from `os.Stdin`, or which creates a scanner
 * instance wrapping `os.Stdin`.
 */
DataFlow::CallNode getAScannerCall() {
  result = any(Fmt::Scanner f).getACall()
  or
  exists(Fmt::FScanner f |
    result = f.getACall() and f.getReader().getNode(result) = getAStdinNode()
  )
  or
  exists(Bufio::NewScanner f |
    result = f.getACall() and f.getReader().getNode(result) = getAStdinNode()
  )
}

/**
 * Holds if the provided `CallNode` is within the same root as a call
 * to a scanner that reads from `os.Stdin`.
 */
predicate containsCallToStdinScanner(FuncDef funcDef) { getAScannerCall().getRoot() = funcDef }

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
