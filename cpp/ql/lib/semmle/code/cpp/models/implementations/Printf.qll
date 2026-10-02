/**
 * Provides implementation classes modeling various standard formatting
 * functions (`printf`, `snprintf` etc).
 * See `semmle.code.cpp.models.interfaces.FormattingFunction` for usage
 * information.
 */

import semmle.code.cpp.models.interfaces.FormattingFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.NonThrowing

/**
 * A formatting function that takes its format arguments through a `va_list` parameter.
 */
abstract private class VaListFormattingFunction extends FormattingFunction {
  final override int getFirstFormatArgumentIndex() { none() }

  final int getVaListParameterIndex() { result = this.getNumberOfParameters() - 1 }

  private predicate hasLocaleParameter() { this.getName().matches("%\\_l") }

  final override int getFormatParameterIndex() {
    if this.hasLocaleParameter()
    then result = this.getVaListParameterIndex() - 2
    else result = this.getVaListParameterIndex() - 1
  }
}

/**
 * The standard functions `printf`, `wprintf` and their glib variants.
 */
private class Printf extends FormattingFunction, AliasFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Printf() {
    (
      this.hasGlobalOrStdOrBslName(["printf", "wprintf"]) or
      this.hasGlobalName(["printf_s", "wprintf_s", "g_printf"])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 0 }

  override predicate isOutputGlobal() { any() }

  override predicate parameterNeverEscapes(int n) { n = 0 }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }
}

/**
 * The standard functions `fprintf`, `fwprintf` and their glib variants.
 */
private class Fprintf extends FormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Fprintf() {
    (
      this.hasGlobalOrStdOrBslName(["fprintf", "fwprintf"]) or
      this.hasGlobalName("g_fprintf")
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = true }
}

/**
 * The standard functions `vprintf`, `vwprintf` and their Microsoft variants.
 */
private class Vprintf extends VaListFormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Vprintf() {
    (
      this.hasGlobalOrStdOrBslName(["vprintf", "vwprintf"]) or
      this.hasGlobalName(["_vprintf_l", "_vwprintf_l"])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override predicate isOutputGlobal() { any() }
}

/**
 * The standard functions `vfprintf`, `vfwprintf` and their Microsoft variants.
 */
private class Vfprintf extends VaListFormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Vfprintf() {
    (
      this.hasGlobalOrStdOrBslName(["vfprintf", "vfwprintf"]) or
      this.hasGlobalName(["_vfprintf_l", "_vfwprintf_l"])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = true }
}

/**
 * The standard function `sprintf` and its Microsoft and glib variants.
 */
private class Sprintf extends FormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Sprintf() {
    (
      this.hasGlobalOrStdOrBslName([
          "sprintf", // sprintf(dst, format, args...)
          "wsprintf" // wsprintf(dst, format, args...)
        ])
      or
      this.hasGlobalName([
          "_sprintf_l", // _sprintf_l(dst, format, locale, args...)
          "__swprintf_l", // __swprintf_l(dst, format, locale, args...)
          "g_strdup_printf", // g_strdup_printf(format, ...)
          "g_sprintf", // g_sprintf(dst, format, ...)
          "__builtin___sprintf_chk" // __builtin___sprintf_chk(dst, flag, os, format, ...)
        ])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    this.hasName("g_strdup_printf") and result = 0
    or
    this.hasName("__builtin___sprintf_chk") and result = 3
    or
    not this.getName() = ["g_strdup_printf", "__builtin___sprintf_chk"] and
    result = 1
  }

  override int getOutputParameterIndex(boolean isStream) {
    not this.hasName("g_strdup_printf") and result = 0 and isStream = false
  }

