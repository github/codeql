/**
 * Provides classes modeling security-relevant aspects of the `golang.org/x/net/html` subpackage.
 *
 * Currently we support the unmarshalling aspect of this package, conducting taint from an untrusted
 * reader to an untrusted `Node` tree or `Tokenizer` instance. We do not yet model adding a child
 * `Node` to a tree then calling `Render` yielding an untrustworthy string.
 */

import go

/** Provides models of commonly used functions in the `golang.org/x/net/html` subpackage. */
module XNetHtml {
  /** Gets the package name `golang.org/x/net/html`. */
  string packagePath() { result = "golang.org/x/net/html" }

  private class EscapeString extends HtmlEscapeFunction, TaintTracking::FunctionModel {
    EscapeString() { this.hasQualifiedName(packagePath(), "EscapeString") }

    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionModels() { hasQualifiedName(packagePath(), _) }

    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      getName() =
        ["UnescapeString", "Parse", "ParseFragment", "ParseFragmentWithOptions", "ParseWithOptions",
            "NewTokenizer", "NewTokenizerFragment"] and
      input.isParameter(0) and
      output.isResult(0)
      or
      getName() = ["AppendChild", "InsertBefore"] and
      input.isParameter(0) and
      output.isReceiver()
    }
  }

  private class TokenizerMethodModels extends Method, TaintTracking::FunctionModel {
    TokenizerMethodModels() { this.hasQualifiedName(packagePath(), "Tokenizer", _) }

    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      getName() = ["Buffered", "Raw", "Text", "Token"] and input.isReceiver() and output.isResult(0)
      or
      getName() = "TagAttr" and input.isReceiver() and output.isResult(1)
    }
  }
}
