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
        fn = ["HTMLEscape", "HTMLEscapeString", "HTMLEscaper"] and kind = "html"
        or
        fn = ["JSEscape", "JSEscapeString", "JSEscaper"] and kind = "js"
        or
        fn = "URLQueryEscaper" and kind = "url"
      |
        this.hasQualifiedName("html/template", fn)
      )
    }

    override string kind() { result = kind }
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func HTMLEscaper(args ...interface{}) string
      this.hasQualifiedName("html/template", "HTMLEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func JSEscaper(args ...interface{}) string
      this.hasQualifiedName("html/template", "JSEscaper") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func URLQueryEscaper(args ...interface{}) string
      this.hasQualifiedName("html/template", "URLQueryEscaper") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private newtype TTemplateStmt =
    MkTemplateStmt(HTML::TextNode parent, int idx, string text) {
      text = parent.getText().regexpFind("(?s)\\{\\{.*?\\}\\}", idx, _)
    }

  /**
   * A statement inside an HTML template.
   */
  class TemplateStmt extends TTemplateStmt {
    HTML::TextNode parent;
    string text;

    TemplateStmt() { this = MkTemplateStmt(parent, _, text) }

    /** Gets the text of the body of the template statement. */
    string getBody() { result = text.regexpCapture("(?s)\\{\\{(.*)\\}\\}", 1) } // matches the inside of the curly bracket delimiters

    /** Gets the file in which this statement appears. */
    File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /** Gets a textual representation of this statement. */
    string toString() { result = "HTML template statement" }

    /** Get the HTML element that contains this template statement. */
    HTML::TextNode getEnclosingTextNode() { result = parent }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      parent.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  private newtype TTemplateRead =
    MkTemplateRead(TemplateStmt parent, int idx, string text) {
      // matches (.<valid golang ident>)*
      text = parent.getBody().regexpFind("(\\s|^)\\.(\\p{L}|\\p{N}|\\.)*\\b", idx, _)
    }

  /**
   * A read in an HTML template statement.
   */
  class TemplateRead extends TTemplateRead {
    TemplateStmt parent;
    string text;

    TemplateRead() { this = MkTemplateRead(parent, _, text) }

    /** Gets the name of the field being read. This may include dots if nested fields are used. */
    string getFieldName() { result = text.trim().suffix(1) }

    /** Gets the variable with fields that is read if `arg` is passed to this template execution. */
    VariableWithFields getReadVariable(VariableWithFields arg) {
      if this.getFieldName() = ""
      then result = arg
      else result.getQualifiedName() = arg.getQualifiedName() + "." + this.getFieldName()
    }

    /** Gets the file in which this read appears. */
    File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /** Gets a textual representation of this statement. */
    string toString() { result = "HTML template read of " + text }

    /** Get the HTML element that contains this template read. */
    HTML::TextNode getEnclosingTextNode() { result = parent.getEnclosingTextNode() }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      parent.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }
}
