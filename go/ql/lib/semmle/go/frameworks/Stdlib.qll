/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.ArchiveTar
import semmle.go.frameworks.stdlib.ArchiveZip
import semmle.go.frameworks.stdlib.Bufio
import semmle.go.frameworks.stdlib.Bytes
import semmle.go.frameworks.stdlib.CompressBzip2
import semmle.go.frameworks.stdlib.CompressFlate
import semmle.go.frameworks.stdlib.CompressGzip
import semmle.go.frameworks.stdlib.CompressLzw
import semmle.go.frameworks.stdlib.CompressZlib
import semmle.go.frameworks.stdlib.ContainerHeap
import semmle.go.frameworks.stdlib.ContainerList
import semmle.go.frameworks.stdlib.ContainerRing
import semmle.go.frameworks.stdlib.Context
import semmle.go.frameworks.stdlib.Crypto
import semmle.go.frameworks.stdlib.CryptoCipher
import semmle.go.frameworks.stdlib.CryptoRsa
import semmle.go.frameworks.stdlib.CryptoTls
import semmle.go.frameworks.stdlib.CryptoX509
import semmle.go.frameworks.stdlib.DatabaseSql
import semmle.go.frameworks.stdlib.Encoding
import semmle.go.frameworks.stdlib.EncodingAscii85
import semmle.go.frameworks.stdlib.EncodingAsn1
import semmle.go.frameworks.stdlib.EncodingBase32
import semmle.go.frameworks.stdlib.EncodingBase64
import semmle.go.frameworks.stdlib.EncodingBinary
import semmle.go.frameworks.stdlib.EncodingCsv
import semmle.go.frameworks.stdlib.EncodingGob
import semmle.go.frameworks.stdlib.EncodingHex
import semmle.go.frameworks.stdlib.EncodingJson
import semmle.go.frameworks.stdlib.EncodingPem
import semmle.go.frameworks.stdlib.EncodingXml
import semmle.go.frameworks.stdlib.Errors
import semmle.go.frameworks.stdlib.Expvar
import semmle.go.frameworks.stdlib.Fmt
import semmle.go.frameworks.stdlib.Html
import semmle.go.frameworks.stdlib.HtmlTemplate
import semmle.go.frameworks.stdlib.Io
import semmle.go.frameworks.stdlib.IoFs
import semmle.go.frameworks.stdlib.IoIoutil
import semmle.go.frameworks.stdlib.Log
import semmle.go.frameworks.stdlib.Mime
import semmle.go.frameworks.stdlib.MimeMultipart
import semmle.go.frameworks.stdlib.MimeQuotedprintable
import semmle.go.frameworks.stdlib.Net
import semmle.go.frameworks.stdlib.NetHttp
import semmle.go.frameworks.stdlib.NetHttpHttputil
import semmle.go.frameworks.stdlib.NetMail
import semmle.go.frameworks.stdlib.NetTextproto
import semmle.go.frameworks.stdlib.Os
import semmle.go.frameworks.stdlib.Path
import semmle.go.frameworks.stdlib.PathFilepath
import semmle.go.frameworks.stdlib.Reflect
import semmle.go.frameworks.stdlib.Regexp
import semmle.go.frameworks.stdlib.Sort
import semmle.go.frameworks.stdlib.Strconv
import semmle.go.frameworks.stdlib.Strings
import semmle.go.frameworks.stdlib.Sync
import semmle.go.frameworks.stdlib.SyncAtomic
import semmle.go.frameworks.stdlib.Syscall
import semmle.go.frameworks.stdlib.TextScanner
import semmle.go.frameworks.stdlib.TextTabwriter
import semmle.go.frameworks.stdlib.TextTemplate

/** A `String()` method. */
class StringMethod extends TaintTracking::FunctionModel, Method {
  StringMethod() {
    getName() = "String" and
    getNumParameter() = 0 and
    getResultType(0) = Builtin::string_().getType()
  }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isReceiver() and outp.isResult()
  }
}

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
module URL {
  /** The `PathEscape` or `QueryEscape` function. */
  class Escaper extends TaintTracking::FunctionModel {
    Escaper() {
      hasQualifiedName("net/url", "PathEscape") or hasQualifiedName("net/url", "QueryEscape")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `PathUnescape` or `QueryUnescape` function. */
  class Unescaper extends TaintTracking::FunctionModel {
    Unescaper() {
      hasQualifiedName("net/url", "PathUnescape") or hasQualifiedName("net/url", "QueryUnescape")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  /** The `Parse`, `ParseQuery` or `ParseRequestURI` function, or the `URL.Parse` method. */
  class Parser extends TaintTracking::FunctionModel {
    Parser() {
      hasQualifiedName("net/url", "Parse") or
      this.(Method).hasQualifiedName("net/url", "URL", "Parse") or
      hasQualifiedName("net/url", "ParseQuery") or
      hasQualifiedName("net/url", "ParseRequestURI")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
      or
      this instanceof Method and
      inp.isReceiver() and
      outp.isResult(0)
    }
  }

  /** A method that returns a part of a URL. */
  class UrlGetter extends TaintTracking::FunctionModel, Method {
    UrlGetter() {
      exists(string m | hasQualifiedName("net/url", "URL", m) |
        m = ["EscapedPath", "Hostname", "Port", "Query", "RequestURI"]
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /** The method `URL.MarshalBinary`. */
  class UrlMarshalBinary extends TaintTracking::FunctionModel, Method {
    UrlMarshalBinary() { hasQualifiedName("net/url", "URL", "MarshalBinary") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  /** The method `URL.ResolveReference`. */
  class UrlResolveReference extends TaintTracking::FunctionModel, Method {
    UrlResolveReference() { hasQualifiedName("net/url", "URL", "ResolveReference") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      (inp.isReceiver() or inp.isParameter(0)) and
      outp.isResult()
    }
  }

  /** The function `User` or `UserPassword`. */
  class UserinfoConstructor extends TaintTracking::FunctionModel {
    UserinfoConstructor() {
      hasQualifiedName("net/url", "User") or
      hasQualifiedName("net/url", "UserPassword")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** A method that returns a part of a Userinfo struct. */
  class UserinfoGetter extends TaintTracking::FunctionModel, Method {
    UserinfoGetter() {
      exists(string m | hasQualifiedName("net/url", "Userinfo", m) |
        m = "Password" or
        m = "Username"
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  /** A method that returns all or part of a Values map. */
  class ValuesGetter extends TaintTracking::FunctionModel, Method {
    ValuesGetter() {
      exists(string m | hasQualifiedName("net/url", "Values", m) |
        m = "Encode" or
        m = "Get"
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }
}
