/**
 * Provides classes for working with typeahead.js code (https://www.npmjs.com/package/typeahead.js).
 */

import javascript

module Typeahead {
  /**
   * A reference to the Bloodhound class, which is a utility-class for generating auto-complete suggestions.
   */
  class Bloodhound extends DataFlow::SourceNode {
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
  class BloodhoundInstance extends DataFlow::NewNode {
    BloodhoundInstance() { this = any(Bloodhound b).getAnInstantiation() }
  }

  /**
   * An instance of of the Bloodhound class that is used to fetch data from a remote server.
   */
  class RemoteBloodhoundClientRequest extends ClientRequest::Range, BloodhoundInstance {
    string optionName;
    DataFlow::ValueNode option;

    RemoteBloodhoundClientRequest() {
      (optionName = "remote" or optionName = "prefetch") and
      option = this.getOptionArgument(0, optionName)
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

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "json" and
      promise = false and
      /*
       * exists(TypeAheadSuggestionTaintStep step |
       *          (
       *            this.flowsTo(step)
       *            or
       *            this.getAMethodCall("ttAdapter").flowsTo(step)
       *          ) and
       *          step.step(_, result)
       *        )
       *        or
       */

      // the first occurrence of the responseDataNode can be very disconnected from the instantiation of Bloodhound
      // So I do this trick to get a taint-path that is readable to a developer.
      // The above (possibly with added type-tracking) would be the correct way, but which gives unhelpful feedback to developers.
      result = this
    }
  }

  /**
   * A function that generates suggestions to typeahead. 
   * Matches `$(...).typeahead(..., { templates: { suggestion: <this> } })`. 
   */
  class TypeaheadSuggestionFunction extends DataFlow::FunctionNode {
    DataFlow::CallNode typeaheadCall;

    TypeaheadSuggestionFunction() {
      typeaheadCall = JQuery::objectRef().getAMethodCall("typeahead") and
      this = typeaheadCall
            .getOptionArgument(1, "templates")
            .getALocalSource()
            .getAPropertyWrite("suggestion").getRhs()
            .getAFunctionValue()
    }

    /**
     * Gets the call to typeahead.js where this suggestion function is used.
     */
    DataFlow::CallNode getTypeaheadCall() { result = typeaheadCall }
  }

  /**
   * A taint step that models that the `source` in typeahead is used to determine the input to the suggestion function.
   */
  class TypeAheadSuggestionTaintStep extends TaintTracking::AdditionalTaintStep {
    DataFlow::Node successor;

    TypeAheadSuggestionTaintStep() {
      exists(TypeaheadSuggestionFunction suggestionFunction | 
        this = suggestionFunction.getTypeaheadCall().getOptionArgument(1, "source") and
        successor = suggestionFunction.getParameter(0)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      (
        pred = this
        or
        pred = this.getAFunctionValue().getParameter(any(int i | i = 1 or i = 2)).getACall().getAnArgument()
      ) and
      succ = successor
    }
  }

  /**
   * A taint step that models a call to `.ttAdapter()` on an instance of Bloodhound.
   */
  class BloodHoundAdapterStep extends TaintTracking::AdditionalTaintStep, BloodhoundInstance {

	override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      this.flowsTo(pred) and
      exists(DataFlow::MethodCallNode call |
        succ = call and
        call.getReceiver() = pred and
        call.getMethodName() = "ttAdapter"
      )
    }
  }
}
