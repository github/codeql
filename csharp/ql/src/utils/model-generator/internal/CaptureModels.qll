/**
 * Provides classes and predicates related to capturing summary, source,
 * and sink models of the Standard or a 3rd party library.
 */

private import CaptureModelsSpecific

class TargetApi = TargetApiSpecific;

/**
 * Gets the summary model for `api` with `input`, `output` and `kind`.
 */
bindingset[input, output, kind]
private string asSummaryModel(TargetApi api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind + ";" //
      + "generated"
}

string asNegativeSummaryModel(TargetApi api) { result = asPartialNegativeModel(api) + "generated" }

/**
 * Gets the sink model for `api` with `input` and `kind`.
 */
bindingset[input, kind]
private string asSinkModel(TargetApi api, string input, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + kind + ";" //
      + "generated"
}

/**
 * Gets the source model for `api` with `output` and `kind`.
 */
bindingset[output, kind]
private string asSourceModel(TargetApi api, string output, string kind) {
  result =
    asPartialModel(api) + output + ";" //
      + kind + ";" //
      + "generated"
}

/**
 * A data flow configuration used for tracking flow through APIs.
 *
 * The sources are the parameters of an API and the sinks are the return values and parameters.
 *
 * We track flow paths of the form
 *
 * ```
 * parameter --value-->* node
 *           (--read--> node --value-->* node)?
 *           --(taint|value)-->* node
 *           (--store--> node --value-->* node)?
 *           --value-->* return
 * ```
 *
 * That is, first a sequence of 0 or more reads, followed by 0 or more taint steps,
 * followed by 0 or more stores, with value steps allowed in between all other steps.
 */
class ThroughFlowConfig extends ContentDataFlow::Configuration {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  final override predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof TargetApi
  }

  final override predicate isSink(DataFlow::Node sink) {
    sink instanceof DataFlowImplCommon::ReturnNodeExt
  }

  final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    taintStep(node1, node2)
  }

  final override predicate isBarrier(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  final override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }

  final override int accessPathLimit() { result = 2 }

  final override predicate isRelevantContent(DataFlow::ContentSet c) {
    isRelevantContentSpecific(c)
  }
}

private string printAccessPath(ContentDataFlow::AccessPath ap) {
  not exists(ap.getHead()) and
  result = ""
  or
  exists(DataFlow::Content head, ContentDataFlow::AccessPath tail |
    head = ap.getHead() and
    tail = ap.getTail() and
    result = printAccessPath(tail) + "." + printContent(head)
  )
}

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow(TargetApi api) {
  exists(
    ThroughFlowConfig config, DataFlow::ParameterNode p,
    DataFlowImplCommon::ReturnNodeExt returnNodeExt, string input, string output,
    ContentDataFlow::AccessPath reads, ContentDataFlow::AccessPath stores, boolean preservesValue,
    string kind
  |
    config.hasFlow(p, reads, returnNodeExt, stores, preservesValue) and
    returnNodeExt.getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) + printAccessPath(reads) and
    reads.getLength() <= 1 and
    stores.getLength() <= 1 and
    output = returnNodeAsOutput(returnNodeExt) + printAccessPath(stores) and
    input != output and
    (if preservesValue = true then kind = "value" else kind = "taint") and
    result = asSummaryModel(api, input, output, kind)
  )
}

/**
 * Gets the negative summary for `api`, if any.
 * A negative summary is generated, if there does not exist any positive flow.
 */
string captureNoFlow(TargetApi api) {
  not exists(captureThroughFlow(api)) and
  result = asNegativeSummaryModel(api)
}

/**
 * A TaintTracking Configuration used for tracking flow through APIs.
 * The sources are the already known existing sources and the sinks are the API return nodes.
 *
 * This can be used to generate Source summaries for an API, if the API expose an already known source
 * via its return (then the API itself becomes a source).
 */
private class FromSourceConfiguration extends TaintTracking::Configuration {
  FromSourceConfiguration() { this = "FromSourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { ExternalFlow::sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(TargetApi c |
      sink instanceof DataFlowImplCommon::ReturnNodeExt and
      sink.getEnclosingCallable() = c
    )
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSinkCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantSourceTaintStep(node1, node2)
  }
}

/**
 * Gets the source model(s) of `api`, if there is flow from an existing known source to the return of `api`.
 */
string captureSource(TargetApi api) {
  exists(DataFlow::Node source, DataFlow::Node sink, FromSourceConfiguration config, string kind |
    config.hasFlow(source, sink) and
    ExternalFlow::sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    isRelevantSourceKind(kind) and
    result = asSourceModel(api, returnNodeAsOutput(sink), kind)
  )
}

/**
 * A TaintTracking Configuration used for tracking flow through APIs.
 * The sources are the parameters of the API and the fields of the enclosing type.
 *
 * This can be used to generate Sink summaries for APIs, if the API propgates a parameter (or enclosing type field)
 * into an existing known sink (then the API itself becomes a sink).
 */
private class PropagateToSinkConfiguration extends PropagateToSinkConfigurationSpecific {
  PropagateToSinkConfiguration() { this = "parameters or fields flowing into sinks" }

  override predicate isSink(DataFlow::Node sink) { ExternalFlow::sinkNode(sink, _) }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

/**
 * Gets the sink model(s) of `api`, if there is flow from a parameter to an existing known sink.
 */
string captureSink(TargetApi api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    ExternalFlow::sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    isRelevantSinkKind(kind) and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}
