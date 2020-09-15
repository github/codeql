/**
 * Provides classes modeling security-relevant aspects of the `html/template` package.
 */

import go

/** Provides models of commonly used functions in the `html/template` package. */
module HtmlTemplate {
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
        this.hasQualifiedName("html/template", fn)
      )
    }

    override string kind() { result = kind }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func HTMLEscape(w io.Writer, b []byte)
      hasQualifiedName("html/template", "HTMLEscape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func HTMLEscapeString(s string) string
      hasQualifiedName("html/template", "HTMLEscapeString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func HTMLEscaper(args ...interface{}) string
      hasQualifiedName("html/template", "HTMLEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func JSEscape(w io.Writer, b []byte)
      hasQualifiedName("html/template", "JSEscape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func JSEscapeString(s string) string
      hasQualifiedName("html/template", "JSEscapeString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func JSEscaper(args ...interface{}) string
      hasQualifiedName("html/template", "JSEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func URLQueryEscaper(args ...interface{}) string
      hasQualifiedName("html/template", "URLQueryEscaper") and
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
      // signature: func (*Template).Execute(wr io.Writer, data interface{}) error
      this.hasQualifiedName("html/template", "Template", "Execute") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func (*Template).ExecuteTemplate(wr io.Writer, name string, data interface{}) error
      this.hasQualifiedName("html/template", "Template", "ExecuteTemplate") and
      (inp.isParameter(2) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
