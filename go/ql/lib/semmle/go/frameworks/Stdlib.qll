/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.ArchiveTar
import semmle.go.frameworks.stdlib.ArchiveZip
import semmle.go.frameworks.stdlib.Bufio
import semmle.go.frameworks.stdlib.CompressFlate
import semmle.go.frameworks.stdlib.CompressGzip
import semmle.go.frameworks.stdlib.CompressLzw
import semmle.go.frameworks.stdlib.CompressZlib
import semmle.go.frameworks.stdlib.CryptoTls
import semmle.go.frameworks.stdlib.DatabaseSql
import semmle.go.frameworks.stdlib.EncodingAsn1
import semmle.go.frameworks.stdlib.EncodingCsv
import semmle.go.frameworks.stdlib.EncodingGob
import semmle.go.frameworks.stdlib.EncodingJson
import semmle.go.frameworks.stdlib.EncodingPem
import semmle.go.frameworks.stdlib.EncodingXml
import semmle.go.frameworks.stdlib.Errors
import semmle.go.frameworks.stdlib.Fmt
import semmle.go.frameworks.stdlib.Html
import semmle.go.frameworks.stdlib.HtmlTemplate
import semmle.go.frameworks.stdlib.Io
import semmle.go.frameworks.stdlib.IoFs
import semmle.go.frameworks.stdlib.IoIoutil
import semmle.go.frameworks.stdlib.Log
import semmle.go.frameworks.stdlib.MimeMultipart
import semmle.go.frameworks.stdlib.MimeQuotedprintable
import semmle.go.frameworks.stdlib.Net
import semmle.go.frameworks.stdlib.NetHttp
import semmle.go.frameworks.stdlib.NetHttpHttputil
import semmle.go.frameworks.stdlib.NetTextproto
import semmle.go.frameworks.stdlib.Os
import semmle.go.frameworks.stdlib.Path
import semmle.go.frameworks.stdlib.PathFilepath
import semmle.go.frameworks.stdlib.Reflect
import semmle.go.frameworks.stdlib.Regexp
import semmle.go.frameworks.stdlib.Strconv
import semmle.go.frameworks.stdlib.Strings
import semmle.go.frameworks.stdlib.Syscall
import semmle.go.frameworks.stdlib.TextTabwriter
import semmle.go.frameworks.stdlib.TextTemplate
import semmle.go.frameworks.stdlib.Unsafe

// These are modeled using TaintTracking::FunctionModel because they doesn't have real type signatures,
// and therefore currently have an InvalidType, not a SignatureType, which breaks Models as Data.
/**
 * A model of the built-in `append` function, which propagates taint from its arguments to its
 * result.
 */
private class AppendFunction extends TaintTracking::FunctionModel {
  AppendFunction() { this = Builtin::append() }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(_) and outp.isResult()
  }
}

/**
 * A model of the built-in `copy` function, which propagates taint from its second argument
 * to its first.
 */
private class CopyFunction extends TaintTracking::FunctionModel {
  CopyFunction() { this = Builtin::copy() }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(1) and outp.isParameter(0)
  }
}

/**
 * A model of the built-in `min` function, which computes the smallest value of a fixed number of
 * arguments of ordered types. There is at least one argument and "ordered types" includes e.g.
 * strings, so we care about data flow through `min`.
 */
private class MinFunction extends DataFlow::FunctionModel {
  MinFunction() { this = Builtin::min_() }

  override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(_) and outp.isResult()
  }
}

/**
 * A model of the built-in `max` function, which computes the largest value of a fixed number of
 * arguments of ordered types. There is at least one argument and "ordered types" includes e.g.
 * strings, so we care about data flow through `max`.
 */
private class MaxFunction extends DataFlow::FunctionModel {
  MaxFunction() { this = Builtin::max_() }

  override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(_) and outp.isResult()
  }
}

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

    /** Gets whether the function is for parsing signed or unsigned integers. */
    boolean isSigned() { none() }
  }
}

/** Provides models of commonly used functions in the `net/url` package. */
module Url {
  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  /** The `JoinPath` function. */
  class JoinPath extends TaintTracking::FunctionModel {
    JoinPath() { this.hasQualifiedName("net/url", "JoinPath") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult(0)
    }
  }

  /** The method `URL.JoinPath`. */
  class JoinPathMethod extends TaintTracking::FunctionModel, Method {
    JoinPathMethod() { this.hasQualifiedName("net/url", "URL", "JoinPath") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      (inp.isReceiver() or inp.isParameter(_)) and
      outp.isResult(0)
    }
  }

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
