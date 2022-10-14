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
private import StandardEndpointFilters as StandardEndpointFilters

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
    override DataFlow::Node aNode() { result = StandardEndpointFilters::getALikelyExternalLibraryCall() }

    override string getLabel() { result = "legacy/likely-external-library-call" }
  }

  class FlowsToArgumentOfLikelyExternalLibraryCallEndpointLabel extends EndpointLabel,
    TFlowsToArgumentOfLikelyExternalLibraryCallEndpointLabel {
    override DataFlow::Node aNode() { StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(result) }

    override string getLabel() { result = "legacy/flows-to-argument-of-likely-external-library-call" }
  }

  class ReasonSinkExcludedEndpointLabel extends EndpointLabel, TReasonSinkExcludedEndpointLabel {
    override DataFlow::Node aNode() {
      result = any(DataFlow::Node n | exists(StandardEndpointFilters::getAReasonSinkExcluded(n)))
    }

    override string getLabel() { result = "legacy/reason-sink-excluded/"+StandardEndpointFilters::getAReasonSinkExcluded(any(DataFlow::Node n)) }
  }
}

string getAnEndpointLabel(DataFlow::Node n) {
  exists(Labels::EndpointLabel l | result = l.getLabel() and n = l.aNode())
}

DataFlow::Node getALabeledEndpoint(string label) { getAnEndpointLabel(result) = label }
