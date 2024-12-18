/**
 * Provides classes modeling security-relevant aspects of the `regexp` package.
 */

import go

/** Provides models of commonly used functions in the `regexp` package. */
module Regexp {
  /**
   * Holds if `kind` is an external sink kind that is relevant for regex flow.
   * `strArg` is the index of the argument to methods with this sink kind that
   * contain the string to be matched against, where "receiver" indicates the
   * receiver; or -2  if no such argument exists and the function compiles the
   * regex; or -3 if no such argument exists and the function does not compile
   * the regex.
   *
   * So `regex-use[0]` indicates that argument 0 contains the string to matched
   * against, `regex-use[c]` indicates that there is no string to be matched
   * against and the return value of the function is a compiled regex, and
   * `regex-use` means that there is no string to be matched against and the
   * function does not compile the regex.
   */
  private predicate regexSinkKindInfo(string kind, int strArg) {
    strArg = -3 and
    kind = "regex-use"
    or
    sinkModel(_, _, _, _, _, _, _, kind, _, _) and
    exists(string strArgStr |
      strArg >= 0 and
      strArgStr.toInt() = strArg
      or
      strArg = -1 and
      strArgStr = "receiver"
      or
      strArg = -2 and
      strArgStr = "c"
    |
      kind = "regex-use[" + strArgStr + "]"
    )
  }

  private class DefaultRegexpPattern extends RegexpPattern::Range, DataFlow::ArgumentNode {
    int strArg;

    DefaultRegexpPattern() {
      exists(string kind |
        regexSinkKindInfo(kind, strArg) and
        sinkNode(this, kind)
      )
    }

    override DataFlow::Node getAParse() { result = this.getCall() }

    override string getPattern() { result = this.asExpr().getStringValue() }

    override DataFlow::Node getAUse() {
      strArg = -2 and
      result = this.getCall().getResult(0).getASuccessor*()
      or
      result = this
    }
  }

  private class DefaultRegexpMatchFunction extends RegexpMatchFunction::Range, Function {
    int patArg;
    int strArg;

    DefaultRegexpMatchFunction() {
      exists(DefaultRegexpPattern drp, string kind |
        drp.getCall() = this.getACall() and
        sinkNode(drp, kind)
      |
        patArg = drp.getPosition() and
        regexSinkKindInfo(kind, strArg) and
        strArg >= -1
      )
    }

    override FunctionInput getRegexpArg() {
      patArg = -1 and result.isReceiver()
      or
      patArg >= 0 and result.isParameter(patArg)
    }

    override FunctionInput getValue() { result.isParameter(strArg) }

    override FunctionOutput getResult() { result.isResult(0) }
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
