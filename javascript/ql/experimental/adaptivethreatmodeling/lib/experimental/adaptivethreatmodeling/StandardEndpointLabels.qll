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
  class LabelledEndpoint extends DataFlow::Node {
    abstract string getLabel();
  }

  class LegacyLabel extends LabelledEndpoint {
    string label;

    LegacyLabel() { legacyLabel(this, label) }

    override string getLabel() { result = label }
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

string getAnEndpointLabel(DataFlow::Node n) { result = n.(Labels::LabelledEndpoint).getLabel() }

DataFlow::Node getALabeledEndpoint(string label) { getAnEndpointLabel(result) = label }
