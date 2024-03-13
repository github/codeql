/**
 * Provides classes and predicates for reasoning about string formatting.
 */

import swift

/**
 * A function that takes a `printf` style format argument.
 */
abstract class FormattingFunction extends Function {
  /**
   * Gets the position of the format argument.
   */
  abstract int getFormatParameterIndex();
}

/**
 * A call to a function that takes a `printf` style format argument.
 */
class FormattingFunctionCall extends CallExpr {
  FormattingFunction target;

  FormattingFunctionCall() { target = this.getStaticTarget() }

  /**
   * Gets the format expression used in this call.
   */
  Expr getFormat() { result = this.getArgument(target.getFormatParameterIndex()).getExpr() }
}

/**
 * An initializer for `String`, `NSString` or `NSMutableString` that takes a
 * `printf` style format argument.
 */
class StringInitWithFormat extends FormattingFunction, Method {
  StringInitWithFormat() {
    exists(string fName |
      this.hasQualifiedName(["String", "NSString", "NSMutableString"], fName) and
      fName.matches("init(format:%")
    )
  }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The `localizedStringWithFormat` method of `String`, `NSString` and `NSMutableString`.
 */
class LocalizedStringWithFormat extends FormattingFunction, Method {
  LocalizedStringWithFormat() {
    this.hasQualifiedName(["String", "NSString", "NSMutableString"],
      "localizedStringWithFormat(_:_:)")
  }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * A method that appends a formatted string.
 */
class StringMethodWithFormat extends FormattingFunction, Method {
  StringMethodWithFormat() {
    this.hasQualifiedName("NSMutableString", "appendFormat(_:_:)")
    or
    this.hasQualifiedName("StringProtocol", "appendingFormat(_:_:)")
  }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The functions `NSLog` and `NSLogv`.
 */
class NsLog extends FormattingFunction, FreeFunction {
  NsLog() { this.getName() = ["NSLog(_:_:)", "NSLogv(_:_:)"] }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The `NSException.init` and `NSException.raise` methods.
 */
class NsExceptionRaise extends FormattingFunction, Method {
  NsExceptionRaise() {
    this.hasQualifiedName("NSException", "init(name:reason:userInfo:)") or
    this.hasQualifiedName("NSException", "raise(_:format:arguments:)")
  }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * A function that appears to be an imported C `printf` variant.
 */
class PrintfFormat extends FormattingFunction, FreeFunction {
  int formatParamIndex;
  string modeChars;

  PrintfFormat() {
    modeChars = this.getShortName().regexpCapture("(.*)printf.*", 1) and
    this.getParam(formatParamIndex).getName() = "format"
  }

  override int getFormatParameterIndex() { result = formatParamIndex }

  /**
   * Holds if this `printf` is a variant of `sprintf`.
   */
  predicate isSprintf() { modeChars.charAt(_) = "s" }
}
