/**
 * Provides classes for working with typeahead.js code (https://www.npmjs.com/package/typeahead.js).
 */

import javascript

module Typeahead {
  /**
   * A reference to the Bloodhound class, which is a utility-class for generating auto-complete suggestions.
   */
  private class Bloodhound extends DataFlow::SourceNode {
    Bloodhound() {
      this = DataFlow::moduleImport("typeahead.js/dist/bloodhound.js")
      or
      this = DataFlow::moduleImport("bloodhound-js")
      or
      this.accessesGlobal("Bloodhound")
    }
  }

  /**
   * An instance of the Bloodhound class.
   */
  private class BloodhoundInstance extends DataFlow::NewNode {
    BloodhoundInstance() { this = any(Bloodhound b).getAnInstantiation() }
  }

  /**
   * An instance of of the Bloodhound class that is used to fetch data from a remote server.
   */
  private class RemoteBloodhoundClientRequest extends ClientRequest::Range, BloodhoundInstance {
    DataFlow::ValueNode option;

    RemoteBloodhoundClientRequest() {
      exists(string optionName | optionName = "remote" or optionName = "prefetch" |
        option = this.getOptionArgument(0, optionName)
      )
    }

    /**
     * Gets the URL for this Bloodhound instance.
     * The Bloodhound API specifies that the "remote" and "prefetch" options are either strings,
     * or an object containing an "url" property.
     */
    override DataFlow::Node getUrl() {
      result = option.getALocalSource().getAPropertyWrite("url").getRhs()
      or
      result = option
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }

    /** Gets a Bloodhound instance that fetches remote server data. */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and result = this
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    /** Gets a Bloodhound instance that fetches remote server data. */
    private DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "json" and
      promise = false and
      exists(TypeaheadSource source |
        ref() = source.getALocalSource() or ref().getAMethodCall("ttAdapter") = source
      |
        result = source.getSuccessor()
      )
    }
  }

  /**
   * A function that generates suggestions to typeahead.js.
   */
  class TypeaheadSuggestionFunction extends DataFlow::FunctionNode {
    DataFlow::CallNode typeaheadCall;

    TypeaheadSuggestionFunction() {
      typeaheadCall = JQuery::objectRef().getAMethodCall("typeahead") and
      // Matches `$(...).typeahead({..}, { templates: { suggestion: <this> } })`.
      this = typeaheadCall
            .getOptionArgument(1, "templates")
            .getALocalSource()
            .getAPropertyWrite("suggestion")
            .getRhs()
            .getAFunctionValue()
    }

    /**
     * Gets the call to typeahead.js where this suggestion function is used.
     */
    DataFlow::CallNode getTypeaheadCall() { result = typeaheadCall }
  }

  /**
   * A `source` field in the typeahead.js library where there exists a successor that consumes the values from the `source`.
   */
  private class TypeaheadSource extends DataFlow::ValueNode {
    DataFlow::Node successor;

    TypeaheadSource() {
      // Matches `$(...).typeahead({..}, {source: <this>, templates: { suggestion: function(<successor>) {} } })`.
      exists(TypeaheadSuggestionFunction suggestionFunction |
        this = suggestionFunction.getTypeaheadCall().getOptionArgument(1, "source") and
        successor = suggestionFunction.getParameter(0)
      )
    }

    /** Gets the successor where values from the `source` field flow to. */
    DataFlow::Node getSuccessor() { result = successor }
  }

  /**
   * A taint step that models that a function in the `source` of typeahead.js is used to determine the input to the suggestion function.
   */
  private class TypeaheadSourceTaintStep extends TypeaheadSource, TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // Matches `$(...).typeahead({..}, {source: function(q, cb) {..;cb(<pred>);..}, templates: { suggestion: function(<succ>) {} } })`.
      pred = this.getAFunctionValue().getParameter([1 .. 2]).getACall().getAnArgument() and
      succ = this.getSuccessor()
    }
  }
}
