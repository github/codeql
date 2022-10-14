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

private module Labels {
  newtype TEndpointLabel = TLegacyEndpoint()

  class EndpointLabel extends TEndpointLabel {
    abstract string getLabel(DataFlow::Node n);

    abstract string toString();
  }

  class LegacyLabel extends EndpointLabel, TLegacyEndpoint {
    override string getLabel(DataFlow::Node n) { legacyLabel(n, result) }

    string toString() { result = "LegacyLabel" }
  }

  predicate legacyLabel(DataFlow::Node n, string label) {
    n = StandardEndpointFilters::getALikelyExternalLibraryCall() and
    label = "legacy/likely-external-library-call"
    or
    StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(n) and
    label = "legacy/flows-to-argument-of-likely-external-library-call"
    or
    label = "legacy/reason-sink-excluded/" + StandardEndpointFilters::getAReasonSinkExcluded(n)
  }
}

string getAnEndpointLabel(DataFlow::Node n) { result = any(Labels::EndpointLabel l).getLabel(n) }

DataFlow::Node getALabeledEndpoint(string label) { getAnEndpointLabel(result) = label }
