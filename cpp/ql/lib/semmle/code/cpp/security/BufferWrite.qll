/**
 * @name CWE-120
 * @description Buffer Copy without Checking Size of Input ('Classic Buffer Overflow').
 * @kind problem
 * @problem.severity recommendation
 */

import cpp
import semmle.code.cpp.commons.Alloc
import semmle.code.cpp.commons.Buffer
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.models.implementations.Strcat
import semmle.code.cpp.models.implementations.Strcpy

/*
 * --- BufferWrite framework ---
 */

/**
 * An operation that writes a variable amount of data to a buffer
 * (strcpy, strncat, sprintf etc).
 *
 * Note that there are two related class frameworks:
 *  - BufferWrite provides detailed coverage of null-terminated
 *    buffer write operations.
 *  - BufferAccess provides general coverage of buffer read and write
 *    operations whose size is either not data-dependent, or has an upper
 *    bound which is not data-dependent.
 * This design has some overlaps between the two classes, for example
 * the write of a 'strncpy'.
 */
abstract class BufferWrite extends Expr {
  /*
   * --- derived classes override these ---
   */

  /**
   * Gets the (unspecified) type of the buffer this operation works
   * with (for example `char *`).
   */
  abstract Type getBufferType();

  /**
   * Gets a data source of this operation (e.g. the source string,
   * format string; not necessarily copied as-is).
   */
  Expr getASource() { none() }

  /**
   * Gets the destination buffer of this operation.
   */
  abstract Expr getDest();

  /**
   * Holds if the operation has an explicit parameter that limits the amount
   * of data written (e.g. `strncpy` does, whereas `strcpy` does not); this
   * is not the same as exists(getExplicitLimit()) because the limit may exist
   * though it's value is unknown.
   */
  predicate hasExplicitLimit() { none() }

  /**
   * Gets the explicit limit of bytes copied by this operation, if it exists
   * and it's value can be determined.
   */
  int getExplicitLimit() { none() }

  /**
   * Gets an upper bound to the amount of data that's being written (if one
   * can be found).
   */
  int getMaxData() { none() }

  /**
   * Gets an upper bound to the amount of data that's being written (if one
   * can be found), specifying the reason for the estimation.
   */
  int getMaxData(BufferWriteEstimationReason reason) {
    reason instanceof UnspecifiedEstimateReason and result = this.getMaxData()
  }

  /**
   * Gets an upper bound to the amount of data that's being written (if one
   * can be found), except that float to string conversions are assumed to be
   * much smaller (8 bytes) than their true maximum length.  This can be
   * helpful in determining the cause of a buffer overflow issue.
   */
  int getMaxDataLimited() { result = this.getMaxData() }

  /**
   * Gets an upper bound to the amount of data that's being written (if one
   * can be found), specifying the reason for the estimation, except that
   * float to string conversions are assumed to be much smaller (8 bytes)
   * than their true maximum length.  This can be helpful in determining the
   * cause of a buffer overflow issue.
   */
  int getMaxDataLimited(BufferWriteEstimationReason reason) { result = this.getMaxData(reason) }

  /**
   * Gets the size of a single character of the type this
   * operation works with, in bytes.
   */
  int getCharSize() {
    result = this.getBufferType().(PointerType).getBaseType().getSize() or
    result = this.getBufferType().(ArrayType).getBaseType().getSize()
  }

  /**
   * Gets a description of this buffer write.
   */
  string getBWDesc() { result = this.toString() }
}

/**
 * A `BufferWrite` that is also a `FunctionCall` (most cases).
 */
abstract class BufferWriteCall extends BufferWrite, FunctionCall { }

/*
 * --- BufferWrite classes ---
 */

/**
 * A call to a variant of `strcpy`.
 */
class StrCopyBW extends BufferWriteCall {
  StrcpyFunction f;

  StrCopyBW() { this.getTarget() = f.(TopLevelFunction) }

  /**
   * Gets the index of the parameter that is the maximum size of the copy (in characters).
   */
  int getParamSize() { result = f.getParamSize() }

  /**
   * Gets the index of the parameter that is the source of the copy.
   */
  int getParamSrc() { result = f.getParamSrc() }

