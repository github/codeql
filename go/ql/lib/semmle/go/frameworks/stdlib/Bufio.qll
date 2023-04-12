/**
 * Provides classes modeling security-relevant aspects of the `bufio` package.
 */

import go

/** Provides models of commonly used functions in the `bufio` package. */
module Bufio {
  /**
   * The function `bufio.NewScanner`.
   */
  class NewScanner extends Function {
    NewScanner() { hasQualifiedName("bufio", "NewScanner") }

    /**
     * Gets the input corresponding to the `io.Reader`
     * argument provided in the call.
     */
    FunctionInput getReader() { result.isParameter(0) }
  }
}
