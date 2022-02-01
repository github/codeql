import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import experimental.semmle.python.Concepts
import semmle.python.Concepts

module NoSQLInjection {
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "NoSQLInjection" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
      source instanceof RemoteFlowSource and
      state instanceof RemoteInput
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
      sink = any(NoSQLQuery noSQLQuery).getQuery() and
      state instanceof ConvertedToDict
    }

    override predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) {
      // Block `RemoteInput` paths here, since they change state to `ConvertedToDict`
      exists(Decoding decoding | decoding.getFormat() = "JSON" and node = decoding.getOutput()) and
      state instanceof RemoteInput
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
      DataFlow::FlowState stateTo
    ) {
      exists(Decoding decoding | decoding.getFormat() = "JSON" |
        nodeFrom = decoding.getAnInput() and
        nodeTo = decoding.getOutput()
      ) and
      stateFrom instanceof RemoteInput and
      stateTo instanceof ConvertedToDict
    }

    override predicate isSanitizer(DataFlow::Node sanitizer) {
      sanitizer = any(NoSQLSanitizer noSQLSanitizer).getAnInput()
    }
  }

  /** A flow state signifying remote input. */
  class RemoteInput extends DataFlow::FlowState {
    RemoteInput() { this = "RemoteInput" }
  }

  /** A flow state signifying remote input converted to a dictionary. */
  class ConvertedToDict extends DataFlow::FlowState {
    ConvertedToDict() { this = "ConvertedToDict" }
  }
}
