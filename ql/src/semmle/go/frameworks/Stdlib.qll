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
import semmle.go.frameworks.stdlib.Fmt
import semmle.go.frameworks.stdlib.Crypto
import semmle.go.frameworks.stdlib.CryptoCipher
import semmle.go.frameworks.stdlib.Mime
import semmle.go.frameworks.stdlib.MimeMultipart
import semmle.go.frameworks.stdlib.MimeQuotedprintable
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
import semmle.go.frameworks.stdlib.Html
import semmle.go.frameworks.stdlib.HtmlTemplate
import semmle.go.frameworks.stdlib.Context
import semmle.go.frameworks.stdlib.Os
import semmle.go.frameworks.stdlib.Net
import semmle.go.frameworks.stdlib.NetHttp
import semmle.go.frameworks.stdlib.NetHttpHttputil
import semmle.go.frameworks.stdlib.NetMail
import semmle.go.frameworks.stdlib.NetTextproto
import semmle.go.frameworks.stdlib.Path
import semmle.go.frameworks.stdlib.PathFilepath
import semmle.go.frameworks.stdlib.Reflect
import semmle.go.frameworks.stdlib.Strconv
import semmle.go.frameworks.stdlib.Strings
import semmle.go.frameworks.stdlib.Sync
import semmle.go.frameworks.stdlib.SyncAtomic
import semmle.go.frameworks.stdlib.Syscall
import semmle.go.frameworks.stdlib.Sort
import semmle.go.frameworks.stdlib.Regexp
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

/** Provides models of commonly used functions in the `io` package. */
module Io {
  private class Copy extends TaintTracking::FunctionModel {
    Copy() {
      // func Copy(dst Writer, src Reader) (written int64, err error)
      // func CopyBuffer(dst Writer, src Reader, buf []byte) (written int64, err error)
      // func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
      hasQualifiedName("io", "Copy") or
      hasQualifiedName("io", "CopyBuffer") or
      hasQualifiedName("io", "CopyN")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(1) and output.isParameter(0)
    }
  }

  private class Pipe extends TaintTracking::FunctionModel {
    Pipe() {
      // func Pipe() (*PipeReader, *PipeWriter)
      hasQualifiedName("io", "Pipe")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult(0) and output.isResult(1)
    }
  }

  private class ReadAtLeast extends TaintTracking::FunctionModel {
    ReadAtLeast() {
      // func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)
      // func ReadFull(r Reader, buf []byte) (n int, err error)
      hasQualifiedName("io", "ReadAtLeast") or
      hasQualifiedName("io", "ReadFull")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isParameter(1)
    }
  }

  private class WriteString extends TaintTracking::FunctionModel {
    WriteString() {
      // func WriteString(w Writer, s string) (n int, err error)
      this.hasQualifiedName("io", "WriteString")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(1) and output.isParameter(0)
    }
  }

  private class ByteReaderReadByte extends TaintTracking::FunctionModel, Method {
    ByteReaderReadByte() {
      // func ReadByte() (byte, error)
      this.implements("io", "ByteReader", "ReadByte")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isResult(0)
    }
  }

  private class ByteWriterWriteByte extends TaintTracking::FunctionModel, Method {
    ByteWriterWriteByte() {
      // func WriteByte(c byte) error
      this.implements("io", "ByteWriter", "WriteByte")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class ReaderRead extends TaintTracking::FunctionModel, Method {
    ReaderRead() {
      // func Read(p []byte) (n int, err error)
      this.implements("io", "Reader", "Read")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }

  private class LimitReader extends TaintTracking::FunctionModel {
    LimitReader() {
      // func LimitReader(r Reader, n int64) Reader
      this.hasQualifiedName("io", "LimitReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class MultiReader extends TaintTracking::FunctionModel {
    MultiReader() {
      // func MultiReader(readers ...Reader) Reader
      this.hasQualifiedName("io", "MultiReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(_) and output.isResult()
    }
  }

  private class TeeReader extends TaintTracking::FunctionModel {
    TeeReader() {
      // func TeeReader(r Reader, w Writer) Reader
      this.hasQualifiedName("io", "TeeReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
      or
      input.isParameter(0) and output.isParameter(1)
    }
  }

  private class ReaderAtReadAt extends TaintTracking::FunctionModel, Method {
    ReaderAtReadAt() {
      // func ReadAt(p []byte, off int64) (n int, err error)
      this.implements("io", "ReaderAt", "ReadAt")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }

  private class ReaderFromReadFrom extends TaintTracking::FunctionModel, Method {
    ReaderFromReadFrom() {
      // func ReadFrom(r Reader) (n int64, err error)
      this.implements("io", "ReaderFrom", "ReadFrom")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class RuneReaderReadRune extends TaintTracking::FunctionModel, Method {
    RuneReaderReadRune() {
      // func ReadRune() (r rune, size int, err error)
      this.implements("io", "RuneReader", "ReadRune")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isResult(0)
    }
  }

  private class NewSectionReader extends TaintTracking::FunctionModel {
    NewSectionReader() {
      // func NewSectionReader(r ReaderAt, off int64, n int64) *SectionReader
      this.hasQualifiedName("io", "NewSectionReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class StringWriterWriteString extends TaintTracking::FunctionModel, Method {
    StringWriterWriteString() {
      // func WriteString(s string) (n int, err error)
      this.implements("io", "StringWriter", "WriteString")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() {
      // func Write(p []byte) (n int, err error)
      this.implements("io", "Writer", "Write")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class MultiWriter extends TaintTracking::FunctionModel {
    MultiWriter() {
      // func MultiWriter(writers ...Writer) Writer
      hasQualifiedName("io", "MultiWriter")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult() and output.isParameter(_)
    }
  }

  private class WriterAtWriteAt extends TaintTracking::FunctionModel, Method {
    WriterAtWriteAt() {
      // func WriteAt(p []byte, off int64) (n int, err error)
      this.implements("io", "WriterAt", "WriteAt")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class WriterToWriteTo extends TaintTracking::FunctionModel, Method {
    WriterToWriteTo() {
      // func WriteTo(w Writer) (n int64, err error)
      this.implements("io", "WriterTo", "WriteTo")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }
}

/** Provides models of commonly used functions in the `io/ioutil` package. */
module IoUtil {
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("io/ioutil", fn) |
        fn = "ReadDir" or
        fn = "ReadFile" or
        fn = "TempDir" or
        fn = "TempFile" or
        fn = "WriteFile"
      )
    }

    override DataFlow::Node getAPathArgument() { result = getAnArgument() }
  }

  /**
   * A taint model of the `ioutil.ReadAll` function, recording that it propagates taint
   * from its first argument to its first result.
   */
  private class ReadAll extends TaintTracking::FunctionModel {
    ReadAll() { hasQualifiedName("io/ioutil", "ReadAll") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
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
        m = "EscapedPath" or
        m = "Hostname" or
        m = "Port" or
        m = "Query" or
        m = "RequestURI"
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

/** Provides models of commonly used functions in the `log` package. */
module Log {
  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() {
      exists(string fn |
        fn.matches("Fatal%")
        or
        fn.matches("Panic%")
        or
        fn.matches("Print%")
      |
        this.getTarget().hasQualifiedName("log", fn)
        or
        this.getTarget().(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  /** A fatal log function, which calls `os.Exit`. */
  private class FatalLogFunction extends Function {
    FatalLogFunction() { exists(string fn | fn.matches("Fatal%") | hasQualifiedName("log", fn)) }

    override predicate mayReturnNormally() { none() }
  }
}
