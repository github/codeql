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

/**
 * A method that creates a new URL that will send the user
 * to the OAuth 2.0 authorization dialog of the provider.
 */
class AuthCodeUrl extends Method {
  AuthCodeUrl() {
    this.hasQualifiedName(package("golang.org/x/oauth2", ""), "Config", "AuthCodeURL")
  }
}

module ConstantStateFlowConfig implements DataFlow::ConfigSig {
  additional predicate isSinkCall(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeUrl m | call = m.getACall() | sink = call.getArgument(0))
  }

  predicate isSource(DataFlow::Node source) {
    source.isConst() and
    not DataFlow::isReturnedWithError(source) and
    // Avoid duplicate paths by not considering reads from constants as sources themselves:
    (
      source.asExpr() instanceof StringLit
      or
      source.asExpr() instanceof AddExpr
    )
  }

  predicate isSink(DataFlow::Node sink) { isSinkCall(sink, _) }
}

/**
 * Tracks data flow of a constant string value to a call to `AuthCodeURL` as
 * the `state` parameter.
 */
module Flow = DataFlow::Global<ConstantStateFlowConfig>;

import Flow::PathGraph

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

module PrivateUrlFlowsToAuthCodeUrlCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getStringValue() = getAnOobOauth2Url() and
    // Avoid duplicate paths by excluding constant variable references from
    // themselves being sources:
    (
      source.asExpr() instanceof StringLit
      or
      source.asExpr() instanceof AddExpr
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Propagate from a RedirectURL field to a whole Config
    isUrlTaintingConfigStep(pred, succ)
    or
    // Propagate across deref and address-taking steps
    TaintTracking::referenceStep(pred, succ)
    or
    // Propagate across Sprintf and similar calls
    exists(DataFlow::CallNode cn |
      cn.getACalleeIncludingExternals().asFunction() instanceof Fmt::AppenderOrSprinterFunc
    |
      pred = cn.getASyntacticArgument() and succ = cn.getResult()
    )
  }

  additional predicate isSinkCall(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(AuthCodeUrl m | call = m.getACall() | sink = call.getReceiver())
  }

  predicate isSink(DataFlow::Node sink) { isSinkCall(sink, _) }
}

/**
 * Tracks data flow from a URL indicating the OAuth redirect doesn't point to a publicly
 * accessible address to the receiver of an `AuthCodeURL` call.
 *
 * Note we accept localhost and 127.0.0.1 on the assumption this is probably a transient
 * listener; if it actually is a persistent server then that really is vulnerable to CSRF.
 */
module PrivateUrlFlowsToAuthCodeUrlCallFlow =
  DataFlow::Global<PrivateUrlFlowsToAuthCodeUrlCallConfig>;

/**
 * Holds if a URL indicating the OAuth redirect doesn't point to a publicly
 * accessible address, to the receiver of an `AuthCodeURL` call.
 *
 * Note we accept localhost and 127.0.0.1 on the assumption this is probably a transient
 * listener; if it actually is a persistent server then that really is vulnerable to CSRF.
 */
predicate privateUrlFlowsToAuthCodeUrlCall(DataFlow::CallNode call) {
  exists(DataFlow::Node receiver |
    PrivateUrlFlowsToAuthCodeUrlCallFlow::flowTo(receiver) and
    PrivateUrlFlowsToAuthCodeUrlCallConfig::isSinkCall(receiver, call)
  )
}

module FlowToPrintConfig implements DataFlow::ConfigSig {
  additional predicate isSinkCall(DataFlow::Node sink, DataFlow::CallNode call) {
    exists(LoggerCall logCall | call = logCall | sink = logCall.getAMessageComponent())
  }

  predicate isSource(DataFlow::Node source) { source = any(AuthCodeUrl m).getACall().getResult() }

  predicate isSink(DataFlow::Node sink) { isSinkCall(sink, _) }
}

module FlowToPrintFlow = DataFlow::Global<FlowToPrintConfig>;

/** Holds if the provided `CallNode`'s result flows to an argument of a printer call. */
predicate resultFlowsToPrinter(DataFlow::CallNode authCodeUrlCall) {
  FlowToPrintFlow::flow(authCodeUrlCall.getResult(), _)
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
predicate seemsLikeDoneWithinATerminal(DataFlow::CallNode authCodeUrlCall) {
  resultFlowsToPrinter(authCodeUrlCall) and
  containsCallToStdinScanner(authCodeUrlCall.getRoot())
}

from Flow::PathNode source, Flow::PathNode sink, DataFlow::CallNode sinkCall
where
  Flow::flowPath(source, sink) and
  ConstantStateFlowConfig::isSinkCall(sink.getNode(), sinkCall) and
  // Exclude cases that seem to be oauth flows done from within a terminal:
  not seemsLikeDoneWithinATerminal(sinkCall) and
  not privateUrlFlowsToAuthCodeUrlCall(sinkCall)
select sink.getNode(), source, sink, "Using a constant $@ to create oauth2 URLs.", source.getNode(),
  "state string"
