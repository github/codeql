/** Provides modeling for the `I18n` translation method and the rails translation helpers. */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.frameworks.ActionController

/** Gets a call to `I18n.translate`, which can use keyword arguments as inputs for string interpolation. */
private MethodCall getI18nTranslateCall() {
  result = API::getTopLevelMember("I18n").getAMethodCall(["t", "translate"]).asExpr().getExpr()
}

/**
 * Gets a call to the rails view helper translate method, which is a wrapper around `I18n.translate`
 * that can also escape html if the key ends in `_html` or `.html`.
 */
private MethodCall getViewHelperTranslateCall() {
  result.getMethodName() = ["t", "translate"] and
  inActionViewContext(result)
}

/**
 * Gets a call to the rails controller helper translate method, which is a wrapper around `I18n.translate`
 * that can also escape html if the key ends in `_html` or `.html`.
 */
private MethodCall getControllerHelperTranslateCall() {
  result =
    any(ActionControllerClass c)
        .getSelf()
        .track()
        .getAMethodCall(["t", "translate"])
        .asExpr()
        .getExpr()
}

/** Flow summary for translation methods. */
private class TranslateSummary extends SummarizedCallable {
  TranslateSummary() { this = "I18n.translate" }

  override MethodCall getACall() {
    result =
      [getI18nTranslateCall(), getViewHelperTranslateCall(), getControllerHelperTranslateCall()]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[hash-splat].Element[any]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}

/** A call to a translation helper method that escapes HTML. */
private class TranslateHtmlEscape extends Escaping::Range, DataFlow::CallNode {
  TranslateHtmlEscape() {
    exists(MethodCall mc | mc = this.asExpr().getExpr() |
      mc = [getViewHelperTranslateCall(), getControllerHelperTranslateCall()] and
      mc.getArgument(0).getConstantValue().getStringlikeValue().matches(["%\\_html", "%.html"])
    )
  }

  override string getKind() { result = Escaping::getHtmlKind() }

  override DataFlow::Node getAnInput() { result = this.getKeywordArgument(_) }

  override DataFlow::Node getOutput() { result = this }
}
