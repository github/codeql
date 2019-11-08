/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go

/** A `String()` method. */
class StringMethod extends TaintTracking::FunctionModel, Method {
  StringMethod() { getName() = "String" and getNumParameter() = 0 }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isReceiver() and outp.isResult()
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and
      (outp.isResult() or outp.isResult(_))
    }
  }
}

/** Provides models of commonly used functions in the `fmt` package. */
module Fmt {
  /** The `Sprint` function or one of its variants. */
  class Sprinter extends TaintTracking::FunctionModel {
    Sprinter() {
      exists(string sprint | sprint.matches("Sprint%") | hasQualifiedName("fmt", sprint))
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  private class PrintCall extends LoggerCall::Range, DataFlow::CallNode {
    PrintCall() {
      exists(string fn |
        fn = "Print%"
        or
        fn = "Fprint%"
      |
        this.getTarget().hasQualifiedName("fmt", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}

/** Provides models of commonly used functions in the `io/ioutil` package. */
module IoUtil {
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("io/ioutil", fn) |
        fn = "ReadDir" or
        fn = "ReadFile" or
        fn = "WriteFile"
      )
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `ExpandEnv` function. */
  class ExpandEnv extends TaintTracking::FunctionModel {
    ExpandEnv() { hasQualifiedName("os", "ExpandEnv") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }
}

/** Provides models of commonly used functions in the `path` package. */
module Path {
  /** A path-manipulating function in the `path` package. */
  private class PathManipulatingFunction extends TaintTracking::FunctionModel {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and
      (outp.isResult() or outp.isResult(_))
    }
  }
}

/** Provides models of commonly used functions in the `strings` package. */
module Strings {
  /** The `Join` function. */
  class Join extends TaintTracking::FunctionModel {
    Join() { hasQualifiedName("strings", "Join") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter([0 .. 1]) and outp.isResult()
    }
  }

  /** The `Repeat` function. */
  class Repeat extends TaintTracking::FunctionModel {
    Repeat() { hasQualifiedName("strings", "Repeat") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `Replace` or `ReplaceAll` function. */
  class Replacer extends TaintTracking::FunctionModel {
    Replacer() {
      hasQualifiedName("strings", "Replace") or hasQualifiedName("strings", "ReplaceAll")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(2)) and
      outp.isResult()
    }
  }

  /** The `Split` function or one of its variants. */
  class Splitter extends TaintTracking::FunctionModel {
    Splitter() {
      exists(string split | split.matches("Split%") | hasQualifiedName("strings", split))
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** One of the case-converting functions in the `strings` package. */
  class CaseConverter extends TaintTracking::FunctionModel {
    CaseConverter() {
      exists(string conv | conv.matches("To%") | hasQualifiedName("strings", conv))
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(getNumParameter() - 1) and outp.isResult()
    }
  }

  /** The `Trim` function or one of its variants. */
  class Trimmer extends TaintTracking::FunctionModel {
    Trimmer() { exists(string split | split.matches("Trim%") | hasQualifiedName("strings", split)) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `PathUnescape` or `QueryUnescape` function. */
  class Unescaper extends TaintTracking::FunctionModel {
    Unescaper() {
      hasQualifiedName("net/url", "PathUnescape") or hasQualifiedName("net/url", "QueryUnescape")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /** The method `URL.MarshalBinary`. */
  class UrlMarshalBinary extends TaintTracking::FunctionModel, Method {
    UrlMarshalBinary() { hasQualifiedName("net/url", "URL", "MarshalBinary") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  /** The method `URL.ResolveReference`. */
  class UrlResolveReference extends TaintTracking::FunctionModel, Method {
    UrlResolveReference() { hasQualifiedName("net/url", "URL", "ResolveReference") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and
      if getName() = "Password" then outp.isResult(0) else outp.isResult()
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

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }
}

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
}

/** Provides models of some functions in the `encoding/json` package. */
module EncodingJson {
  private class MarshalFunction extends TaintTracking::FunctionModel {
    MarshalFunction() {
      this.hasQualifiedName("encoding/json", "Marshal") or
      this.hasQualifiedName("encoding/json", "MarshalIndent")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
    }
  }
}

/** Provides models of some functions in the `encoding/hex` package. */
module EncodingHex {
  private class DecodeStringFunction extends TaintTracking::FunctionModel {
    DecodeStringFunction() { this.hasQualifiedName("encoding/hex", "DecodeString") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
    }
  }
}

/** Provides models of some functions in the `crypto/cipher` package. */
module CryptoCipher {
  private class AeadOpenFunction extends TaintTracking::FunctionModel, Method {
    AeadOpenFunction() { this.hasQualifiedName("crypto/cipher", "AEAD", "Open") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(2) and
      outp.isResult(0)
    }
  }
}
