/**
 * A library for dealing with `printf`-like formatting strings.
 */

import semmle.code.cpp.Type
import semmle.code.cpp.commons.CommonType
import semmle.code.cpp.commons.StringAnalysis
import semmle.code.cpp.models.interfaces.FormattingFunction
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

private newtype TBufferWriteEstimationReason =
  TUnspecifiedEstimateReason() or
  TTypeBoundsAnalysis() or
  TWidenedValueFlowAnalysis() or
  TValueFlowAnalysis()

private predicate gradeToReason(int grade, TBufferWriteEstimationReason reason) {
  // when combining reasons, lower grade takes precedence
  grade = 0 and reason = TUnspecifiedEstimateReason()
  or
  grade = 1 and reason = TTypeBoundsAnalysis()
  or
  grade = 2 and reason = TWidenedValueFlowAnalysis()
  or
  grade = 3 and reason = TValueFlowAnalysis()
}

/**
 * A reason for a specific buffer write size estimate.
 */
abstract class BufferWriteEstimationReason extends TBufferWriteEstimationReason {
  /**
   * Returns the name of the concrete class.
   */
  abstract string toString();

  /**
   * Returns a human readable representation of this reason.
   */
  abstract string getDescription();

  /**
   * Combine estimate reasons. Used to give a reason for the size of a format string
   * conversion given reasons coming from its individual specifiers.
   */
  BufferWriteEstimationReason combineWith(BufferWriteEstimationReason other) {
    exists(int grade, int otherGrade |
      gradeToReason(grade, this) and gradeToReason(otherGrade, other)
    |
      if otherGrade < grade then result = other else result = this
    )
  }
}

/**
 * No particular reason given. This is currently used for backward compatibility so that
 * classes derived from BufferWrite and overriding `getMaxData/0` still work with the
 * queries as intended.
 */
class UnspecifiedEstimateReason extends BufferWriteEstimationReason, TUnspecifiedEstimateReason {
  override string toString() { result = "UnspecifiedEstimateReason" }

  override string getDescription() { result = "no reason specified" }
}

/**
 * The estimation comes from rough bounds just based on the type (e.g.
 * `0 <= x < 2^32` for an unsigned 32 bit integer).
 */
class TypeBoundsAnalysis extends BufferWriteEstimationReason, TTypeBoundsAnalysis {
  override string toString() { result = "TypeBoundsAnalysis" }

  override string getDescription() { result = "based on type bounds" }
}

/**
 * The estimation comes from non trivial bounds found via actual flow analysis,
 * but a widening aproximation might have been used for variables in loops.
 * For example
 * ```
 * for (int i = 0; i < 10; ++i) {
 *    int j = i + i;
 *    //...  <- estimation done here based on j
 * }
 * ```
 */
class WidenedValueFlowAnalysis extends BufferWriteEstimationReason, TWidenedValueFlowAnalysis {
  override string toString() { result = "WidenedValueFlowAnalysis" }

  override string getDescription() {
    result = "based on flow analysis of value bounds with a widening approximation"
  }
}

/**
 * The estimation comes from non trivial bounds found via actual flow analysis.
 * For example
 * ```
 * unsigned u = x;
 * if (u < 1000) {
 *    //...  <- estimation done here based on u
 * }
 * ```
 */
class ValueFlowAnalysis extends BufferWriteEstimationReason, TValueFlowAnalysis {
  override string toString() { result = "ValueFlowAnalysis" }

  override string getDescription() { result = "based on flow analysis of value bounds" }
}

class PrintfFormatAttribute extends FormatAttribute {
  PrintfFormatAttribute() { this.getArchetype() = ["printf", "__printf__"] }
}

/**
 * A function that can be identified as a `printf` style formatting
 * function by its use of the GNU `format` attribute.
 */
class AttributeFormattingFunction extends FormattingFunction {
  override string getAPrimaryQlClass() { result = "AttributeFormattingFunction" }

  AttributeFormattingFunction() {
    exists(PrintfFormatAttribute printf_attrib |
      printf_attrib = this.getAnAttribute() and
      exists(printf_attrib.getFirstFormatArgIndex()) // exclude `vprintf` style format functions
    )
  }

  override int getFormatParameterIndex() {
    forex(PrintfFormatAttribute printf_attrib | printf_attrib = this.getAnAttribute() |
      result = printf_attrib.getFormatIndex()
    )
  }
}

/**
 * A standard function such as `vprintf` that has a format parameter
 * and a variable argument list of type `va_arg`. `formatParamIndex` indicates
 * the format parameter and `type` indicates the type of `vprintf`:
 *  - `""` is a `vprintf` variant, `outputParamIndex` is `-1`.
 *  - `"f"` is a `vfprintf` variant, `outputParamIndex` indicates the output stream parameter.
 *  - `"s"` is a `vsprintf` variant, `outputParamIndex` indicates the output buffer parameter.
 *  - `"?"` if the type cannot be deteremined.  `outputParamIndex` is `-1`.
 */
predicate primitiveVariadicFormatter(
  TopLevelFunction f, string type, int formatParamIndex, int outputParamIndex
) {
  type = f.getName().regexpCapture("_?_?va?([fs]?)n?w?printf(_s)?(_p)?(_l)?", 1) and
  (
    if f.getName().matches("%\\_l")
    then formatParamIndex = f.getNumberOfParameters() - 3
    else formatParamIndex = f.getNumberOfParameters() - 2
  ) and
  (
    if type = "" then outputParamIndex = -1 else outputParamIndex = 0 // Conveniently, these buffer parameters are all at index 0.
  ) and
  not (
    // exclude functions with an implementation in the snapshot source
    // directory, as they may not be standard implementations.
    exists(f.getBlock()) and
    exists(f.getFile().getRelativePath())
  )
}

private predicate callsVariadicFormatter(
  Function f, string type, int formatParamIndex, int outputParamIndex
) {
  // calls a variadic formatter with `formatParamIndex`, `outputParamIndex` linked
  exists(FunctionCall fc, int format, int output |
    variadicFormatter(fc.getTarget(), type, format, output) and
    fc.getEnclosingFunction() = f and
    fc.getArgument(format) = f.getParameter(formatParamIndex).getAnAccess() and
    fc.getArgument(output) = f.getParameter(outputParamIndex).getAnAccess()
  )
  or
  // calls a variadic formatter with only `formatParamIndex` linked
  exists(FunctionCall fc, string calledType, int format, int output |
    variadicFormatter(fc.getTarget(), calledType, format, output) and
    fc.getEnclosingFunction() = f and
    fc.getArgument(format) = f.getParameter(formatParamIndex).getAnAccess() and
    not fc.getArgument(output) = f.getParameter(_).getAnAccess() and
    (
      calledType = "" and
      type = ""
      or
      calledType != "" and
      type = "?" // we probably should have an `outputParamIndex` link but have lost it.
    ) and
    outputParamIndex = -1
  )
}