  override Type getBufferType() {
    result = this.getTarget().getParameter(this.getParamSrc()).getUnspecifiedType()
  }

  override Expr getASource() { result = this.getArgument(this.getParamSrc()) }

  override Expr getDest() { result = this.getArgument(f.getParamDest()) }

  override predicate hasExplicitLimit() { exists(this.getParamSize()) }

  override int getExplicitLimit() {
    result = this.getArgument(this.getParamSize()).getValue().toInt() * this.getCharSize()
  }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    // when result exists, it is an exact flow analysis
    reason instanceof ValueFlowAnalysis and
    result =
      this.getArgument(this.getParamSrc()).(AnalysedString).getMaxLength() * this.getCharSize()
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }
}

/**
 * A call to a variant of `strcat`.
 */
class StrCatBW extends BufferWriteCall {
  StrcatFunction f;

  StrCatBW() { this.getTarget() = f.(TopLevelFunction) }

  /**
   * Gets the index of the parameter that is the maximum size of the copy (in characters).
   */
  int getParamSize() { result = f.getParamSize() }

  /**
   * Gets the index of the parameter that is the source of the copy.
   */
  int getParamSrc() { result = f.getParamSrc() }

  override Type getBufferType() {
    result = this.getTarget().getParameter(this.getParamSrc()).getUnspecifiedType()
  }

  override Expr getASource() { result = this.getArgument(this.getParamSrc()) }

  override Expr getDest() { result = this.getArgument(f.getParamDest()) }

  override predicate hasExplicitLimit() { exists(this.getParamSize()) }

  override int getExplicitLimit() {
    result = this.getArgument(this.getParamSize()).getValue().toInt() * this.getCharSize()
  }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    // when result exists, it is an exact flow analysis
    reason instanceof ValueFlowAnalysis and
    result =
      this.getArgument(this.getParamSrc()).(AnalysedString).getMaxLength() * this.getCharSize()
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }
}

/**
 * A call to a variant of `sprintf`.
 */
class SprintfBW extends BufferWriteCall {
  FormattingFunction f;

  SprintfBW() {
    exists(string name | f = this.getTarget().(TopLevelFunction) and name = f.getName() |
      /*
       * C sprintf variants:
       */

      // sprintf(dst, format, args...)
      name = "sprintf"
      or
      // vsprintf(dst, format, va_list)
      name = "vsprintf"
      or
      // wsprintf(dst, format, args...)
      name = "wsprintf"
      or
      // vwsprintf(dst, format, va_list)
      name = "vwsprintf"
      or
      /*
       * Microsoft sprintf variants:
       */

      //  _sprintf_l(dst, format, locale, args...)
      name.regexpMatch("_sprintf_l")
      or
      //  _vsprintf_l(dst, format, locale, va_list))
      name.regexpMatch("_vsprintf_l")
      or
      // __swprintf_l(dst, format, locale, args...)
      name.regexpMatch("__swprintf_l")
      or
      // __vswprintf_l(dst, format, locale, va_list)
      name.regexpMatch("__vswprintf_l")
    )
  }

  override Type getBufferType() {
    result = f.getParameter(f.getFormatParameterIndex()).getUnspecifiedType()
  }

  override Expr getASource() {
    result = this.(FormattingFunctionCall).getFormat()
    or
    result = this.(FormattingFunctionCall).getFormatArgument(_)
  }

  override Expr getDest() { result = this.getArgument(f.getOutputParameterIndex(false)) }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    exists(FormatLiteral fl |
      fl = this.(FormattingFunctionCall).getFormat() and
      result = fl.getMaxConvertedLengthWithReason(reason) * this.getCharSize()
    )
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }

  private int getMaxDataLimitedImpl(BufferWriteEstimationReason reason) {
    exists(FormatLiteral fl |
      fl = this.(FormattingFunctionCall).getFormat() and
      result = fl.getMaxConvertedLengthLimitedWithReason(reason) * this.getCharSize()
    )
  }

  override int getMaxDataLimited(BufferWriteEstimationReason reason) {
    result = this.getMaxDataLimitedImpl(reason)
  }

  override int getMaxDataLimited() { result = max(this.getMaxDataLimitedImpl(_)) }
}

