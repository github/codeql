/**
 * Provides classes for working with Handlebars code.
 */

import javascript

module Handlebars {
  /**
   * A reference to the Handlebars library.
   */
  class Handlebars extends DataFlow::SourceNode {
    Handlebars() {
      this.accessesGlobal("handlebars")
      or
      this.accessesGlobal("Handlebars")
      or
      this = DataFlow::moduleImport("handlebars")
      or
      this.hasUnderlyingType("Handlebars")
    }
  }

  /**
   * A new instantiation of a Handlebars.SafeString.
   */
  class SafeString extends DataFlow::NewNode {
    SafeString() { this = any(Handlebars h).getAConstructorInvocation("SafeString") }
  }
}

/** Provides logic for taint steps for the handlebars library. */
module TaintStep {
  /**
   * Gets a `SourceNode` tracked from a compilation of a Handlebars template.
   */
  private DataFlow::SourceNode compiledHandlebarsTemplate(DataFlow::Node originalCall) {
    result = compiledHandlebarsTemplate(DataFlow::TypeTracker::end(), originalCall)
  }

  private DataFlow::SourceNode compiledHandlebarsTemplate(
    DataFlow::TypeTracker t, DataFlow::Node originalCall
  ) {
    t.start() and
    result = any(Handlebars::Handlebars hb).getAMethodCall(["compile", "template"]) and
    result = originalCall
    or
    exists(DataFlow::TypeTracker t2 |
      result = compiledHandlebarsTemplate(t2, originalCall).track(t2, t)
    )
  }

  /**
   * Holds if there's a step from `pred` to `succ` due to templating data being
   * passed from a templating call to a registered helper via a parameter.
   */
  private predicate isHandlebarsArgStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string helperName |
      exists(DataFlow::CallNode templatingCall, DataFlow::CallNode compileCall |
        templatingCall = compiledHandlebarsTemplate(compileCall).getACall() and
        pred = templatingCall.getAnArgument().getALocalSource().getAPropertyWrite().getRhs() and
        (
          compileCall
              .getArgument(0)
              .mayHaveStringValue(any(string templateText |
                  // an approximation: if the template contains the
                  // helper name, it's probably a helper call
                  templateText.matches("%" + helperName + "%")
                ))
          or
          // When we don't have a string value, we can't be sure
          // and will assume a step.
          not exists(string s | compileCall.getArgument(0).mayHaveStringValue(s))
        )
      ) and
      exists(DataFlow::CallNode registerHelperCall, DataFlow::FunctionNode helperFunc |
        registerHelperCall = any(Handlebars::Handlebars hb).getAMethodCall("registerHelper") and
        registerHelperCall.getArgument(0).mayHaveStringValue(helperName) and
        helperFunc = registerHelperCall.getArgument(1).getAFunctionValue() and
        helperFunc.getAParameter() = succ
      )
    )
  }

  /**
   * A shared flow step from passing data to a handlebars template with
   * helpers registered.
   */
  class HandlebarsStep extends DataFlow::SharedFlowStep {
    DataFlow::CallNode templatingCall;

    override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
      isHandlebarsArgStep(node1, node2)
    }
  }
}
