/**
 * Provides classes modeling security-relevant aspects of the `regexp` package.
 */

import go

/** Provides models of commonly used functions in the `regexp` package. */
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

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func QuoteMeta(s string) string
      this.hasQualifiedName("regexp", "QuoteMeta") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Regexp) Expand(dst []byte, template []byte, src []byte, match []int) []byte
      this.hasQualifiedName("regexp", "Regexp", "Expand") and
      (
        inp.isParameter([1, 2]) and
        (outp.isParameter(0) or outp.isResult())
      )
      or
      // signature: func (*Regexp) ExpandString(dst []byte, template string, src string, match []int) []byte
      this.hasQualifiedName("regexp", "Regexp", "ExpandString") and
      (
        inp.isParameter([1, 2]) and
        (outp.isParameter(0) or outp.isResult())
      )
      or
      // signature: func (*Regexp) Find(b []byte) []byte
      this.hasQualifiedName("regexp", "Regexp", "Find") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindAll(b []byte, n int) [][]byte
      this.hasQualifiedName("regexp", "Regexp", "FindAll") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindAllString(s string, n int) []string
      this.hasQualifiedName("regexp", "Regexp", "FindAllString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindAllStringSubmatch(s string, n int) [][]string
      this.hasQualifiedName("regexp", "Regexp", "FindAllStringSubmatch") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindAllSubmatch(b []byte, n int) [][][]byte
      this.hasQualifiedName("regexp", "Regexp", "FindAllSubmatch") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindString(s string) string
      this.hasQualifiedName("regexp", "Regexp", "FindString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindStringSubmatch(s string) []string
      this.hasQualifiedName("regexp", "Regexp", "FindStringSubmatch") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) FindSubmatch(b []byte) [][]byte
      this.hasQualifiedName("regexp", "Regexp", "FindSubmatch") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAll(src []byte, repl []byte) []byte
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAll") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAllFunc(src []byte, repl func([]byte) []byte) []byte
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAllFunc") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAllLiteral(src []byte, repl []byte) []byte
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAllLiteral") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAllLiteralString(src string, repl string) string
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAllLiteralString") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAllString(src string, repl string) string
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAllString") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) ReplaceAllStringFunc(src string, repl func(string) string) string
      this.hasQualifiedName("regexp", "Regexp", "ReplaceAllStringFunc") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func (*Regexp) Split(s string, n int) []string
      this.hasQualifiedName("regexp", "Regexp", "Split") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
