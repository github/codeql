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
}
