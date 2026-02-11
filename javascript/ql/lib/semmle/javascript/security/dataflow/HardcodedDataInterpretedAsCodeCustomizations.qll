/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * hard-coded data being interpreted as code, as well as extension
 * points for adding your own.
 */

import javascript
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations

module HardcodedDataInterpretedAsCode {
  private newtype TFlowState =
    TUnmodified() or
    TModified()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TUnmodified() and result = "unmodified"
      or
      this = TModified() and result = "modified"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TUnmodified() and result.isData()
      or
      this = TModified() and result.isTaint()
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /** An unmodified value originating from a string constant. */
    FlowState unmodified() { result = TUnmodified() }

    /** A value which has undergone some transformation, such as hex decoding. */
    FlowState modified() { result = TModified() }
  }

  /**
   * A data flow source for hard-coded data.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow state for which this is a source. */
    FlowState getAFlowState() { result = FlowState::unmodified() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for code injection.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow state for which this is a sink. */
    FlowState getAFlowState() { result = FlowState::modified() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getLabel() { result = this.getAFlowState().toFlowLabel() }

    /** Gets a description of what kind of sink this is. */
    abstract string getKind();
  }

  /**
   * A sanitizer for hard-coded data.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A constant string consisting of eight or more hexadecimal characters (including at
   * least one digit), viewed as a source of hard-coded data that should not be
   * interpreted as code.
   */
  private class DefaultSource extends Source, DataFlow::ValueNode {
    DefaultSource() {
      exists(string val | val = astNode.(Expr).getStringValue() |
        val.regexpMatch("[0-9a-fA-F]{8,}") and
        val.regexpMatch(".*[0-9].*")
      )
    }
  }

  /**
   * A code injection sink; hard-coded data should not flow here.
   */
  private class DefaultCodeInjectionSink extends Sink instanceof CodeInjection::Sink {
    override FlowState getAFlowState() { result = FlowState::modified() }

    override string getKind() { result = "Code" }
  }

  /**
   * An argument to `require` path; hard-coded data should not flow here.
   */
  private class RequireArgumentSink extends Sink {
    RequireArgumentSink() { this = any(Require r).getAnArgument().flow() }

    override FlowState getAFlowState() { result = [FlowState::modified(), FlowState::unmodified()] }

    override string getKind() { result = "An import path" }
  }
}
