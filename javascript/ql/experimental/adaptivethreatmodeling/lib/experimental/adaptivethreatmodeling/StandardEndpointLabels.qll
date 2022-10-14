/**
 * For internal use only.
 *
 * Provides classes and predicates that are useful for endpoint filters.
 *
 * The standard use of this library is to make use of `isPotentialEffectiveSink/1`
 */

private import javascript
private import semmle.javascript.filters.ClassifyFiles as ClassifyFiles
private import semmle.javascript.heuristics.SyntacticHeuristics
private import CoreKnowledge as CoreKnowledge

module Labels {
  private newtype TEndpointLabel =
    TLikelyExternalLibraryCallEndpointLabel() or
    TFlowsToArgumentOfLikelyExternalLibraryCallEndpointLabel() or
    TReasonSinkExcludedEndpointLabel() or
    TArgumentToModeledFunction()

  class EndpointLabel extends TEndpointLabel {
    abstract DataFlow::Node aNode();

    abstract string getLabel();

    string toString() { result = getLabel() }
  }

  class LikelyExternalLibraryCallEndpointLabel extends EndpointLabel,
    TLikelyExternalLibraryCallEndpointLabel {
    override DataFlow::Node aNode() { result = getALikelyExternalLibraryCall() }

    override string getLabel() { result = "legacy/likely-external-library-call" }
  }

  class FlowsToArgumentOfLikelyExternalLibraryCallEndpointLabel extends EndpointLabel,
    TFlowsToArgumentOfLikelyExternalLibraryCallEndpointLabel {
    override DataFlow::Node aNode() { flowsToArgumentOfLikelyExternalLibraryCall(result) }

    override string getLabel() { result = "legacy/flows-to-argument-of-likely-external-library-call" }
  }

  class ReasonSinkExcludedEndpointLabel extends EndpointLabel, TReasonSinkExcludedEndpointLabel {
    string reason;

    ReasonSinkExcludedEndpointLabel() {
      this = this and
      reason = getAReasonSinkExcluded(any(DataFlow::Node n))
    }

    override DataFlow::Node aNode() {
      result = any(DataFlow::Node n | getAReasonSinkExcluded(n) = "legacy/reason-sink-excluded/"+reason)
    }

    override string getLabel() { result = reason }
  }
}

string getAnEndpointLabel(DataFlow::Node n) {
  exists(Labels::EndpointLabel l | result = l.getLabel() and n = l.aNode())
}

DataFlow::Node getALabeledEndpoint(string label) { getAnEndpointLabel(result) = label }

/** Provides a set of reasons why a given data flow node should be excluded as a sink candidate. */
private string getAReasonSinkExcluded(DataFlow::Node n) {
  isArgumentToModeledFunction(n) and result = "argument to modeled function"
  or
  isArgumentToSinklessLibrary(n) and result = "argument to sinkless library"
  or
  isSanitizer(n) and result = "sanitizer"
  or
  isPredicate(n) and result = "predicate"
  or
  isHash(n) and result = "hash"
  or
  isNumeric(n) and result = "numeric"
  or
  // Ignore candidate sinks within externs, generated, library, and test code
  exists(string category | category = ["externs", "generated", "library", "test"] |
    ClassifyFiles::classify(n.getFile(), category) and
    result = "in " + category + " file"
  )
}

/**
 * Holds if the node `n` is an argument to a function that has a manual model.
 */
private predicate isArgumentToModeledFunction(DataFlow::Node n) {
  exists(DataFlow::InvokeNode invk, DataFlow::Node known |
    invk.getAnArgument() = n and invk.getAnArgument() = known and isSomeModeledArgument(known)
  )
}

/**
 * Holds if the node `n` is an argument that has a manual model.
 */
private predicate isSomeModeledArgument(DataFlow::Node n) {
  CoreKnowledge::isKnownLibrarySink(n) or
  CoreKnowledge::isKnownStepSrc(n) or
  CoreKnowledge::isOtherModeledArgument(n, _)
}

/**
 * Holds if `n` appears to be a numeric value.
 */
private predicate isNumeric(DataFlow::Node n) { isReadFrom(n, ".*index.*") }

/**
 * Holds if `n` is an argument to a library without sinks.
 */
private predicate isArgumentToSinklessLibrary(DataFlow::Node n) {
  exists(DataFlow::InvokeNode invk, DataFlow::SourceNode commonSafeLibrary, string libraryName |
    libraryName = ["slugify", "striptags", "marked"]
  |
    commonSafeLibrary = DataFlow::moduleImport(libraryName) and
    invk = [commonSafeLibrary, commonSafeLibrary.getAPropertyRead()].getAnInvocation() and
    n = invk.getAnArgument()
  )
}

private predicate isSanitizer(DataFlow::Node n) {
  exists(DataFlow::CallNode call | n = call.getAnArgument() |
    call.getCalleeName().regexpMatch("(?i).*(escape|valid(ate)?|sanitize|purify).*")
  )
}

private predicate isPredicate(DataFlow::Node n) {
  exists(DataFlow::CallNode call | n = call.getAnArgument() |
    call.getCalleeName().regexpMatch("(equals|(|is|has|can)(_|[A-Z])).*")
  )
}

private predicate isHash(DataFlow::Node n) {
  exists(DataFlow::CallNode call | n = call.getAnArgument() |
    call.getCalleeName().regexpMatch("(?i)^(sha\\d*|md5|hash)$")
  )
}

/**
 * Holds if the data flow node is a (possibly indirect) argument of a likely external library call.
 *
 * This includes direct arguments of likely external library calls as well as nested object
 * literals within those calls.
 */
private predicate flowsToArgumentOfLikelyExternalLibraryCall(DataFlow::Node n) {
  n = getACallWithoutCallee().getAnArgument()
  or
  exists(DataFlow::SourceNode src | flowsToArgumentOfLikelyExternalLibraryCall(src) |
    n = src.getAPropertyWrite().getRhs()
  )
  or
  exists(DataFlow::ArrayCreationNode arr | flowsToArgumentOfLikelyExternalLibraryCall(arr) |
    n = arr.getAnElement()
  )
}

/**
 * Get calls which are likely to be to external non-built-in libraries.
 */
private DataFlow::CallNode getALikelyExternalLibraryCall() { result = getACallWithoutCallee() }

/**
 * Gets a node that flows to callback-parameter `p`.
 */
private DataFlow::SourceNode getACallback(DataFlow::ParameterNode p, DataFlow::TypeBackTracker t) {
  t.start() and
  result = p and
  any(DataFlow::FunctionNode f).getLastParameter() = p and
  exists(p.getACall())
  or
  exists(DataFlow::TypeBackTracker t2 | result = getACallback(p, t2).backtrack(t2, t))
}

/**
 * Get calls for which we do not have the callee (i.e. the definition of the called function). This
 * acts as a heuristic for identifying calls to external library functions.
 */
private DataFlow::CallNode getACallWithoutCallee() {
  forall(Function callee | callee = result.getACallee() | callee.getTopLevel().isExterns()) and
  not exists(DataFlow::ParameterNode param, DataFlow::FunctionNode callback |
    param.flowsTo(result.getCalleeNode()) and
    callback = getACallback(param, DataFlow::TypeBackTracker::end())
  )
}