  override int getFirstFormatArgumentIndex() {
    if this.hasName("__builtin___sprintf_chk")
    then result = 4
    else result = super.getFirstFormatArgumentIndex()
  }
}

/**
 * The standard function `vsprintf` and its Microsoft variants.
 */
private class Vsprintf extends VaListFormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Vsprintf() {
    (
      this.hasGlobalOrStdOrBslName("vsprintf") or // vsprintf(dst, format, va_list)
      this.hasGlobalName([
          "_vsprintf_l", // _vsprintf_l(dst, format, locale, va_list)
          "__vswprintf_l" // __vswprintf_l(dst, format, locale, va_list)
        ])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }
}

/**
 * Implements `Snprintf`.
 */
private class SnprintfImpl extends Snprintf, AliasFunction, SideEffectFunction,
  NonCppThrowingFunction instanceof TopLevelFunction
{
  SnprintfImpl() {
    (
      this.hasGlobalOrStdOrBslName([
          "snprintf", // C99 defines snprintf
          "swprintf" // The s version of wide-char printf is also always the n version
        ])
      or
      // Microsoft has _snprintf as well as several other variations
      this.hasGlobalName([
          "sprintf_s", "snprintf_s", "swprintf_s", "_snprintf", "_snprintf_s", "_snprintf_l",
          "_snprintf_s_l", "_snwprintf", "_snwprintf_s", "_snwprintf_l", "_snwprintf_s_l",
          "_sprintf_s_l", "_swprintf_l", "_swprintf_s_l", "g_snprintf", "wnsprintf",
          "__builtin___snprintf_chk"
        ])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if this.getName().matches("%\\_l")
    then result = this.getFirstFormatArgumentIndex() - 2
    else result = this.getFirstFormatArgumentIndex() - 1
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }

  override int getFirstFormatArgumentIndex() {
    exists(string name |
      name = this.getQualifiedName() and
      (
        name = "__builtin___snprintf_chk" and
        result = 5
        or
        name != "__builtin___snprintf_chk" and
        result = this.getNumberOfParameters()
      )
    )
  }

  override predicate returnsFullFormatLength() {
    this.hasName(["snprintf", "g_snprintf", "__builtin___snprintf_chk", "snprintf_s"]) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getSizeParameterIndex() { result = 1 }

  override predicate parameterNeverEscapes(int index) {
    // We don't know how many parameters are passed to the function since it's varargs, but they also don't escape.
    index = this.getFormatParameterIndex()
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getOutputParameterIndex(false) and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    // We don't know how many parameters are passed to the function since it's varargs, but they also have read side effects.
    i = this.getFormatParameterIndex() and buffer = true
  }
}

/**
 * The standard function `vsnprintf`, and its Microsoft variants.
 */
private class VsnprintfImpl extends Snprintf, VaListFormattingFunction, AliasFunction,
  SideEffectFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  VsnprintfImpl() {
    (
      this.hasGlobalOrStdOrBslName("vsnprintf") // vsnprintf(dst, count, format, va_list)
      or
      this.hasGlobalName([
          "vsnprintf_s", // vsnprintf_s(dst, size, count, format, va_list)
          "vsprintf_s", // vsprintf_s(dst, size, format, va_list)
          "vswprintf_s", // vswprintf_s(dst, size, format, va_list)
          "_vsnprintf", // _vsnprintf(dst, count, format, va_list)
          "_vsnprintf_l", // _vsnprintf_l(dst, count, format, locale, va_list)
          "_vsnprintf_s", // _vsnprintf_s(dst, size, count, format, va_list)
          "_vsnprintf_s_l", // _vsnprintf_s_l(dst, size, count, format, locale, va_list)
          "_vsnwprintf", // _vsnwprintf(dst, count, format, va_list)
          "_vsnwprintf_l", // _vsnwprintf_l(dst, count, format, locale, va_list)
          "_vsnwprintf_s", // _vsnwprintf_s(dst, size, count, format, va_list)
          "_vsnwprintf_s_l", // _vsnwprintf_s_l(dst, size, count, format, locale, va_list)
          "_vsprintf_p", // _vsprintf_p(dst, size, format, va_list)
          "_vsprintf_p_l", // _vsprintf_p_l(dst, size, format, locale, va_list)
          "_vsprintf_s_l", // _vsprintf_s_l(dst, size, format, locale, va_list)
          "_vswprintf_p", // _vswprintf_p(dst, count, format, va_list)
          "_vswprintf_p_l", // _vswprintf_p_l(dst, count, format, locale, va_list)
          "_vswprintf_s_l" // _vswprintf_s_l(dst, size, format, locale, va_list)
        ])
      or
      this.hasGlobalOrStdOrBslName("vswprintf") and this.getNumberOfParameters() = 4
      or
      this.hasGlobalName("_vswprintf_l") and this.getNumberOfParameters() = 5
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }

  override int getSizeParameterIndex() { result = 1 }

  override predicate returnsFullFormatLength() { this.hasName(["vsnprintf", "vsnprintf_s"]) }

  override predicate parameterNeverEscapes(int index) {
    index =
      [
        this.getOutputParameterIndex(false), this.getFormatParameterIndex(),
        this.getVaListParameterIndex()
      ]
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getOutputParameterIndex(false) and buffer = true and mustWrite = false
    or
    i = this.getVaListParameterIndex() and buffer = false and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getFormatParameterIndex() and buffer = true
    or
    i = this.getVaListParameterIndex() and buffer = false
  }
}

/**
 * The Microsoft `_vscprintf_p` functions and variants.
 */
private class Vscprintf extends VaListFormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction
{
  Vscprintf() {
    this.hasGlobalName([
        "_vscprintf_p", // _vscprintf_p(format, va_list)
        "_vscprintf_p_l", // _vscprintf_p_l(format, locale, va_list)
        "_vscwprintf_p", // _vscwprintf_p(format, va_list)
        "_vscwprintf_p_l" // _vscwprintf_p_l(format, locale, va_list)
      ]) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }
}

/**
 * The Microsoft `StringCchPrintf` function and variants.
 * See: https://learn.microsoft.com/en-us/windows/win32/api/strsafe/
 *      and
 *      https://learn.microsoft.com/en-us/previous-versions/windows/embedded/ms860435(v=msdn.10)
 */
private class StringCchPrintf extends FormattingFunction instanceof TopLevelFunction {
  StringCchPrintf() {
    exists(string baseName |
      baseName in [
          "StringCchPrintf", //StringCchPrintf(pszDest, cchDest, pszFormat, ...)
          "StringCchPrintfEx", //StringCchPrintfEx(pszDest,cchDest, ppszDestEnd, pcchRemaining, dwFlags, pszFormat, ...)
          "StringCchPrintf_l", //StringCchPrintf_l(pszDest, cbDest, pszFormat, locale, ...)
          "StringCchPrintf_lEx", //StringCchPrintf_lEx(pszDest, cchDest, ppszDestEnd, pcchRemaining, dwFlags, pszFormat, locale, ...)
          "StringCbPrintf", //StringCbPrintf(pszDest, cbDest, pszFormat, ...)
          "StringCbPrintfEx", //StringCbPrintfEx(pszDest, cbDest, ppszDestEnd, pcbRemaining, dwFlags, pszFormat, ...)
          "StringCbPrintf_l", //StringCbPrintf_l(pszDest, cbDest, pszFormat, locale, ...)
          "StringCbPrintf_lEx" //StringCbPrintf_lEx(pszDest, cbDest, ppszDestEnd, pcbRemaining, dwFlags, pszFormat, locale, ...)
        ]
    |
      this.hasGlobalName(baseName + ["", "A", "W"])
    ) and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if this.getName().matches("%Ex" + ["", "A", "W"]) then result = 5 else result = 2
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }

  override int getSizeParameterIndex() { result = 1 }
}

/**
 * The standard function `syslog`.
 */
private class Syslog extends FormattingFunction, NonCppThrowingFunction instanceof TopLevelFunction {
  Syslog() {
    this.hasGlobalName("syslog") and
    not exists(this.getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }

  override predicate isOutputGlobal() { any() }
}