/**
 * Holds if `f` is a function such as `vprintf` that has a format parameter
 * and a variable argument list of type `va_arg`. `formatParamIndex` indicates
 * the format parameter and `type` indicates the type of `vprintf`:
 *  - `""` is a `vprintf` variant, `outputParamIndex` is `-1`.
 *  - `"f"` is a `vfprintf` variant, `outputParamIndex` indicates the output stream parameter.
 *  - `"s"` is a `vsprintf` variant, `outputParamIndex` indicates the output buffer parameter.
 *  - `"?"` if the type cannot be deteremined.  `outputParamIndex` is `-1`.
 */
predicate variadicFormatter(Function f, string type, int formatParamIndex, int outputParamIndex) {
  primitiveVariadicFormatter(f, type, formatParamIndex, outputParamIndex)
  or
  not f.isVarargs() and
  callsVariadicFormatter(f, type, formatParamIndex, outputParamIndex)
}

/**
 * A function not in the standard library which takes a `printf`-like formatting
 * string and a variable number of arguments.
 */
class UserDefinedFormattingFunction extends FormattingFunction {
  override string getAPrimaryQlClass() { result = "UserDefinedFormattingFunction" }

  UserDefinedFormattingFunction() { this.isVarargs() and callsVariadicFormatter(this, _, _, _) }

  override int getFormatParameterIndex() { callsVariadicFormatter(this, _, result, _) }

  override int getOutputParameterIndex(boolean isStream) {
    callsVariadicFormatter(this, "f", _, result) and isStream = true
    or
    callsVariadicFormatter(this, "s", _, result) and isStream = false
  }

  override predicate isOutputGlobal() { callsVariadicFormatter(this, "", _, _) }
}

/**
 * A call to one of the formatting functions.
 */
class FormattingFunctionCall extends Expr {
  FormattingFunctionCall() { this.(Call).getTarget() instanceof FormattingFunction }

  override string getAPrimaryQlClass() { result = "FormattingFunctionCall" }

  /**
   * Gets the formatting function being called.
   */
  FormattingFunction getTarget() { result = this.(Call).getTarget() }

  /**
   * Gets the `i`th argument for this call.
   *
   * The range of `i` is from `0` to `getNumberOfArguments() - 1`.
   */
  Expr getArgument(int i) { result = this.(Call).getArgument(i) }

  /**
   * Gets the number of actual parameters in this call; use
   * `getArgument(i)` with `i` between `0` and `result - 1` to
   * retrieve actuals.
   */
  int getNumberOfArguments() { result = this.(Call).getNumberOfArguments() }

  /**
   * Gets the index at which the format string occurs in the argument list.
   */
  int getFormatParameterIndex() { result = this.getTarget().getFormatParameterIndex() }

  /**
   * Gets the format expression used in this call.
   */
  Expr getFormat() { result = this.getArgument(this.getFormatParameterIndex()) }

  /**
   * Gets the nth argument to the format (including width and precision arguments).
   */
  Expr getFormatArgument(int n) {
    exists(int i |
      result = this.getArgument(i) and
      n >= 0 and
      n = i - this.getTarget().getFirstFormatArgumentIndex()
    )
  }

  /**
   * Gets the argument corresponding to the nth conversion specifier.
   */
  Expr getConversionArgument(int n) {
    exists(FormatLiteral fl |
      fl = this.getFormat() and
      (
        result = this.getFormatArgument(fl.getParameterFieldValue(n))
        or
        result = this.getFormatArgument(fl.getFormatArgumentIndexFor(n, 2)) and
        not exists(fl.getParameterFieldValue(n))
      )
    )
  }

  /**
   * Gets the argument corresponding to the nth conversion specifier's
   * minimum field width (has no result if that conversion specifier has
   * an explicit minimum field width).
   */
  Expr getMinFieldWidthArgument(int n) {
    exists(FormatLiteral fl |
      fl = this.getFormat() and
      (
        result = this.getFormatArgument(fl.getMinFieldWidthParameterFieldValue(n))
        or
        result = this.getFormatArgument(fl.getFormatArgumentIndexFor(n, 0)) and
        not exists(fl.getMinFieldWidthParameterFieldValue(n))
      )
    )
  }

  /**
   * Gets the argument corresponding to the nth conversion specifier's
   * precision (has no result if that conversion specifier has an explicit
   * precision).
   */
  Expr getPrecisionArgument(int n) {
    exists(FormatLiteral fl |
      fl = this.getFormat() and
      (
        result = this.getFormatArgument(fl.getPrecisionParameterFieldValue(n))
        or
        result = this.getFormatArgument(fl.getFormatArgumentIndexFor(n, 1)) and
        not exists(fl.getPrecisionParameterFieldValue(n))
      )
    )
  }

  /**
   * Gets the number of arguments to this call that are parameters to the
   * format string.
   */
  int getNumFormatArgument() {
    result = count(this.getFormatArgument(_)) and
    // format arguments must be known
    exists(this.getTarget().getFirstFormatArgumentIndex())
  }

  /**
   * Gets the argument, if any, to which the output is written. If `isStream` is
   * `true`, the output argument is a stream (that is, this call behaves like
   * `fprintf`). If `isStream` is `false`, the output argument is a buffer (that
   * is, this call behaves like `sprintf`)
   */
  Expr getOutputArgument(boolean isStream) {
    result =
      this.(Call)
          .getArgument(this.(Call)
                .getTarget()
                .(FormattingFunction)
                .getOutputParameterIndex(isStream))
  }
}

/**
 * Gets the number of digits required to represent the integer represented by `f`.
 *
 * `f` is assumed to be nonnegative.
 */
bindingset[f]
private int lengthInBase10(float f) {
  f = 0 and result = 1
  or
  result = f.log10().floor() + 1
}

pragma[nomagic]
private predicate isPointerTypeWithBase(Type base, PointerType pt) { base = pt.getBaseType() }

