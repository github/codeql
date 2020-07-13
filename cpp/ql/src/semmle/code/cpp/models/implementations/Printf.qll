/**
 * Provides implementation classes modeling various standard formatting
 * functions (`printf`, `snprintf` etc).
 * See `semmle.code.cpp.models.interfaces.FormattingFunction` for usage
 * information.
 */

import semmle.code.cpp.models.interfaces.FormattingFunction
import semmle.code.cpp.models.interfaces.Alias

/**
 * The standard functions `printf`, `wprintf` and their glib variants.
 */
class Printf extends FormattingFunction, AliasFunction {
  Printf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdName("printf") or
      hasGlobalName("printf_s") or
      hasGlobalOrStdName("wprintf") or
      hasGlobalName("wprintf_s") or
      hasGlobalName("g_printf")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 0 }

  deprecated override predicate isWideCharDefault() {
    hasGlobalOrStdName("wprintf") or
    hasGlobalName("wprintf_s")
  }

  override predicate parameterNeverEscapes(int n) { n = 0 }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }
}

/**
 * The standard functions `fprintf`, `fwprintf` and their glib variants.
 */
class Fprintf extends FormattingFunction {
  Fprintf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdName("fprintf") or
      hasGlobalOrStdName("fwprintf") or
      hasGlobalName("g_fprintf")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }

  deprecated override predicate isWideCharDefault() { hasGlobalOrStdName("fwprintf") }

  override int getOutputParameterIndex() { result = 0 }
}

/**
 * The standard function `sprintf` and its Microsoft and glib variants.
 */
class Sprintf extends FormattingFunction {
  Sprintf() {
    this instanceof TopLevelFunction and
    (
      // sprintf(dst, format, args...)
      hasGlobalOrStdName("sprintf")
      or
      //  _sprintf_l(dst, format, locale, args...)
      hasGlobalName("_sprintf_l")
      or
      // __swprintf_l(dst, format, locale, args...)
      hasGlobalName("__swprintf_l")
      or
      // wsprintf(dst, format, args...)
      hasGlobalOrStdName("wsprintf")
      or
      // g_strdup_printf(format, ...)
      hasGlobalName("g_strdup_printf")
      or
      // g_sprintf(dst, format, ...)
      hasGlobalName("g_sprintf")
      or
      // __builtin___sprintf_chk(dst, flag, os, format, ...)
      hasGlobalName("__builtin___sprintf_chk")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  deprecated override predicate isWideCharDefault() {
    getParameter(getFormatParameterIndex())
        .getType()
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType()
        .getSize() > 1
  }

  override int getFormatParameterIndex() {
    hasGlobalName("g_strdup_printf") and result = 0
    or
    hasGlobalName("__builtin___sprintf_chk") and result = 3
    or
    getName() != "g_strdup_printf" and
    getName() != "__builtin___sprintf_chk" and
    result = 1
  }

  override int getOutputParameterIndex() { not hasGlobalName("g_strdup_printf") and result = 0 }

  override int getFirstFormatArgumentIndex() {
    if hasGlobalName("__builtin___sprintf_chk")
    then result = 4
    else result = getNumberOfParameters()
  }
}

/**
 * The standard functions `snprintf` and `swprintf`, and their
 * Microsoft and glib variants.
 */
class Snprintf extends FormattingFunction {
  Snprintf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdName("snprintf") or // C99 defines snprintf
      hasGlobalOrStdName("swprintf") or // The s version of wide-char printf is also always the n version
      // Microsoft has _snprintf as well as several other variations
      hasGlobalName("sprintf_s") or
      hasGlobalName("snprintf_s") or
      hasGlobalName("swprintf_s") or
      hasGlobalName("_snprintf") or
      hasGlobalName("_snprintf_s") or
      hasGlobalName("_snprintf_l") or
      hasGlobalName("_snprintf_s_l") or
      hasGlobalName("_snwprintf") or
      hasGlobalName("_snwprintf_s") or
      hasGlobalName("_snwprintf_l") or
      hasGlobalName("_snwprintf_s_l") or
      hasGlobalName("_sprintf_s_l") or
      hasGlobalName("_swprintf_l") or
      hasGlobalName("_swprintf_s_l") or
      hasGlobalName("g_snprintf") or
      hasGlobalName("wnsprintf") or
      hasGlobalName("__builtin___snprintf_chk")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if getName().matches("%\\_l")
    then result = getFirstFormatArgumentIndex() - 2
    else result = getFirstFormatArgumentIndex() - 1
  }

  deprecated override predicate isWideCharDefault() {
    getParameter(getFormatParameterIndex())
        .getType()
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType()
        .getSize() > 1
  }

  override int getOutputParameterIndex() { result = 0 }

  override int getFirstFormatArgumentIndex() {
    exists(string name |
      name = getQualifiedName() and
      (
        name = "__builtin___snprintf_chk" and
        result = 5
        or
        name != "__builtin___snprintf_chk" and
        result = getNumberOfParameters()
      )
    )
  }

  /**
   * Holds if this function returns the length of the formatted string
   * that would have been output, regardless of the amount of space
   * in the buffer.
   */
  predicate returnsFullFormatLength() {
    (
      hasGlobalOrStdName("snprintf") or
      hasGlobalName("g_snprintf") or
      hasGlobalName("__builtin___snprintf_chk") or
      hasGlobalName("snprintf_s")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getSizeParameterIndex() { result = 1 }
}

/**
 * The Microsoft `StringCchPrintf` function and variants.
 */
class StringCchPrintf extends FormattingFunction {
  StringCchPrintf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalName("StringCchPrintf") or
      hasGlobalName("StringCchPrintfEx") or
      hasGlobalName("StringCchPrintf_l") or
      hasGlobalName("StringCchPrintf_lEx") or
      hasGlobalName("StringCbPrintf") or
      hasGlobalName("StringCbPrintfEx") or
      hasGlobalName("StringCbPrintf_l") or
      hasGlobalName("StringCbPrintf_lEx")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if getName().matches("%Ex") then result = 5 else result = 2
  }

  deprecated override predicate isWideCharDefault() {
    getParameter(getFormatParameterIndex())
        .getType()
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType()
        .getSize() > 1
  }

  override int getOutputParameterIndex() { result = 0 }

  override int getSizeParameterIndex() { result = 1 }
}

/**
 * The standard function `syslog`.
 */
class Syslog extends FormattingFunction {
  Syslog() {
    this instanceof TopLevelFunction and
    hasGlobalName("syslog") and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }
}