/**
 * A call to a variant of `snprintf`.
 */
class SnprintfBW extends BufferWriteCall {
  SnprintfBW() {
    exists(TopLevelFunction fn, string name | fn = this.getTarget() and name = fn.getName() |
      /*
       * C snprintf variants:
       */

      // snprintf(dst, max_amount, format, args...)
      name = "snprintf"
      or
      // vsnprintf(dst, max_amount, format, va_list)
      name = "vsnprintf"
      or
      // swprintf(dst, max_amount, format, args...)
      name = "swprintf"
      or
      // vswprintf(dst, max_amount, format, va_list)
      name = "vswprintf"
      or
      /*
       * Microsoft snprintf variants:
       */

      // sprintf_s(dst, max_amount, format, locale, args...)
      name = "sprintf_s"
      or
      // vsprintf_s(dst, max_amount, format, va_list)
      name = "vsprintf_s"
      or
      // swprintf_s(dst, max_amount, format, args...)
      name = "swprintf_s"
      or
      // vswprintf_s(dst, max_amount, format, va_list)
      name = "vswprintf_s"
      or
      // Microsoft snprintf variants with '_':
      // _sprintf_s_l(dst, max_amount, format, locale, args...)
      // _swprintf_l(dst, max_amount, format, locale, args...)
      // _swprintf_s_l(dst, max_amount, format, locale, args...)
      // _snprintf(dst, max_amount, format, args...)
      // _snprintf_l(dst, max_amount, format, locale, args...)
      // _snwprintf(dst, max_amount, format, args...)
      // _snwprintf_l(buffer, max_amount, format, locale, args...)
      // _vsprintf_s_l(dst, max_amount, format, locale, va_list)
      // _vsprintf_p(dst, max_amount, format, va_list)
      // _vsprintf_p_l(dst, max_amount, format, locale, va_list)
      // _vswprintf_l(dst, max_amount, format, locale, va_list)
      // _vswprintf_s_l(buffer, max_amount, format, locale, va_list)
      // _vswprintf_p(dst, max_amount, format, va_list)
      // _vswprintf_p_l(dst, max_amount, format, locale, va_list)
      // _vsnprintf(dst, max_amount, format, va_list)
      // _vsnprintf_l(dst, max_amount, format, locale, va_list)
      // _vsnwprintf(dst, max_amount, format, va_list)
      // _vsnwprintf_l(dst, max_amount, format, locale, va_list)
      name.regexpMatch("_v?sn?w?printf(_s)?(_p)?(_l)?") and
      not this instanceof SprintfBW
    )
  }

  /**
   * Gets the index of the parameter that is the size of the destination (in characters).
   */
  int getParamSize() { result = 1 }

  override Type getBufferType() {
    exists(FormattingFunction f |
      f = this.getTarget() and
      result = f.getParameter(f.getFormatParameterIndex()).getUnspecifiedType()
    )
  }

  override Expr getASource() {
    result = this.(FormattingFunctionCall).getFormat()
    or
    result = this.(FormattingFunctionCall).getFormatArgument(_)
  }

  override Expr getDest() { result = this.getArgument(0) }

  override predicate hasExplicitLimit() { exists(this.getParamSize()) }

  override int getExplicitLimit() {
    result = this.getArgument(this.getParamSize()).getValue().toInt() * this.getCharSize()
  }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    exists(FormatLiteral fl |
      fl = this.(FormattingFunctionCall).getFormat() and
      result = fl.getMaxConvertedLengthWithReason(reason) * this.getCharSize()
    )
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }

  private int getMaxDataLimitedImpl(BufferWriteEstimationReason reason) {
    exists(FormatLiteral fl |
      fl = this.(FormattingFunctionCall).getFormat() and
      result = fl.getMaxConvertedLengthLimitedWithReason(reason) * this.getCharSize()
    )
  }

  override int getMaxDataLimited(BufferWriteEstimationReason reason) {
    result = this.getMaxDataLimitedImpl(reason)
  }

  override int getMaxDataLimited() { result = max(this.getMaxDataLimitedImpl(_)) }
}

/**
 * A call to a variant of `gets`.
 */