bindingset[expr]
private BufferWriteEstimationReason getEstimationReasonForIntegralExpression(Expr expr) {
  // we consider the range analysis non trivial if it
  // * constrained non-trivially both sides of a signed value, or
  // * constrained non-trivially the positive side of an unsigned value
  // expr should already be given as getFullyConverted
  if
    upperBound(expr) < exprMaxVal(expr) and
    (exprMinVal(expr) >= 0 or lowerBound(expr) > exprMinVal(expr))
  then
    // next we check whether the estimate may have been widened
    if upperBoundMayBeWidened(expr)
    then result = TWidenedValueFlowAnalysis()
    else result = TValueFlowAnalysis()
  else result = TTypeBoundsAnalysis()
}

/**
 * Gets the number of hex digits required to represent the integer represented by `f`.
 *
 * `f` is assumed to be nonnegative.
 */
bindingset[f]
private int lengthInBase16(float f) {
  f = 0 and result = 1
  or
  result = (f.log2() / 4.0).floor() + 1
}

/**
 * A class to represent format strings that occur as arguments to invocations of formatting functions.
 */
class FormatLiteral extends Literal {
  FormatLiteral() {
    exists(FormattingFunctionCall ffc | ffc.getFormat() = this) and
    this instanceof StringLiteral
  }

  /**
   * Gets the function call where this format string is used.
   */
  FormattingFunctionCall getUse() { result.getFormat() = this }

  /**
   * Gets the default character type expected for `%s` by this format literal.  Typically
   * `char` or `wchar_t`.
   */
  Type getDefaultCharType() { result = this.getUse().getTarget().getDefaultCharType() }

  /**
   * Gets the non-default character type expected for `%S` by this format literal.  Typically
   * `wchar_t` or `char`.  On some snapshots there may be multiple results where we can't tell
   * which is correct for a particular function.
   */
  Type getNonDefaultCharType() { result = this.getUse().getTarget().getNonDefaultCharType() }

  /**
   * Gets the wide character type for this format literal.  This is usually `wchar_t`.  On some
   * snapshots there may be multiple results where we can't tell which is correct for a
   * particular function.
   */
  Type getWideCharType() { result = this.getUse().getTarget().getWideCharType() }

  /**
   * Holds if this `FormatLiteral` is in a context that supports
   * Microsoft rules and extensions.
   */
  predicate isMicrosoft() { anyFileCompiledAsMicrosoft() }

  /**
   * Gets the format string, with '%%' and '%@' replaced by '_' (to avoid processing
   * them as format specifiers).
   */
  string getFormat() { result = this.getValue().replaceAll("%%", "_").replaceAll("%@", "_") }

  /**
   * Gets the number of conversion specifiers (not counting `%%`)
   */
  int getNumConvSpec() { result = count(this.getFormat().indexOf("%")) }

  /**
   * Gets the position in the string at which the nth conversion specifier
   * starts.
   */
  int getConvSpecOffset(int n) { result = this.getFormat().indexOf("%", n, 0) }

  /*
   * Each of these predicates gets a regular expressions to match each individual
   * parts of a conversion specifier.
   */

  private string getParameterFieldRegexp() {
    // the parameter field is a posix extension, for example `%5$i` uses the fifth
    // parameter as an integer, regardless of the position of this substring in the
    // format string.
    result = "(?:[1-9][0-9]*\\$)?"
  }

  private string getFlagRegexp() {
    if this.isMicrosoft() then result = "[-+ #0']*" else result = "[-+ #0'I]*"
  }

  private string getFieldWidthRegexp() { result = "(?:[1-9][0-9]*|\\*|\\*[0-9]+\\$)?" }

  private string getPrecRegexp() { result = "(?:\\.(?:[0-9]*|\\*|\\*[0-9]+\\$))?" }

  private string getLengthRegexp() {
    if this.isMicrosoft()
    then result = "(?:hh?|ll?|L|q|j|z|t|w|I32|I64|I)?"
    else result = "(?:hh?|ll?|L|q|j|z|Z|t)?"
  }

  private string getConvCharRegexp() {
    if this.isMicrosoft()
    then result = "[aAcCdeEfFgGimnopsSuxXZ@]"
    else result = "[aAcCdeEfFgGimnopsSuxX@]"
  }

  /**
   * Gets a regular expression used for matching a whole conversion specifier.
   */
  string getConvSpecRegexp() {
    // capture groups: 1 - entire conversion spec, including "%"
    //                 2 - parameters
    //                 3 - flags
    //                 4 - minimum field width
    //                 5 - precision
    //                 6 - length
    //                 7 - conversion character
    // NB: this matches "%%" with conversion character "%"
    result =
      "(?s)(\\%(" + this.getParameterFieldRegexp() + ")(" + this.getFlagRegexp() + ")(" +
        this.getFieldWidthRegexp() + ")(" + this.getPrecRegexp() + ")(" + this.getLengthRegexp() +
        ")(" + this.getConvCharRegexp() + ")" + "|\\%\\%).*"
  }

  /**
   * Holds if the arguments are a parsing of a conversion specifier to this
   * format string, where `n` is which conversion specifier to parse, `spec` is
   * the whole conversion specifier, `params` is the argument to be converted
   * in case it's not positional, `flags` contains additional format flags,
   * `width` is the maximum width option of this input, `len` is the length
   * flag of this input, and `conv` is the conversion character of this input.
   *
   * Each parameter is the empty string if no value is given by the conversion
   * specifier.
   */
  predicate parseConvSpec(
    int n, string spec, string params, string flags, string width, string prec, string len,
    string conv
  ) {
    exists(int offset, string fmt, string rst, string regexp |
      offset = this.getConvSpecOffset(n) and
      fmt = this.getFormat() and
      rst = fmt.substring(offset, fmt.length()) and
      regexp = this.getConvSpecRegexp() and
      (
        spec = rst.regexpCapture(regexp, 1) and
        params = rst.regexpCapture(regexp, 2) and
        flags = rst.regexpCapture(regexp, 3) and
        width = rst.regexpCapture(regexp, 4) and
        prec = rst.regexpCapture(regexp, 5) and
        len = rst.regexpCapture(regexp, 6) and
        conv = rst.regexpCapture(regexp, 7)
        or
        spec = rst.regexpCapture(regexp, 1) and
        not exists(rst.regexpCapture(regexp, 2)) and
        params = "" and
        flags = "" and
        width = "" and
        prec = "" and
        len = "" and
        conv = "%"
      )
    )
  }

