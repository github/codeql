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
    TLegacyEndpointLabel() or
    TLegacyReasonSinkExcludedEndpointLabel(string innerReason) {
      innerReason =
        [
          "argument to modeled function", //
          "argument to sinkless library", //
          "sanitizer", //
          "predicate", //
          "hash", //
          "numeric", //
          "in " + ["externs", "generated", "library", "test"] + " file" //
        ]
    } or
    TLegacyModeledDbAccess()

  class EndpointLabel extends TEndpointLabel {
    abstract string getLabel(DataFlow::Node n);

    abstract string toString();
  }

  class LegacyEndpointLabel extends EndpointLabel, TLegacyEndpointLabel {
    override string getLabel(DataFlow::Node n) {
      n = StandardEndpointFilters::getALikelyExternalLibraryCall() and
      result = "legacy/likely-external-library-call"
      or
      StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(n) and
      result = "legacy/flows-to-argument-of-likely-external-library-call"
    }

    override string toString() { result = "LegacyEndpointLabel" }
  }

  class LegacyReasonSinkExcludedEndpointLabel extends EndpointLabel,
    TLegacyReasonSinkExcludedEndpointLabel {
    override string getLabel(DataFlow::Node n) {
      exists(string inner |
        this = TLegacyReasonSinkExcludedEndpointLabel(inner) and
        inner = StandardEndpointFilters::getAReasonSinkExcluded(n)
      |
        result = inner
      )
    }

    override string toString() {
      exists(string inner | this = TLegacyReasonSinkExcludedEndpointLabel(inner) |
        result = "TLegacyReasonSinkExcludedEndpointLabel(" + inner + ")"
      )
    }
  }

  class LegacyModeledDbAccess extends EndpointLabel, TLegacyModeledDbAccess {
    override string getLabel(DataFlow::Node n) {
      exists(DataFlow::CallNode call | n = call.getAnArgument() |
        call.(DataFlow::MethodCallNode).getMethodName() =
          ["create", "createCollection", "createIndexes"] and
        result = "legacy/modeled/db-access/matches database access call heuristic"
      )
    }

    override string toString() { result = "LegacyModeledDbAccess" }
  }
}

string getAnEndpointLabel(DataFlow::Node n) { result = any(Labels::EndpointLabel l).getLabel(n) }

DataFlow::Node getALabeledEndpoint(string label) { getAnEndpointLabel(result) = label }
