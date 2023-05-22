/**
 * Provides classes modeling security-relevant aspects of the `html` package.
 */

import go

/** Provides models of commonly used functions in the `html` package. */
module Html {
  private class Escape extends EscapeFunction::Range {
    Escape() { this.hasQualifiedName("html", "EscapeString") }

    override string kind() { result = "html" }
  }
}