  /**
   * Gets the nth conversion specifier (including the initial `%`).
   */
  string getConvSpec(int n) {
    exists(int offset, string fmt, string rst, string regexp |
      offset = this.getConvSpecOffset(n) and
      fmt = this.getFormat() and
      rst = fmt.substring(offset, fmt.length()) and
      regexp = this.getConvSpecRegexp() and
      result = rst.regexpCapture(regexp, 1)
    )
  }

  /**
   * Gets the parameter field of the nth conversion specifier (for example, `1$`).
   */
  string getParameterField(int n) { this.parseConvSpec(n, _, result, _, _, _, _, _) }

  /**
   * Gets the parameter field of the nth conversion specifier (if it has one) as a
   * zero-based number.
   */
  int getParameterFieldValue(int n) {
    result = this.getParameterField(n).regexpCapture("([0-9]*)\\$", 1).toInt() - 1
  }

  /**
   * Gets the flags of the nth conversion specifier.
   */
  string getFlags(int n) { this.parseConvSpec(n, _, _, result, _, _, _, _) }

  /**
   * Holds if the nth conversion specifier has alternate flag ("#").
   */
  predicate hasAlternateFlag(int n) { this.getFlags(n).matches("%#%") }

  /**
   * Holds if the nth conversion specifier has zero padding flag ("0").
   */
  predicate isZeroPadded(int n) { this.getFlags(n).matches("%0%") and not this.isLeftAdjusted(n) }

  /**
   * Holds if the nth conversion specifier has flag left adjustment flag
   * ("-").  Note that this overrides the zero padding flag.
   */
  predicate isLeftAdjusted(int n) { this.getFlags(n).matches("%-%") }

  /**
   * Holds if the nth conversion specifier has the blank flag (" ").
   */
  predicate hasBlank(int n) { this.getFlags(n).matches("% %") }

  /**
   * Holds if the nth conversion specifier has the explicit sign flag ("+").
   */
  predicate hasSign(int n) { this.getFlags(n).matches("%+%") }

  /**
   * Holds if the nth conversion specifier has the thousands grouping flag ("'").
   */
  predicate hasThousandsGrouping(int n) { this.getFlags(n).matches("%'%") }

  /**
   * Holds if the nth conversion specifier has the alternative digits flag ("I").
   */
  predicate hasAlternativeDigits(int n) { this.getFlags(n).matches("%I%") }

  /**
   * Gets the minimum field width of the nth conversion specifier
   * (empty string if none is given).
   */
  string getMinFieldWidthOpt(int n) { this.parseConvSpec(n, _, _, _, result, _, _, _) }

  /**
   * Holds if the nth conversion specifier has a minimum field width.
   */
  predicate hasMinFieldWidth(int n) { this.getMinFieldWidthOpt(n) != "" }

  /**
   * Holds if the nth conversion specifier has an explicitly given minimum
   * field width.
   */
  predicate hasExplicitMinFieldWidth(int n) { this.getMinFieldWidthOpt(n).regexpMatch("[0-9]+") }

  /**
   * Holds if the nth conversion specifier has an implicitly given minimum
   * field width (either "*" or "*i$" for some number i).
   */
  predicate hasImplicitMinFieldWidth(int n) { this.getMinFieldWidthOpt(n).regexpMatch("\\*.*") }

  /**
   * Gets the minimum field width of the nth conversion specifier.
   */
  int getMinFieldWidth(int n) { result = this.getMinFieldWidthOpt(n).toInt() }

  /**
   * Gets the zero-based parameter number of the minimum field width of the nth
   * conversion specifier, if it is implicit and uses a parameter field (such as `*1$`).
   */
  int getMinFieldWidthParameterFieldValue(int n) {
    result = this.getMinFieldWidthOpt(n).regexpCapture("\\*([0-9]*)\\$", 1).toInt() - 1
  }

  /**
   * Gets the precision of the nth conversion specifier (empty string if none is given).
   */
  string getPrecisionOpt(int n) { this.parseConvSpec(n, _, _, _, _, result, _, _) }

  /**
   * Holds if the nth conversion specifier has a precision.
   */
  predicate hasPrecision(int n) { this.getPrecisionOpt(n) != "" }

  /**
   * Holds if the nth conversion specifier has an explicitly given precision.
   */
  predicate hasExplicitPrecision(int n) { this.getPrecisionOpt(n).regexpMatch("\\.[0-9]*") }

  /**
   * Holds if the nth conversion specifier has an implicitly given precision
   * (either "*" or "*i$" for some number i).
   */
  predicate hasImplicitPrecision(int n) { this.getPrecisionOpt(n).regexpMatch("\\.\\*.*") }

  /**
   * Gets the precision of the nth conversion specifier.
   */
  int getPrecision(int n) {
    if this.getPrecisionOpt(n) = "."
    then result = 0
    else result = this.getPrecisionOpt(n).regexpCapture("\\.([0-9]*)", 1).toInt()
  }

  /**
   * Gets the zero-based parameter number of the precision of the nth conversion
   * specifier, if it is implicit and uses a parameter field (such as `*1$`).
   */
  int getPrecisionParameterFieldValue(int n) {
    result = this.getPrecisionOpt(n).regexpCapture("\\.\\*([0-9]*)\\$", 1).toInt() - 1
  }

  /**
   * Gets the length flag of the nth conversion specifier.
   */
  string getLength(int n) { this.parseConvSpec(n, _, _, _, _, _, result, _) }

  /**
   * Gets the conversion character of the nth conversion specifier.
   */
  string getConversionChar(int n) { this.parseConvSpec(n, _, _, _, _, _, _, result) }

  /**
   * Gets the size of pointers in the target this formatting function is
   * compiled for.
   */
  private int targetBitSize() { result = this.getFullyConverted().getType().getSize() }

  private LongType getLongType() {
    this.targetBitSize() = 4 and result.getSize() = min(LongType l | | l.getSize())
    or
    this.targetBitSize() = 8 and result.getSize() = max(LongType l | | l.getSize())
    or
    this.targetBitSize() != 4 and
    this.targetBitSize() != 8
  }

