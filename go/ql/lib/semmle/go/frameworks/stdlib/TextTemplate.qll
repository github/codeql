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
    DataFlow::MethodCallNode {
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

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func HTMLEscape(w io.Writer, b []byte)
      this.hasQualifiedName("text/template", "HTMLEscape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func HTMLEscapeString(s string) string
      this.hasQualifiedName("text/template", "HTMLEscapeString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func HTMLEscaper(args ...interface{}) string
      this.hasQualifiedName("text/template", "HTMLEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func JSEscape(w io.Writer, b []byte)
      this.hasQualifiedName("text/template", "JSEscape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func JSEscapeString(s string) string
      this.hasQualifiedName("text/template", "JSEscapeString") and
      (inp.isParameter(0) and outp.isResult())
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

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Template) Execute(wr io.Writer, data interface{}) error
      this.hasQualifiedName("text/template", "Template", "Execute") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func (*Template) ExecuteTemplate(wr io.Writer, name string, data interface{}) error
      this.hasQualifiedName("text/template", "Template", "ExecuteTemplate") and
      (inp.isParameter(2) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
