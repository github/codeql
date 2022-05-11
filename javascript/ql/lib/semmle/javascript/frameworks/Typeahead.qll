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
      exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
    }

    /** Gets a Bloodhound instance that fetches remote server data. */
    private DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "json" and
      promise = false and
      exists(TypeaheadSource source |
        this.ref() = source.getALocalSource() or this.ref().getAMethodCall("ttAdapter") = source
      |
        result = source.getASuggestion()
      )
    }
  }

  /**
   * An invocation of the `typeahead.js` library.
   */
  private class TypeaheadCall extends DataFlow::CallNode {
    TypeaheadCall() {
      // Matches `$(...).typeahead(..)`
      this = JQuery::objectRef().getAMethodCall("typeahead")
    }
  }

  /**
   * A function that generates suggestions to typeahead.js.
   */
  class TypeaheadSuggestionFunction extends DataFlow::FunctionNode {
    TypeaheadCall typeaheadCall;

    TypeaheadSuggestionFunction() {
      // Matches `$(...).typeahead({..}, { templates: { suggestion: <this> } })`.
      this =
        typeaheadCall
            .getOptionArgument(1, "templates")
            .getALocalSource()
            .getAPropertyWrite("suggestion")
            .getRhs()
            .getAFunctionValue()
    }

    /**
     * Gets the call to typeahead.js where this suggestion function is used.
     */
    TypeaheadCall getTypeaheadCall() { result = typeaheadCall }
  }

  /**
   * A `source` option for a typeahead.js plugin instance.
   */
  private class TypeaheadSource extends DataFlow::ValueNode {
    TypeaheadCall typeaheadCall;

    TypeaheadSource() { this = typeaheadCall.getOptionArgument(1, "source") }

    /** Gets a node for a suggestion that this source motivates. */
    DataFlow::Node getASuggestion() {
      exists(TypeaheadSuggestionFunction suggestionCallback |
        suggestionCallback.getTypeaheadCall() = typeaheadCall and
        result = suggestionCallback.getParameter(0)
      )
    }
  }

  /**
   * A taint step that models that a function in the `source` of typeahead.js is used to determine the input to the suggestion function.
   */
  private class TypeaheadSourceTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // Matches `$(...).typeahead({..}, {source: function(q, cb) {..;cb(<pred>);..}, templates: { suggestion: function(<succ>) {} } })`.
      exists(TypeaheadSource typeahead |
        pred = typeahead.getAFunctionValue().getParameter([1 .. 2]).getACall().getAnArgument() and
        succ = typeahead.getASuggestion()
      )
    }
  }
}
