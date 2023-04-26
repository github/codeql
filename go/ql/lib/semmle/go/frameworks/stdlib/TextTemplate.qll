/**
 * Provides classes modeling security-relevant aspects of the `text/template` package.
 */

import go

/** Provides models of commonly used functions in the `text/template` package. */
module TextTemplate {
  private class TemplateEscape extends EscapeFunction::Range {
    string kind;

    TemplateEscape() {
      exists(string fn |
        fn.matches("HTMLEscape%") and kind = "html"
        or
        fn.matches("JSEscape%") and kind = "js"
        or
        fn.matches("URLQueryEscape%") and kind = "url"
      |
        this.hasQualifiedName("text/template", fn)
      )
    }

    override string kind() { result = kind }
  }

  private class TextTemplateInstantiation extends TemplateInstantiation::Range,
    DataFlow::MethodCallNode
  {
    int dataArg;

    TextTemplateInstantiation() {
      exists(string m | this.getTarget().hasQualifiedName("text/template", "Template", m) |
        m = "Execute" and
        dataArg = 1
        or
        m = "ExecuteTemplate" and
        dataArg = 2
      )
    }

    override DataFlow::Node getTemplateArgument() { result = this.getReceiver() }

    override DataFlow::Node getADataArgument() { result = this.getArgument(dataArg) }
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func HTMLEscaper(args ...interface{}) string
      this.hasQualifiedName("text/template", "HTMLEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func JSEscaper(args ...interface{}) string
      this.hasQualifiedName("text/template", "JSEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func URLQueryEscaper(args ...interface{}) string
      this.hasQualifiedName("text/template", "URLQueryEscaper") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
