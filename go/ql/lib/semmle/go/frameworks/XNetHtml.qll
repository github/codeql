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

  private class EscapeString extends EscapeFunction::Range {
    EscapeString() { this.hasQualifiedName(packagePath(), "EscapeString") }

    override string kind() { result = "html" }
  }
}
