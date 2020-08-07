/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.ArchiveTar
import semmle.go.frameworks.stdlib.ArchiveZip
import semmle.go.frameworks.stdlib.Bufio
import semmle.go.frameworks.stdlib.Bytes

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

/** Provides models of commonly used functions in the `path/filepath` package. */
module PathFilePath {
  /** A path-manipulating function in the `path/filepath` package. */
  private class PathManipulatingFunction extends TaintTracking::FunctionModel {
    PathManipulatingFunction() {
      exists(string fn | hasQualifiedName("path/filepath", fn) |
        fn = "Abs" or
        fn = "Base" or
        fn = "Clean" or
        fn = "Dir" or
        fn = "EvalSymlinks" or
        fn = "Ext" or
        fn = "FromSlash" or
        fn = "Glob" or
        fn = "Join" or
        fn = "Rel" or
        fn = "Split" or
        fn = "SplitList" or
        fn = "ToSlash" or
        fn = "VolumeName"
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and
      outp.isResult(_)
    }
  }
}

/** Provides models of commonly used functions in the `fmt` package. */
module Fmt {
  /** The `Sprint` function or one of its variants. */
  class Sprinter extends TaintTracking::FunctionModel {
    Sprinter() { this.hasQualifiedName("fmt", ["Sprint", "Sprintf", "Sprintln"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** The `Print` function or one of its variants. */
  class Printer extends Function {
    Printer() { this.hasQualifiedName("fmt", ["Print", "Printf", "Println"]) }
  }

  /** A call to `Print`, `Fprint`, or similar. */
  private class PrintCall extends LoggerCall::Range, DataFlow::CallNode {
    int firstPrintedArg;

    PrintCall() {
      this.getTarget() instanceof Printer and firstPrintedArg = 0
      or
      this.getTarget() instanceof Fprinter and firstPrintedArg = 1
    }

    override DataFlow::Node getAMessageComponent() {
      result = this.getArgument(any(int i | i >= firstPrintedArg))
    }
  }

  /** The `Fprint` function or one of its variants. */
  private class Fprinter extends TaintTracking::FunctionModel {
    Fprinter() { this.hasQualifiedName("fmt", ["Fprint", "Fprintf", "Fprintln"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(any(int i | i > 0)) and output.isParameter(0)
    }
  }

  /** The `Sscan` function or one of its variants. */
  private class Sscanner extends TaintTracking::FunctionModel {
    Sscanner() { this.hasQualifiedName("fmt", ["Sscan", "Sscanf", "Sscanln"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and
      exists(int i | if getName() = "Sscanf" then i > 1 else i > 0 | output.isParameter(i))
    }
  }

  /** The `Scan` function or one of its variants, all of which read from os.Stdin */
  class Scanner extends Function {
    Scanner() { this.hasQualifiedName("fmt", ["Scan", "Scanf", "Scanln"]) }
  }

  /** A call to a `Scanner`. */
  class ScannerCall extends DataFlow::CallNode {
    ScannerCall() { this.getTarget() instanceof Scanner }
  }

  /**
   * The `Fscan` function or one of its variants,
   * all of which read from a specified io.Reader
   */
  class FScanner extends Function {
    FScanner() { this.hasQualifiedName("fmt", ["Fscan", "Fscanf", "Fscanln"]) }
  }

  /** A call to a `FScanner`. */
  class FScannerCall extends DataFlow::CallNode {
    FScannerCall() { this.getTarget() instanceof FScanner }

    /**
     * Returns the node corresponding to the io.Reader
     * argument provided in the call.
     */
    DataFlow::Node getReader() { result = this.getArgument(0) }
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

/** Provides models of commonly used functions in the `os` package. */
module OS {
  /**
   * A call to a function in `os` that accesses the file system.
   */
  private class OsFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathidx;

    OsFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("os", fn) |
        fn = "Chdir" and pathidx = 0
        or
        fn = "Chmod" and pathidx = 0
        or
        fn = "Chown" and pathidx = 0
        or
        fn = "Chtimes" and pathidx = 0
        or
        fn = "Create" and pathidx = 0
        or
        fn = "Lchown" and pathidx = 0
        or
        fn = "Link" and pathidx in [0 .. 1]
        or
        fn = "Lstat" and pathidx = 0
        or
        fn = "Mkdir" and pathidx = 0
        or
        fn = "MkdirAll" and pathidx = 0
        or
        fn = "NewFile" and pathidx = 1
        or
        fn = "Open" and pathidx = 0
        or
        fn = "OpenFile" and pathidx = 0
        or
        fn = "Readlink" and pathidx = 0
        or
        fn = "Remove" and pathidx = 0
        or
        fn = "RemoveAll" and pathidx = 0
        or
        fn = "Rename" and pathidx in [0 .. 1]
        or
        fn = "Stat" and pathidx = 0
        or
        fn = "Symlink" and pathidx in [0 .. 1]
        or
        fn = "Truncate" and pathidx = 0
      )
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(pathidx) }
  }

  /** The `Expand` function. */
  class Expand extends TaintTracking::FunctionModel {
    Expand() { hasQualifiedName("os", "Expand") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `ExpandEnv` function. */
  class ExpandEnv extends TaintTracking::FunctionModel {
    ExpandEnv() { hasQualifiedName("os", "ExpandEnv") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `os.Exit` function, which ends the process. */
  private class Exit extends Function {
    Exit() { hasQualifiedName("os", "Exit") }

    override predicate mayReturnNormally() { none() }
  }
}

/** Provides models of commonly used functions in the `path` package. */
module Path {
  /** A path-manipulating function in the `path` package. */
  class PathManipulatingFunction extends TaintTracking::FunctionModel {
    PathManipulatingFunction() {
      exists(string fn | hasQualifiedName("path", fn) |
        fn = "Base" or
        fn = "Clean" or
        fn = "Dir" or
        fn = "Ext" or
        fn = "Join" or
        fn = "Split"
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and
      outp.isResult(_)
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
     * return value, if this makes sense, where 0 represents the bit
     * size of `int` and `uint`.
     */
    FunctionInput getTargetBitSizeInput() { none() }
  }
}

/**
 * Provides classes for some functions in the `strconv` package for
 * converting strings to numbers.
 */
module StrConv {
  /** The `Atoi` function. */
  class Atoi extends IntegerParser::Range {
    Atoi() { this.hasQualifiedName("strconv", "Atoi") }

    override int getTargetBitSize() { result = 0 }
  }

  /** The `ParseInt` function. */
  class ParseInt extends IntegerParser::Range {
    ParseInt() { this.hasQualifiedName("strconv", "ParseInt") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }
  }

  /** The `ParseUint` function. */
  class ParseUint extends IntegerParser::Range {
    ParseUint() { this.hasQualifiedName("strconv", "ParseUint") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }
  }

  /**
   * The `IntSize` constant, that gives the size in bits of an `int` or
   * `uint` value on the current architecture (32 or 64).
   */
  class IntSize extends DeclaredConstant {
    IntSize() { this.hasQualifiedName("strconv", "IntSize") }
  }
}

/** Provides models of commonly used functions in the `strings` package. */
module Strings {
  /** The `Join` function. */
  class Join extends TaintTracking::FunctionModel {
    Join() { hasQualifiedName("strings", "Join") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter([0 .. 1]) and outp.isResult()
    }
  }

  /** The `Repeat` function. */
  class Repeat extends TaintTracking::FunctionModel {
    Repeat() { hasQualifiedName("strings", "Repeat") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `Replace` or `ReplaceAll` function. */
  class Replacer extends TaintTracking::FunctionModel {
    Replacer() {
      hasQualifiedName("strings", "Replace") or hasQualifiedName("strings", "ReplaceAll")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(2)) and
      outp.isResult()
    }
  }

  /** The `Split` function or one of its variants. */
  class Splitter extends TaintTracking::FunctionModel {
    Splitter() {
      exists(string split | split.matches("Split%") | hasQualifiedName("strings", split))
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** One of the case-converting functions in the `strings` package. */
  class CaseConverter extends TaintTracking::FunctionModel {
    CaseConverter() {
      exists(string conv | conv.matches("To%") | hasQualifiedName("strings", conv))
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(getNumParameter() - 1) and outp.isResult()
    }
  }

  /** The `Trim` function or one of its variants. */
  class Trimmer extends TaintTracking::FunctionModel {
    Trimmer() { exists(string split | split.matches("Trim%") | hasQualifiedName("strings", split)) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }
}

/** Provides models of commonly used functions in the `text/template` package. */
module Template {
  private class TemplateEscape extends EscapeFunction::Range {
    string kind;

    TemplateEscape() {
      exists(string fn |
        fn.matches("HTMLEscape%") and kind = "html"
        or
        fn.matches("JSEscape%") and kind = "js"
        or
        fn.matches("URLQueryEscape%") and kind = "url"
      |
        this.hasQualifiedName("text/template", fn)
        or
        this.hasQualifiedName("html/template", fn)
      )
    }

    override string kind() { result = kind }
  }

  private class TextTemplateInstantiation extends TemplateInstantiation::Range,
    DataFlow::MethodCallNode {
    int dataArg;

    TextTemplateInstantiation() {
      exists(string m | getTarget().hasQualifiedName("text/template", "Template", m) |
        m = "Execute" and
        dataArg = 1
        or
        m = "ExecuteTemplate" and
        dataArg = 2
      )
    }

    override DataFlow::Node getTemplateArgument() { result = this.getReceiver() }

    override DataFlow::Node getADataArgument() { result = this.getArgument(dataArg) }
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

/** Provides models of commonly used APIs in the `regexp` package. */
module Regexp {
  private class Pattern extends RegexpPattern::Range, DataFlow::ArgumentNode {
    string fnName;

    Pattern() {
      exists(Function fn | fnName.matches("Match%") or fnName.matches("%Compile%") |
        fn.hasQualifiedName("regexp", fnName) and
        this = fn.getACall().getArgument(0)
      )
    }

    override DataFlow::Node getAParse() { result = this.getCall() }

    override string getPattern() { result = this.asExpr().getStringValue() }

    override DataFlow::Node getAUse() {
      fnName.matches("MustCompile%") and
      result = this.getCall().getASuccessor*()
      or
      fnName.matches("Compile%") and
      result = this.getCall().getResult(0).getASuccessor*()
      or
      result = this
    }
  }

  private class MatchFunction extends RegexpMatchFunction::Range, Function {
    MatchFunction() {
      exists(string fn | fn.matches("Match%") | this.hasQualifiedName("regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isParameter(0) }

    override FunctionInput getValue() { result.isParameter(1) }

    override FunctionOutput getResult() { result.isResult(0) }
  }

  private class MatchMethod extends RegexpMatchFunction::Range, Method {
    MatchMethod() {
      exists(string fn | fn.matches("Match%") | this.hasQualifiedName("regexp", "Regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isReceiver() }

    override FunctionInput getValue() { result.isParameter(0) }

    override FunctionOutput getResult() { result.isResult() }
  }

  private class ReplaceFunction extends RegexpReplaceFunction::Range, Method {
    ReplaceFunction() {
      exists(string fn | fn.matches("ReplaceAll%") | this.hasQualifiedName("regexp", "Regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isReceiver() }

    override FunctionInput getSource() { result.isParameter(0) }

    override FunctionOutput getResult() { result.isResult() }
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

/** Provides models of some functions in the `encoding/json` package. */
module EncodingJson {
  /** The `Marshal` or `MarshalIndent` function in the `encoding/json` package. */
  class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() {
      this.hasQualifiedName("encoding/json", "Marshal") or
      this.hasQualifiedName("encoding/json", "MarshalIndent")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "JSON" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/json", "Unmarshal") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "JSON" }
  }
}

/** Provides models of some functions in the `encoding/hex` package. */
module EncodingHex {
  private class DecodeStringFunction extends TaintTracking::FunctionModel {
    DecodeStringFunction() { this.hasQualifiedName("encoding/hex", "DecodeString") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
    }
  }
}

/** Provides models of some functions in the `crypto/cipher` package. */
module CryptoCipher {
  private class AeadOpenFunction extends TaintTracking::FunctionModel, Method {
    AeadOpenFunction() { this.hasQualifiedName("crypto/cipher", "AEAD", "Open") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(2) and
      outp.isResult(0)
    }
  }
}
