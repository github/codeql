/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.Bufio
import semmle.go.frameworks.stdlib.EncodingAsn1
import semmle.go.frameworks.stdlib.EncodingJson
import semmle.go.frameworks.stdlib.EncodingPem
import semmle.go.frameworks.stdlib.EncodingXml
import semmle.go.frameworks.stdlib.Fmt
import semmle.go.frameworks.stdlib.Html
import semmle.go.frameworks.stdlib.HtmlTemplate
import semmle.go.frameworks.stdlib.IoFs
import semmle.go.frameworks.stdlib.IoIoutil
import semmle.go.frameworks.stdlib.Log
import semmle.go.frameworks.stdlib.NetHttp
import semmle.go.frameworks.stdlib.Os
import semmle.go.frameworks.stdlib.Regexp
import semmle.go.frameworks.stdlib.Strconv
import semmle.go.frameworks.stdlib.TextTemplate

/** Provides a class for modeling functions which convert strings into integers. */
module IntegerParser {
  /**
   * A function that converts strings into integers.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `IntegerParser` instead.
   */
  abstract class Range extends Function {
    /**
     * Gets the maximum bit size of the return value, if this makes
     * sense, where 0 represents the bit size of `int` and `uint`.
     */
    int getTargetBitSize() { none() }

    /**
     * Gets the `FunctionInput` containing the maximum bit size of the
     * return value, if this makes sense. Note that if the value of the
     * input is 0 then it means the bit size of `int` and `uint`.
     */
    FunctionInput getTargetBitSizeInput() { none() }
  }
}

/** Provides models of commonly used functions in the `net/url` package. */
module Url {
  /** A method that returns a part of a URL. */
  class UrlGetter extends Method {
    UrlGetter() {
      exists(string m | this.hasQualifiedName("net/url", "URL", m) |
        m = ["EscapedPath", "Hostname", "Port", "Query", "RequestURI"]
      )
    }
  }
}

/** DEPRECATED: Alias for Url */
deprecated module URL = Url;
