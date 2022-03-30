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
private class Printf extends FormattingFunction, AliasFunction {
  Printf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdOrBslName(["printf", "wprintf"]) or
      hasGlobalName(["printf_s", "wprintf_s", "g_printf"])
    ) and
    not exists(getDefinition().getFile().getRelativePath())
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
private class Fprintf extends FormattingFunction {
  Fprintf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdOrBslName(["fprintf", "fwprintf"]) or
      hasGlobalName("g_fprintf")
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = true }
}

/**
 * The standard function `sprintf` and its Microsoft and glib variants.
 */
private class Sprintf extends FormattingFunction {
  Sprintf() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdOrBslName([
          "sprintf", // sprintf(dst, format, args...)
          "wsprintf" // wsprintf(dst, format, args...)
        ])
      or
      hasGlobalName([
          "_sprintf_l", // _sprintf_l(dst, format, locale, args...)
          "__swprintf_l", // __swprintf_l(dst, format, locale, args...)
          "g_strdup_printf", // g_strdup_printf(format, ...)
          "g_sprintf", // g_sprintf(dst, format, ...)
          "__builtin___sprintf_chk" // __builtin___sprintf_chk(dst, flag, os, format, ...)
        ])
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    hasName("g_strdup_printf") and result = 0
    or
    hasName("__builtin___sprintf_chk") and result = 3
    or
    not getName() = ["g_strdup_printf", "__builtin___sprintf_chk"] and
    result = 1
  }

  override int getOutputParameterIndex(boolean isStream) {
    not hasName("g_strdup_printf") and result = 0 and isStream = false
  }

  override int getFirstFormatArgumentIndex() {
    if hasName("__builtin___sprintf_chk") then result = 4 else result = getNumberOfParameters()
  }
}

/**
 * Implements `Snprintf`.
 */
private class SnprintfImpl extends Snprintf {
  SnprintfImpl() {
    this instanceof TopLevelFunction and
    (
      hasGlobalOrStdOrBslName([
          "snprintf", // C99 defines snprintf
          "swprintf" // The s version of wide-char printf is also always the n version
        ])
      or
      // Microsoft has _snprintf as well as several other variations
      hasGlobalName([
          "sprintf_s", "snprintf_s", "swprintf_s", "_snprintf", "_snprintf_s", "_snprintf_l",
          "_snprintf_s_l", "_snwprintf", "_snwprintf_s", "_snwprintf_l", "_snwprintf_s_l",
          "_sprintf_s_l", "_swprintf_l", "_swprintf_s_l", "g_snprintf", "wnsprintf",
          "__builtin___snprintf_chk"
        ])
    ) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if getName().matches("%\\_l")
    then result = getFirstFormatArgumentIndex() - 2
    else result = getFirstFormatArgumentIndex() - 1
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }

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

  override predicate returnsFullFormatLength() {
    hasName(["snprintf", "g_snprintf", "__builtin___snprintf_chk", "snprintf_s"]) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getSizeParameterIndex() { result = 1 }
}

/**
 * The Microsoft `StringCchPrintf` function and variants.
 */
private class StringCchPrintf extends FormattingFunction {
  StringCchPrintf() {
    this instanceof TopLevelFunction and
    hasGlobalName([
        "StringCchPrintf", "StringCchPrintfEx", "StringCchPrintf_l", "StringCchPrintf_lEx",
        "StringCbPrintf", "StringCbPrintfEx", "StringCbPrintf_l", "StringCbPrintf_lEx"
      ]) and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() {
    if getName().matches("%Ex") then result = 5 else result = 2
  }

  override int getOutputParameterIndex(boolean isStream) { result = 0 and isStream = false }

  override int getSizeParameterIndex() { result = 1 }
}

/**
 * The standard function `syslog`.
 */
private class Syslog extends FormattingFunction {
  Syslog() {
    this instanceof TopLevelFunction and
    hasGlobalName("syslog") and
    not exists(getDefinition().getFile().getRelativePath())
  }

  override int getFormatParameterIndex() { result = 1 }

  override predicate isOutputGlobal() { any() }
}
