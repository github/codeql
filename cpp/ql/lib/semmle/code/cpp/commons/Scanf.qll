/**
 * A library for dealing with scanf-like formatting strings.  This is similar to
 * printf.qll but the format specification for scanf is quite different.
 */

import semmle.code.cpp.Type

/**
 * A `scanf`-like standard library function.
 */
abstract class ScanfFunction extends Function {
  /**
   * Gets the position at which the input string or stream parameter occurs,
   * if this function does not read from standard input.
   */
  abstract int getInputParameterIndex();

  /**
   * Gets the position at which the format parameter occurs.
   */
  abstract int getFormatParameterIndex();

  /**
   * Holds if the default meaning of `%s` is a `wchar_t*` string
   * (rather than a `char*`).
   */
  predicate isWideCharDefault() { exists(this.getName().indexOf("wscanf")) }
}

/**
 * The standard function `scanf` (and variations).
 */
class Scanf extends ScanfFunction instanceof TopLevelFunction {
  Scanf() {
    this.hasGlobalOrStdOrBslName("scanf") or // scanf(format, args...)
    this.hasGlobalOrStdOrBslName("wscanf") or // wscanf(format, args...)
    this.hasGlobalName("_scanf_l") or // _scanf_l(format, locale, args...)
    this.hasGlobalName("_wscanf_l")
  }

