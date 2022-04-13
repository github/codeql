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
private module HandlebarsTaintSteps {
  /**
   * Gets a reference to a compiled Handlebars template.
   */
  private DataFlow::SourceNode compiledTemplate(DataFlow::CallNode compileCall) {
    result = compiledTemplate(DataFlow::TypeTracker::end(), compileCall)
  }

  private DataFlow::SourceNode compiledTemplate(
    DataFlow::TypeTracker t, DataFlow::CallNode compileCall
  ) {
    t.start() and
    result = any(Handlebars::Handlebars hb).getAMethodCall(["compile", "template"]) and
    result = compileCall
    or
    exists(DataFlow::TypeTracker t2 | result = compiledTemplate(t2, compileCall).track(t2, t))
  }

  /**
   * Gets a reference to a parameter of a registered Handlebars helper.
   *
   * ```javascript
   * function loudHelper(text) {
   *   return text.toUpperCase();
   * }
   *
   * hb.registerHelper("loud", loudHelper);
   * ```
   * In this example, `getRegisteredHelperParameter("loud", func, 0)` will bind `func` to
   * the `FunctionNode` representing `function loudHelper`, and return its parameter `text`.
   */
  private DataFlow::ParameterNode getRegisteredHelperParam(
    string helperName, DataFlow::FunctionNode helperFunction, int paramIndex
  ) {
    exists(DataFlow::CallNode registerHelperCall |
      registerHelperCall = any(Handlebars::Handlebars hb).getAMemberCall("registerHelper") and
      registerHelperCall.getArgument(0).mayHaveStringValue(helperName) and
      helperFunction = registerHelperCall.getArgument(1).getAFunctionValue() and
      result = helperFunction.getParameter(paramIndex)
    )
  }

  /**
   * Gets a `call` (which is a block wrapped inside curly braces inside the template) from `templateText`.
   *
   * For example, `getAHelperCallFromTemplate("Hello {{loud customer}}")` will return `"loud customer"`.
   */
  bindingset[templateText]
  private string getAHelperCallFromTemplate(string templateText) {
    result = templateText.regexpFind("\\{\\{[^}]+\\}\\}", _, _).regexpReplaceAll("[{}]", "").trim() and
    result.regexpMatch(".*\\s.*")
  }

  /**
   * Holds for calls to helpers from handlebars templates.
   *
   * ```javascript
   * hb.compile("contents of file {{path}} are: {{catFile path}} {{echo p1 p2}}");
   * ```
   *
   * In the example, the predicate will hold for:
   *
   * * helperName="catFile", argIdx=1, arg="path"
   * * helperName="echo", argIdx=1, arg="p1"
   * * helperName="echo", argIdx=2, arg="p2"
   *
   * The initial `{{path}}` will not be considered, as it has no arguments.
   */
  bindingset[templateText]
  private predicate isTemplateHelperCallArg(
    string templateText, string helperName, int argIdx, string argVal
  ) {
    exists(string call | call = getAHelperCallFromTemplate(templateText) |
      helperName = call.regexpFind("[^\\s]+", 0, _) and
      argIdx >= 0 and
      argVal = call.regexpFind("[^\\s]+", argIdx + 1, _)
    )
  }

  /**
   * Holds if there's a step from `pred` to `succ` due to templating data being
   * passed from a templating call to a registered helper via a parameter.
   *
   * To establish the step, we look at the template passed to `compile`, and will
   * only track steps from templates to helpers they actually reference.
   *
   * ```javascript
   * function loudHelper(text) {
   *   //                ^^^^ succ
   *   return text.toUpperCase();
   * }
   *
   * hb.registerHelper("loud", loudHelper);
   *
   * const template = hb.compile("Hello, {{loud name}}!");
   *
   * template({name: "user"});
   * //              ^^^^^^ pred
   * ```
   */
  private predicate isHandlebarsArgStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      string helperName, DataFlow::CallNode templatingCall, DataFlow::CallNode compileCall,
      DataFlow::FunctionNode helperFunction
    |
      templatingCall = compiledTemplate(compileCall).getACall() and
      exists(string templateText, string paramName, int argIdx |
        compileCall.getArgument(0).mayHaveStringValue(templateText)
      |
        pred = templatingCall.getArgument(0).getALocalSource().getAPropertyWrite(paramName).getRhs() and
        isTemplateHelperCallArg(templateText, helperName, argIdx, paramName) and
        succ = getRegisteredHelperParam(helperName, helperFunction, argIdx)
      )
    )
  }

  /**
   * A shared flow step from passing data to a handlebars template with
   * helpers registered.
   */
  class HandlebarsStep extends DataFlow::SharedFlowStep {
    DataFlow::CallNode templatingCall;

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      isHandlebarsArgStep(pred, succ)
    }
  }
}