class GetsBW extends BufferWriteCall {
  GetsBW() {
    this.getTarget().(TopLevelFunction).getName() =
      [
        "gets", // gets(dst)
        "fgets", // fgets(dst, max_amount, src_stream)
        "fgetws" // fgetws(dst, max_amount, src_stream)
      ]
  }

  /**
   * Gets the index of the parameter that is the maximum number of characters to be read.
   */
  int getParamSize() { exists(this.getArgument(1)) and result = 1 }

  override Type getBufferType() { result = this.getTarget().getParameter(0).getUnspecifiedType() }

  override Expr getASource() {
    if exists(this.getArgument(2))
    then result = this.getArgument(2)
    else
      // the source is input inside the 'gets' call itself
      result = this
  }

  override Expr getDest() { result = this.getArgument(0) }

  override predicate hasExplicitLimit() { exists(this.getParamSize()) }

  override int getExplicitLimit() {
    result = this.getArgument(this.getParamSize()).getValue().toInt() * this.getCharSize()
  }
}

/**
 * A string that is written by a `scanf`-like function.
 */
class ScanfBW extends BufferWrite {
  ScanfBW() {
    exists(ScanfFunctionCall fc, ScanfFormatLiteral fl, int arg, int args_pos |
      this = fc.getArgument(arg) and
      args_pos = fc.getTarget().getNumberOfParameters() and
      arg >= args_pos and
      fl = fc.getFormat() and
      fl.getConversionChar(arg - args_pos) = "s"
    )
  }

  /**
   * Gets the index of the parameter that is the first format argument.
   */
  int getParamArgs() {
    exists(FunctionCall fc |
      this = fc.getArgument(_) and
      result = fc.getTarget().getNumberOfParameters()
    )
  }

  override Type getBufferType() {
    exists(ScanfFunction f, ScanfFunctionCall fc |
      this = fc.getArgument(_) and
      f = fc.getTarget() and
      result = f.getParameter(f.getFormatParameterIndex()).getUnspecifiedType()
    )
  }

  override Expr getASource() {
    exists(ScanfFunctionCall fc |
      this = fc.getArgument(_) and
      (
        // inputs are: the format string, input or the argument itself (if there's no explicit input)
        result = fc.getFormat()
        or
        result = fc.getArgument(fc.getInputParameterIndex())
        or
        not exists(fc.getInputParameterIndex()) and result = this
      )
    )
  }

  override Expr getDest() { result = this }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    // when this returns, it is based on exact flow analysis
    reason instanceof ValueFlowAnalysis and
    exists(ScanfFunctionCall fc, ScanfFormatLiteral fl, int arg |
      this = fc.getArgument(arg) and
      fl = fc.getFormat() and
      result = (fl.getMaxConvertedLength(arg - this.getParamArgs()) + 1) * this.getCharSize() // +1 is for the terminating null
    )
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }

  override string getBWDesc() {
    exists(FunctionCall fc |
      this = fc.getArgument(_) and
      result = fc.getTarget().getName() + " string argument"
    )
  }
}

/**
 * A detected definition of PATH_MAX
 */
private int path_max() {
  result = max(Macro macro | macro.getName() = "PATH_MAX" | macro.getBody().toInt())
}

/**
 * A call to `realpath`.
 */
class RealpathBW extends BufferWriteCall {
  RealpathBW() {
    exists(path_max()) and // Ignore realpath() calls if PATH_MAX cannot be determined
    this.getTarget().hasGlobalName("realpath") // realpath(path, resolved_path);
  }

  override Type getBufferType() { result = this.getTarget().getParameter(0).getUnspecifiedType() }

  override Expr getDest() { result = this.getArgument(1) }

  override Expr getASource() { result = this.getArgument(0) }

  private int getMaxDataImpl(BufferWriteEstimationReason reason) {
    // although there may be some unknown invariants guaranteeing that a real path is shorter than PATH_MAX, we can consider providing less than PATH_MAX a problem with high precision
    reason instanceof ValueFlowAnalysis and
    result = path_max() and
    this = this // Suppress a compiler warning
  }

  override int getMaxData(BufferWriteEstimationReason reason) {
    result = this.getMaxDataImpl(reason)
  }

  override int getMaxData() { result = max(this.getMaxDataImpl(_)) }
}