  private Intmax_t getIntmax_t() {
    this.targetBitSize() = 4 and result.getSize() = min(Intmax_t l | | l.getSize())
    or
    this.targetBitSize() = 8 and result.getSize() = max(Intmax_t l | | l.getSize())
    or
    this.targetBitSize() != 4 and
    this.targetBitSize() != 8
  }

  private Size_t getSize_t() {
    this.targetBitSize() = 4 and result.getSize() = min(Size_t l | | l.getSize())
    or
    this.targetBitSize() = 8 and result.getSize() = max(Size_t l | | l.getSize())
    or
    this.targetBitSize() != 4 and
    this.targetBitSize() != 8
  }

  private Ssize_t getSsize_t() {
    this.targetBitSize() = 4 and result.getSize() = min(Ssize_t l | | l.getSize())
    or
    this.targetBitSize() = 8 and result.getSize() = max(Ssize_t l | | l.getSize())
    or
    this.targetBitSize() != 4 and
    this.targetBitSize() != 8
  }

  private Ptrdiff_t getPtrdiff_t() {
    this.targetBitSize() = 4 and result.getSize() = min(Ptrdiff_t l | | l.getSize())
    or
    this.targetBitSize() = 8 and result.getSize() = max(Ptrdiff_t l | | l.getSize())
    or
    this.targetBitSize() != 4 and
    this.targetBitSize() != 8
  }

  /**
   * Gets the family of integral types required by the nth conversion
   * specifier's length flag.
   */
  Type getIntegralConversion(int n) {
    exists(string len |
      len = this.getLength(n) and
      (
        len = "hh" and result instanceof IntType
        or
        len = "h" and result instanceof IntType
        or
        len = "l" and result = this.getLongType()
        or
        len = ["ll", "L", "q"] and
        result instanceof LongLongType
        or
        len = "j" and result = this.getIntmax_t()
        or
        len = ["z", "Z"] and
        (result = this.getSize_t() or result = this.getSsize_t())
        or
        len = "t" and result = this.getPtrdiff_t()
        or
        len = "I" and
        (result = this.getSize_t() or result = this.getPtrdiff_t())
        or
        len = "I32" and
        exists(MicrosoftInt32Type t | t.getUnsigned() = result.(IntegralType).getUnsigned())
        or
        len = "I64" and
        exists(MicrosoftInt64Type t | t.getUnsigned() = result.(IntegralType).getUnsigned())
        or
        len = "" and result instanceof IntType
      )
    )
  }

  /**
   * Gets the family of integral types output / displayed by the nth
   * conversion specifier's length flag.
   */
  Type getIntegralDisplayType(int n) {
    exists(string len |
      len = this.getLength(n) and
      (
        len = "hh" and result instanceof CharType
        or
        len = "h" and result instanceof ShortType
        or
        len = "l" and result = this.getLongType()
        or
        len = ["ll", "L", "q"] and
        result instanceof LongLongType
        or
        len = "j" and result = this.getIntmax_t()
        or
        len = ["z", "Z"] and
        (result = this.getSize_t() or result = this.getSsize_t())
        or
        len = "t" and result = this.getPtrdiff_t()
        or
        len = "I" and
        (result = this.getSize_t() or result = this.getPtrdiff_t())
        or
        len = "I32" and
        exists(MicrosoftInt32Type t | t.getUnsigned() = result.(IntegralType).getUnsigned())
        or
        len = "I64" and
        exists(MicrosoftInt64Type t | t.getUnsigned() = result.(IntegralType).getUnsigned())
        or
        len = "" and result instanceof IntType
      )
    )
  }

  /**
   * Gets the family of floating point types required by the nth conversion
   * specifier's length flag.
   */
  FloatingPointType getFloatingPointConversion(int n) {
    exists(string len |
      len = this.getLength(n) and
      if len = ["L", "ll"] then result instanceof LongDoubleType else result instanceof DoubleType
    )
  }

  /**
   * Gets the family of pointer types required by the nth conversion
   * specifier's length flag.
   */
  PointerType getStorePointerConversion(int n) {
    exists(IntegralType base |
      exists(string len | len = this.getLength(n) |
        len = "hh" and base instanceof CharType
        or
        len = "h" and base instanceof ShortType
        or
        len = "l" and base = this.getLongType()
        or
        len = ["ll", "L"] and
        base instanceof LongLongType
        or
        len = "q" and base instanceof LongLongType
      ) and
      base.isSigned() and
      base = result.getBaseType()
    )
  }

  /**
   * Gets the argument type required by the nth conversion specifier.
   */
  Type getConversionType(int n) {
    result = this.getConversionType1(n) or
    result = this.getConversionType1b(n) or
    result = this.getConversionType2(n) or
    result = this.getConversionType3(n) or
    result = this.getConversionType4(n) or
    result = this.getConversionType6(n) or
    result = this.getConversionType7(n) or
    result = this.getConversionType8(n) or
    result = this.getConversionType9(n) or
    result = this.getConversionType10(n)
  }

