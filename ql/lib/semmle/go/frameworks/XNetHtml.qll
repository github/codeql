/**
 * Provides classes modeling security-relevant aspects of the `golang.org/x/net/html` subpackage.
 *
 * Currently we support the unmarshalling aspect of this package, conducting taint from an untrusted
 * reader to an untrusted `Node` tree or `Tokenizer` instance, as well as simple remarshalling of `Node`s
 * that were already untrusted. We do not yet model adding a child `Node` to a tree then calling `Render`
 * yielding an untrustworthy string.
 */

import go

/** Provides models of commonly used functions in the `golang.org/x/net/html` subpackage. */
module XNetHtml {
  /** Gets the package name `golang.org/x/net/html`. */
  string packagePath() { result = package("golang.org/x/net", "html") }

  private class EscapeString extends HtmlEscapeFunction, TaintTracking::FunctionModel {
    EscapeString() { this.hasQualifiedName(packagePath(), "EscapeString") }

    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionModels() { this.hasQualifiedName(packagePath(), _) }

    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      this.getName() =
        [
          "UnescapeString", "Parse", "ParseFragment", "ParseFragmentWithOptions",
          "ParseWithOptions", "NewTokenizer", "NewTokenizerFragment"
        ] and
      input.isParameter(0) and
      output.isResult(0)
      or
      this.getName() = ["AppendChild", "InsertBefore"] and
      input.isParameter(0) and
      output.isReceiver()
      or
      this.getName() = "Render" and
      input.isParameter(1) and
      output.isParameter(0)
    }
  }

  private class TokenizerMethodModels extends Method, TaintTracking::FunctionModel {
    TokenizerMethodModels() { this.hasQualifiedName(packagePath(), "Tokenizer", _) }

    // Note that `TagName` and the key part of `TagAttr` are not sources by default under the assumption
    // that their character-set restrictions usually rule them out as useful attack routes.
    override predicate hasTaintFlow(DataFlow::FunctionInput input, DataFlow::FunctionOutput output) {
      this.getName() = ["Buffered", "Raw", "Text", "Token"] and
      input.isReceiver() and
      output.isResult(0)
      or
      this.getName() = "TagAttr" and input.isReceiver() and output.isResult(1)
    }
  }
}