  override int getInputParameterIndex() { none() }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The standard function `fscanf` (and variations).
 */
class Fscanf extends ScanfFunction instanceof TopLevelFunction {
  Fscanf() {
    this.hasGlobalOrStdOrBslName("fscanf") or // fscanf(src_stream, format, args...)
    this.hasGlobalOrStdOrBslName("fwscanf") or // fwscanf(src_stream, format, args...)
    this.hasGlobalName("_fscanf_l") or // _fscanf_l(src_stream, format, locale, args...)
    this.hasGlobalName("_fwscanf_l")
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * The standard function `sscanf` (and variations).
 */
class Sscanf extends ScanfFunction instanceof TopLevelFunction {
  Sscanf() {
    this.hasGlobalOrStdOrBslName("sscanf") or // sscanf(src_stream, format, args...)
    this.hasGlobalOrStdOrBslName("swscanf") or // swscanf(src, format, args...)
    this.hasGlobalName("_sscanf_l") or // _sscanf_l(src, format, locale, args...)
    this.hasGlobalName("_swscanf_l")
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * The standard(ish) function `snscanf` (and variations).
 */
class Snscanf extends ScanfFunction instanceof TopLevelFunction {
  Snscanf() {
    this.hasGlobalName("_snscanf") or // _snscanf(src, max_amount, format, args...)
    this.hasGlobalName("_snwscanf") or // _snwscanf(src, max_amount, format, args...)
    this.hasGlobalName("_snscanf_l") or // _snscanf_l(src, max_amount, format, locale, args...)
    this.hasGlobalName("_snwscanf_l")
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 2 }

  /**
   * Gets the position at which the maximum number of characters in the
   * input string is specified.
   */
  int getInputLengthParameterIndex() { result = 1 }
}

/**
 * A call to one of the `scanf` functions.
 */
class ScanfFunctionCall extends FunctionCall {
  ScanfFunctionCall() { this.getTarget() instanceof ScanfFunction }

  /**
   * Gets the `scanf`-like function that is called.
   */
  ScanfFunction getScanfFunction() { result = this.getTarget() }

  /**
   * Gets the position at which the input string or stream parameter occurs,
   * if this function call does not read from standard input.
   */
  int getInputParameterIndex() { result = this.getScanfFunction().getInputParameterIndex() }

  /**
   * Gets the position at which the format parameter occurs.
   */
  int getFormatParameterIndex() { result = this.getScanfFunction().getFormatParameterIndex() }

  /**
   * Gets the format expression used in this call.
   */
  Expr getFormat() { result = this.getArgument(this.getFormatParameterIndex()) }

  /**
   * Holds if the default meaning of `%s` is a `wchar_t*` string
   * (rather than a `char*`).
   */
  predicate isWideCharDefault() { this.getScanfFunction().isWideCharDefault() }

  /**
   * Gets the output argument at position `n` in the vararg list of this call.
   *
   * The range of `n` is from `0` to `this.getNumberOfOutputArguments() - 1`.
   */
  Expr getOutputArgument(int n) {
    result = this.getArgument(this.getTarget().getNumberOfParameters() + n) and
    n >= 0
  }

  /**
   * Gets an output argument given to this call in vararg position.
   */
  Expr getAnOutputArgument() { result = this.getOutputArgument(_) }

  /**
   * Gets the number of output arguments present in this call.
   */
  int getNumberOfOutputArguments() {
    result = this.getNumberOfArguments() - this.getTarget().getNumberOfParameters()
  }
}

/**
 * A class to represent format strings that occur as arguments to invocations of `scanf` functions.
 */
class ScanfFormatLiteral extends Expr {
  ScanfFormatLiteral() {
    exists(ScanfFunctionCall sfc | sfc.getFormat() = this) and
    this.isConstant()
  }

  /** the function call where this format string is used */
  ScanfFunctionCall getUse() { result.getFormat() = this }

  /** Holds if the default meaning of `%s` is a `wchar_t*` (rather than a `char*`). */
  predicate isWideCharDefault() { this.getUse().getTarget().(ScanfFunction).isWideCharDefault() }

  /**
   * Gets the format string itself, transformed as follows:
   *  - '%%' is replaced with '_'
   *    (this avoids accidentally processing them as format specifiers)
   *  - '%*' is replaced with '_'
   *    (%*any is matched but not assigned to an argument)
   */
  string getFormat() { result = this.getValue().replaceAll("%%", "_").replaceAll("%*", "_") }

  /**
   * Gets the number of conversion specifiers (not counting `%%` and `%*`...).
   */
  int getNumConvSpec() { result = count(this.getFormat().indexOf("%")) }

  /**
   * Gets the position in the string at which the nth conversion specifier starts.
   */
  int getConvSpecOffset(int n) {
    n = 0 and result = this.getFormat().indexOf("%", 0, 0)
    or
    n > 0 and
    exists(int p |
      n = p + 1 and result = this.getFormat().indexOf("%", 0, this.getConvSpecOffset(p) + 2)
    )
  }

  /**
   * Gets the regular expression to match each individual part of a conversion specifier.
   */
  private string getMaxWidthRegexp() { result = "(?:[1-9][0-9]*)?" }

  private string getLengthRegexp() { result = "(?:hh?|ll?|L|q|j|z|t)?" }

  private string getConvCharRegexp() { result = "[aAcCdeEfFgGimnopsSuxX]" }

  /**
   * Gets the regular expression used for matching a whole conversion specifier.
   */
  string getConvSpecRegexp() {
    // capture groups: 1 - entire conversion spec, including "%"
    //                 2 - maximum width
    //                 3 - length modifier
    //                 4 - conversion character
    result =
      "(\\%(" + this.getMaxWidthRegexp() + ")(" + this.getLengthRegexp() + ")(" +
        this.getConvCharRegexp() + ")).*"
  }

  /**
   * Holds if the arguments are a parsing of a conversion specifier to this
   * format string, where `n` is which conversion specifier to parse, `spec` is
   * the whole conversion specifier, `width` is the maximum width option of
   * this input, `len` is the length flag of this input, and `conv` is the
   * conversion character of this input.
   *
   * Each parameter is the empty string if no value is given by the conversion
   * specifier.
   */
  predicate parseConvSpec(int n, string spec, string width, string len, string conv) {
    exists(int offset, string fmt, string rst, string regexp |
      offset = this.getConvSpecOffset(n) and
      fmt = this.getFormat() and
      rst = fmt.substring(offset, fmt.length()) and
      regexp = this.getConvSpecRegexp() and
      (
        spec = rst.regexpCapture(regexp, 1) and
        width = rst.regexpCapture(regexp, 2) and
        len = rst.regexpCapture(regexp, 3) and
        conv = rst.regexpCapture(regexp, 4)
      )
    )
  }

  /**
   * Gets the maximum width option of the nth input (empty string if none is given).
   */
  string getMaxWidthOpt(int n) { this.parseConvSpec(n, _, result, _, _) }

  /**
   * Gets the maximum width of the nth input.
   */
  int getMaxWidth(int n) { result = this.getMaxWidthOpt(n).toInt() }

  /**
   * Gets the length flag of the nth conversion specifier.
   */
  string getLength(int n) { this.parseConvSpec(n, _, _, result, _) }

  /**
   * Gets the conversion character of the nth conversion specifier.
   */
  string getConversionChar(int n) { this.parseConvSpec(n, _, _, _, result) }

  /**
   * Gets the maximum length of the string that can be produced by the nth
   * conversion specifier of this format string; fails if no estimate is
   * possible (or implemented).
   */
  int getMaxConvertedLength(int n) {
    this.getConversionChar(n).toLowerCase() = "s" and
    result = this.getMaxWidth(n)
  }
}