  private Type getConversionType1(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv.regexpMatch("d|i") and
      result = this.getIntegralConversion(n) and
      not result.getUnderlyingType().(IntegralType).isExplicitlySigned() and
      not result.getUnderlyingType().(IntegralType).isExplicitlyUnsigned()
    )
  }

  /**
   * Gets the char type required by the nth conversion specifier.
   *  - in the base case this is the default for the formatting function
   *    (e.g. `char` for `printf`, `char` or `wchar_t` for `wprintf`).
   *  - the `%C` format character reverses wideness.
   *  - the size prefixes 'l'/'w' and 'h' override the type character
   *    to wide or single-byte characters respectively.
   */
  private Type getConversionType1b(int n) {
    exists(string len, string conv |
      this.parseConvSpec(n, _, _, _, _, _, len, conv) and
      (
        conv = ["c", "C"] and
        len = "h" and
        result instanceof PlainCharType
        or
        conv = ["c", "C"] and
        len = ["l", "w"] and
        result = this.getWideCharType()
        or
        conv = "c" and
        (len != "l" and len != "w" and len != "h") and
        result = this.getDefaultCharType()
        or
        conv = "C" and
        (len != "l" and len != "w" and len != "h") and
        result = this.getNonDefaultCharType()
      )
    )
  }

  private Type getConversionType2(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv.regexpMatch("o|u|x|X") and
      result = this.getIntegralConversion(n) and
      result.getUnderlyingType().(IntegralType).isUnsigned()
    )
  }

  private Type getConversionType3(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv.regexpMatch("a|A|e|E|f|F|g|G") and result = this.getFloatingPointConversion(n)
    )
  }

  /**
   * Gets the string type required by the nth conversion specifier.
   *  - in the base case this is the default for the formatting function
   *    (e.g. `char *` for `printf`, `char *` or `wchar_t *` for `wprintf`).
   *  - the `%S` format character reverses wideness on some platforms.
   *  - the size prefixes 'l'/'w' and 'h' override the type character
   *    to wide or single-byte characters respectively.
   */
  private Type getConversionType4(int n) {
    exists(string len, string conv |
      this.parseConvSpec(n, _, _, _, _, _, len, conv) and
      (
        conv = ["s", "S"] and
        len = "h" and
        isPointerTypeWithBase(any(PlainCharType plainCharType), result)
        or
        conv = ["s", "S"] and
        len = ["l", "w"] and
        isPointerTypeWithBase(this.getWideCharType(), result)
        or
        conv = "s" and
        (len != "l" and len != "w" and len != "h") and
        isPointerTypeWithBase(this.getDefaultCharType(), result)
        or
        conv = "S" and
        (len != "l" and len != "w" and len != "h") and
        isPointerTypeWithBase(this.getNonDefaultCharType(), result)
      )
    )
  }

  private Type getConversionType6(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv = "p" and result instanceof VoidPointerType
    )
  }

  private Type getConversionType7(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv = "n" and result = this.getStorePointerConversion(n)
    )
  }

  private IntPointerType getConversionType8(int n) {
    exists(string cnv | cnv = this.getConversionChar(n) |
      cnv = "n" and
      not exists(this.getStorePointerConversion(n)) and
      result.getBaseType().(IntType).isSigned() and
      not result.getBaseType().(IntType).isExplicitlySigned()
    )
  }

  private Type getConversionType9(int n) {
    this.getConversionChar(n) = "Z" and
    this.getLength(n) = ["l", "w"] and
    exists(Type t |
      t.getName() = "UNICODE_STRING" and
      result.(PointerType).getBaseType() = t
    )
  }

  private Type getConversionType10(int n) {
    this.getConversionChar(n) = "Z" and
    not this.getLength(n) = "l" and
    not this.getLength(n) = "w" and
    exists(Type t |
      t.getName() = "ANSI_STRING" and
      result.(PointerType).getBaseType() = t
    )
  }

  /**
   * Gets an alternate argument type that would be required by the nth
   * conversion specifier on a Microsoft or non-Microsoft platform, opposite
   * to that of the snapshot. This may be useful for answering 'what might
   * happen' questions.
   */
  Type getConversionTypeAlternate(int n) {
    exists(string len, string conv |
      this.parseConvSpec(n, _, _, _, _, _, len, conv) and
      (len != "l" and len != "w" and len != "h") and
      this.getUse().getTarget().getFormatCharType().getSize() > 1 and // wide function
      (
        conv = "c" and
        result = this.getNonDefaultCharType()
        or
        conv = "C" and
        result = this.getDefaultCharType()
        or
        conv = "s" and
        result.(PointerType).getBaseType() = this.getNonDefaultCharType()
        or
        conv = "S" and
        result.(PointerType).getBaseType() = this.getDefaultCharType()
      )
    )
  }

  /**
   * Holds if the nth conversion specifier of this format string (if `mode = 2`), it's
   * minimum field width (if `mode = 0`) or it's precision (if `mode = 1`) requires a
   * format argument.
   *
   * Most conversion specifiers require a format argument, whereas minimum field width
   * and precision only require a format argument if they are present and a `*` was
   * used for it's value in the format string.
   */
  private predicate hasFormatArgumentIndexFor(int n, int mode) {
    mode = 0 and
    this.hasImplicitMinFieldWidth(n)
    or
    mode = 1 and
    this.hasImplicitPrecision(n)
    or
    mode = 2 and
    exists(this.getConvSpecOffset(n)) and
    not this.getConversionChar(n) = "m"
  }

  /**
   * Gets the computed format argument index for the nth conversion specifier of this
   * format string (if `mode = 2`), it's minimum field width (if `mode = 0`) or it's
   * precision (if `mode = 1`).  Has no result if that element is not present.  Does
   * not account for positional arguments (`$`).
   */
  int getFormatArgumentIndexFor(int n, int mode) {
    this.hasFormatArgumentIndexFor(n, mode) and
    (3 * n) + mode =
      rank[result + 1](int n2, int mode2 |
        this.hasFormatArgumentIndexFor(n2, mode2)
      |
        (3 * n2) + mode2
      )
  }

  /**
   * Gets the number of arguments required by the nth conversion specifier
   * of this format string.
   */
  int getNumArgNeeded(int n) {
    exists(this.getConvSpecOffset(n)) and
    exists(this.getConversionChar(n)) and
    result = count(int mode | this.hasFormatArgumentIndexFor(n, mode))
  }

  /**
   * Gets the number of arguments needed by this format string.
   */
  int getNumArgNeeded() {
    if this.getParameterField(_) != ""
    then
      // At least one conversion specifier has a parameter field, in which case,
      // they all should have.
      result = max(string s | this.getParameterField(_) = s + "$" | s.toInt())
    else result = count(int n, int mode | this.hasFormatArgumentIndexFor(n, mode))
  }

  /**
   * Holds if all conversion specifiers of this format string have been
   * parsed by the library (this does not hold if one or more unrecognized
   * format specifiers are present in the format string).
   */
  predicate specsAreKnown() {
    this.getNumConvSpec() = count(int n | exists(this.getNumArgNeeded(n)))
  }

  /**
   * Gets the maximum length of the string that can be produced by the nth
   * conversion specifier of this format string; has no result if this cannot
   * be determined.
   */
  int getMaxConvertedLength(int n) { result = max(this.getMaxConvertedLength(n, _)) }

  /**
   * Gets the maximum length of the string that can be produced by the nth
   * conversion specifier of this format string, specifying the estimation reason;
   * has no result if this cannot be determined.
   */
  int getMaxConvertedLength(int n, BufferWriteEstimationReason reason) {
    exists(int len |
      (
        (
          if this.hasExplicitMinFieldWidth(n)
          then result = len.maximum(this.getMinFieldWidth(n))
          else not this.hasImplicitMinFieldWidth(n)
        ) and
        result = len
      ) and
      (
        this.getConversionChar(n) = "%" and
        len = 1 and
        reason = TValueFlowAnalysis()
        or
        this.getConversionChar(n).toLowerCase() = "c" and
        len = 1 and
        reason = TValueFlowAnalysis() // e.g. 'a'
        or
        this.getConversionChar(n).toLowerCase() = "f" and
        exists(int dot, int afterdot |
          (if this.getPrecision(n) = 0 then dot = 0 else dot = 1) and
          (
            (
              if this.hasExplicitPrecision(n)
              then afterdot = this.getPrecision(n)
              else not this.hasImplicitPrecision(n)
            ) and
            afterdot = 6
          ) and
          len = 1 + 309 + dot + afterdot
        ) and
        reason = TTypeBoundsAnalysis() // e.g. -1e308="-100000"...
        or
        this.getConversionChar(n).toLowerCase() = "e" and
        exists(int dot, int afterdot |
          (if this.getPrecision(n) = 0 then dot = 0 else dot = 1) and
          (
            (
              if this.hasExplicitPrecision(n)
              then afterdot = this.getPrecision(n)
              else not this.hasImplicitPrecision(n)
            ) and
            afterdot = 6
          ) and
          len = 1 + 1 + dot + afterdot + 1 + 1 + 3
        ) and
        reason = TTypeBoundsAnalysis() // -1e308="-1.000000e+308"
        or
        this.getConversionChar(n).toLowerCase() = "g" and
        exists(int dot, int afterdot |
          (if this.getPrecision(n) = 0 then dot = 0 else dot = 1) and
          (
            (
              if this.hasExplicitPrecision(n)
              then afterdot = this.getPrecision(n)
              else not this.hasImplicitPrecision(n)
            ) and
            afterdot = 6
          ) and
          // note: this could be displayed in the style %e or %f;
          //       however %f is only used when 'P > X >= -4'
          //         where P is the precision (default 6, minimum 1)
          //         and X is the exponent
          //         using a precision of P - 1 - X (i.e. to P significant figures)
          //       in other words the number is displayed to P significant figures if that is enough to express
          //       it with no trailing zeroes and at most four leading zeroes beyond the significant figures
          //       (e.g. 123456, 0.000123456 are just OK)
          //       so case %f can be at most P characters + 4 zeroes, sign, dot = P + 6
          len = (afterdot.maximum(1) + 6).maximum(1 + 1 + dot + afterdot + 1 + 1 + 3)
        ) and
        reason = TTypeBoundsAnalysis() // (e.g. "-1.59203e-319")
        or
        this.getConversionChar(n).toLowerCase() = ["d", "i"] and
        // e.g. -2^31 = "-2147483648"
        exists(float typeBasedBound, float valueBasedBound |
          // The first case handles length sub-specifiers
          // Subtract one in the exponent because one bit is for the sign.
          // Add 1 to account for the possible sign in the output.
          typeBasedBound =
            1 + lengthInBase10(2.pow(this.getIntegralDisplayType(n).getSize() * 8 - 1)) and
          // The second case uses range analysis to deduce a length that's shorter than the length
          // of the number -2^31.
          exists(Expr arg, float lower, float upper |
            arg = this.getUse().getConversionArgument(n) and
            lower = lowerBound(arg.getFullyConverted()) and
            upper = upperBound(arg.getFullyConverted())
          |
            valueBasedBound =
              max(int cand |
                // Include the sign bit in the length if it can be negative
                (
                  if lower < 0
                  then cand = 1 + lengthInBase10(lower.abs())
                  else cand = lengthInBase10(lower)
                )
                or
                (
                  if upper < 0
                  then cand = 1 + lengthInBase10(upper.abs())
                  else cand = lengthInBase10(upper)
                )
              ) and
            // we don't want to call this on `arg.getFullyConverted()` as we want
            // to detect non-trivial range analysis without taking into account up-casting
            reason = getEstimationReasonForIntegralExpression(arg)
          ) and
          len = valueBasedBound.minimum(typeBasedBound)
        )
        or
        this.getConversionChar(n).toLowerCase() = "u" and
        // e.g. 2^32 - 1 = "4294967295"
        exists(float typeBasedBound, float valueBasedBound |
          // The first case handles length sub-specifiers
          typeBasedBound = lengthInBase10(2.pow(this.getIntegralDisplayType(n).getSize() * 8) - 1) and
          // The second case uses range analysis to deduce a length that's shorter than
          // the length of the number 2^31 - 1.
          exists(Expr arg, float lower, float upper |
            arg = this.getUse().getConversionArgument(n) and
            lower = lowerBound(arg.getFullyConverted()) and
            upper = upperBound(arg.getFullyConverted())
          |
            valueBasedBound =
              lengthInBase10(max(float cand |
                  // If lower can be negative we use `(unsigned)-1` as the candidate value.
                  lower < 0 and
                  cand = 2.pow(any(IntType t | t.isUnsigned()).getSize() * 8)
                  or
                  cand = upper
                )) and
            // we don't want to call this on `arg.getFullyConverted()` as we want
            // to detect non-trivial range analysis without taking into account up-casting
            reason = getEstimationReasonForIntegralExpression(arg)
          ) and
          len = valueBasedBound.minimum(typeBasedBound)
        )
        or
        this.getConversionChar(n).toLowerCase() = "x" and
        // e.g. "12345678"
        exists(int baseLen, int typeBasedBound, int valueBasedBound |
          typeBasedBound =
            min(int digits |
              digits = 2 * this.getIntegralDisplayType(n).getSize()
              or
              exists(IntegralType t |
                t = this.getUse().getConversionArgument(n).getType().getUnderlyingType()
              |
                t.isUnsigned() and
                digits = 2 * t.getSize()
              )
            ) and
          exists(Expr arg, float lower, float upper, float typeLower, float typeUpper |
            arg = this.getUse().getConversionArgument(n) and
            lower = lowerBound(arg.getFullyConverted()) and
            upper = upperBound(arg.getFullyConverted()) and
            typeLower = exprMinVal(arg.getFullyConverted()) and
            typeUpper = exprMaxVal(arg.getFullyConverted())
          |
            valueBasedBound =
              lengthInBase16(max(float cand |
                  // If lower can be negative we use `(unsigned)-1` as the candidate value.
                  lower < 0 and
                  cand = 2.pow(any(IntType t | t.isUnsigned()).getSize() * 8)
                  or
                  cand = upper
                )) and
            (
              if lower > typeLower or upper < typeUpper
              then reason = TValueFlowAnalysis()
              else reason = TTypeBoundsAnalysis()
            )
          ) and
          baseLen = valueBasedBound.minimum(typeBasedBound) and
          if this.hasAlternateFlag(n) then len = 2 + baseLen else len = baseLen // "0x"
        )
        or
        this.getConversionChar(n).toLowerCase() = "p" and
        exists(PointerType ptrType, int baseLen |
          ptrType = this.getFullyConverted().getType() and
          baseLen = max(ptrType.getSize() * 2) and // e.g. "0x1234567812345678"; exact format is platform dependent
          (
            if this.hasAlternateFlag(n) then len = 2 + baseLen else len = baseLen // "0x"
          )
        ) and
        reason = TValueFlowAnalysis()
        or
        this.getConversionChar(n).toLowerCase() = "o" and
        // e.g. 2^32 - 1 = "37777777777"
        exists(int sizeBits, int baseLen |
          sizeBits =
            min(int bits |
              bits = this.getIntegralDisplayType(n).getSize() * 8
              or
              exists(IntegralType t |
                t = this.getUse().getConversionArgument(n).getType().getUnderlyingType()
              |
                t.isUnsigned() and bits = t.getSize() * 8
              )
            ) and
          baseLen = (sizeBits / 3.0).ceil() and
          (
            if this.hasAlternateFlag(n) then len = 1 + baseLen else len = baseLen // "0"
          )
        ) and
        reason = TTypeBoundsAnalysis()
        or
        this.getConversionChar(n).toLowerCase() = "s" and
        len =
          min(int v |
            v = this.getPrecision(n) or
            v = this.getUse().getFormatArgument(n).(AnalysedString).getMaxLength() - 1 // (don't count null terminator)
          ) and
        reason = TValueFlowAnalysis()
      )
    )
  }

  /**
   * Gets the maximum length of the string that can be produced by the nth
   * conversion specifier of this format string, except that float to string
   * conversions are assumed to be 8 characters.  This is helpful for
   * determining whether a buffer overflow is caused by long float to string
   * conversions.
   */
  int getMaxConvertedLengthLimited(int n) { result = max(this.getMaxConvertedLengthLimited(n, _)) }

  /**
   * Gets the maximum length of the string that can be produced by the nth
   * conversion specifier of this format string, specifying the reason for the
   * estimation, except that float to string conversions are assumed to be 8
   * characters.  This is helpful for determining whether a buffer overflow is
   * caused by long float to string conversions.
   */
  int getMaxConvertedLengthLimited(int n, BufferWriteEstimationReason reason) {
    if this.getConversionChar(n).toLowerCase() = "f"
    then result = this.getMaxConvertedLength(n, reason).minimum(8)
    else result = this.getMaxConvertedLength(n, reason)
  }

  /**
   * Gets the constant part of the format string just before the nth
   * conversion specifier.  If `n` is zero, this will be the constant prefix
   * before the 0th specifier, otherwise it is the string between the end
   * of the n-1th specifier and the nth specifier.  Has no result if `n`
   * is negative or not strictly less than the number of conversion
   * specifiers.
   */
  string getConstantPart(int n) {
    if n = 0
    then result = this.getFormat().substring(0, this.getConvSpecOffset(0))
    else
      result =
        this.getFormat()
            .substring(this.getConvSpecOffset(n - 1) + this.getConvSpec(n - 1).length(),
              this.getConvSpecOffset(n))
  }

  /**
   * Gets the constant part of the format string after the last conversion
   * specifier.
   */
  string getConstantSuffix() {
    exists(int n |
      n = this.getNumConvSpec() and
      (
        if n > 0
        then
          result =
            this.getFormat()
                .substring(this.getConvSpecOffset(n - 1) + this.getConvSpec(n - 1).length(),
                  this.getFormat().length())
        else result = this.getFormat()
      )
    )
  }

  private int getMaxConvertedLengthAfter(int n, BufferWriteEstimationReason reason) {
    if n = this.getNumConvSpec()
    then result = this.getConstantSuffix().length() + 1 and reason = TValueFlowAnalysis()
    else
      exists(BufferWriteEstimationReason headReason, BufferWriteEstimationReason tailReason |
        result =
          this.getConstantPart(n).length() + this.getMaxConvertedLength(n, headReason) +
            this.getMaxConvertedLengthAfter(n + 1, tailReason) and
        reason = headReason.combineWith(tailReason)
      )
  }

  private int getMaxConvertedLengthAfterLimited(int n, BufferWriteEstimationReason reason) {
    if n = this.getNumConvSpec()
    then result = this.getConstantSuffix().length() + 1 and reason = TValueFlowAnalysis()
    else
      exists(BufferWriteEstimationReason headReason, BufferWriteEstimationReason tailReason |
        result =
          this.getConstantPart(n).length() + this.getMaxConvertedLengthLimited(n, headReason) +
            this.getMaxConvertedLengthAfterLimited(n + 1, tailReason) and
        reason = headReason.combineWith(tailReason)
      )
  }

  /**
   * Gets the maximum length of the string that can be produced by this format
   * string.  Has no result if this cannot be determined.
   */
  int getMaxConvertedLength() { result = this.getMaxConvertedLengthAfter(0, _) }

  /**
   * Gets the maximum length of the string that can be produced by this format
   * string, except that float to string conversions are assumed to be 8
   * characters.  This is helpful for determining whether a buffer overflow
   * is caused by long float to string conversions.
   */
  int getMaxConvertedLengthLimited() { result = this.getMaxConvertedLengthAfterLimited(0, _) }

  /**
   * Gets the maximum length of the string that can be produced by this format
   * string, specifying the reason for the estimate. Has no result if no estimate
   * can be found.
   */
  int getMaxConvertedLengthWithReason(BufferWriteEstimationReason reason) {
    result = this.getMaxConvertedLengthAfter(0, reason)
  }

  /**
   * Gets the maximum length of the string that can be produced by this format
   * string, specifying the reason for the estimate, except that float to string
   * conversions are assumed to be 8 characters.  This is helpful for determining
   * whether a buffer overflow is caused by long float to string conversions.
   */
  int getMaxConvertedLengthLimitedWithReason(BufferWriteEstimationReason reason) {
    result = this.getMaxConvertedLengthAfterLimited(0, reason)
  }
}
