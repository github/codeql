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
  predicate isWideCharDefault() { exists(getName().indexOf("wscanf")) }
}

/**
 * The standard function `scanf` (and variations).
 */
class Scanf extends ScanfFunction {
  Scanf() {
    this instanceof TopLevelFunction and
    (
      hasName("scanf") or // scanf(format, args...)
      hasName("wscanf") or // wscanf(format, args...)
      hasName("_scanf_l") or // _scanf_l(format, locale, args...)
      hasName("_wscanf_l") // _wscanf_l(format, locale, args...)
    )
  }

  override int getInputParameterIndex() { none() }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The standard function `fscanf` (and variations).
 */
class Fscanf extends ScanfFunction {
  Fscanf() {
    this instanceof TopLevelFunction and
    (
      hasName("fscanf") or // fscanf(src_stream, format, args...)
      hasName("fwscanf") or // fwscanf(src_stream, format, args...)
      hasName("_fscanf_l") or // _fscanf_l(src_stream, format, locale, args...)
      hasName("_fwscanf_l") // _fwscanf_l(src_stream, format, locale, args...)
    )
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * The standard function `sscanf` (and variations).
 */
class Sscanf extends ScanfFunction {
  Sscanf() {
    this instanceof TopLevelFunction and
    (
      hasName("sscanf") or // sscanf(src_stream, format, args...)
      hasName("swscanf") or // swscanf(src, format, args...)
      hasName("_sscanf_l") or // _sscanf_l(src, format, locale, args...)
      hasName("_swscanf_l") // _swscanf_l(src, format, locale, args...)
    )
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * The standard(ish) function `snscanf` (and variations).
 */
class Snscanf extends ScanfFunction {
  Snscanf() {
    this instanceof TopLevelFunction and
    (
      hasName("_snscanf") or // _snscanf(src, max_amount, format, args...)
      hasName("_snwscanf") // _snwscanf(src, max_amount, format, args...)
      // note that the max_amount is not a limit on the output length, it's an input length
      // limit used with non null-terminated strings.
    )
  }

  override int getInputParameterIndex() { result = 0 }

  override int getFormatParameterIndex() { result = 2 }
}

/**
 * A call to one of the `scanf` functions.
 */
class ScanfFunctionCall extends FunctionCall {
  ScanfFunctionCall() { this.getTarget() instanceof ScanfFunction }

  /**
   * Gets the `scanf`-like function that is called.
   */
  ScanfFunction getScanfFunction() { result = getTarget() }

  /**
   * Gets the position at which the input string or stream parameter occurs,
   * if this function call does not read from standard input.
   */
  int getInputParameterIndex() { result = getScanfFunction().getInputParameterIndex() }

  /**
   * Gets the position at which the format parameter occurs.
   */
  int getFormatParameterIndex() { result = getScanfFunction().getFormatParameterIndex() }

  /**
   * Gets the format expression used in this call.
   */
  Expr getFormat() { result = this.getArgument(this.getFormatParameterIndex()) }

  /**
   * Holds if the default meaning of `%s` is a `wchar_t*` string
   * (rather than a `char*`).
   */
  predicate isWideCharDefault() { getScanfFunction().isWideCharDefault() }
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
  predicate isWideCharDefault() { getUse().getTarget().(ScanfFunction).isWideCharDefault() }

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
  string getMaxWidthOpt(int n) {
    exists(string spec, string len, string conv | this.parseConvSpec(n, spec, result, len, conv))
  }

  /**
   * Gets the maximum width of the nth input.
   */
  int getMaxWidth(int n) { result = this.getMaxWidthOpt(n).toInt() }

  /**
   * Gets the length flag of the nth conversion specifier.
   */
  string getLength(int n) {
    exists(string spec, string width, string conv |
      this.parseConvSpec(n, spec, width, result, conv)
    )
  }

  /**
   * Gets the conversion character of the nth conversion specifier.
   */
  string getConversionChar(int n) {
    exists(string spec, string width, string len | this.parseConvSpec(n, spec, width, len, result))
  }

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
