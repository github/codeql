/**
 * Provides a class for modeling `printf`-style formatting functions. To use
 * this QL library, create a QL class extending `FormattingFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `FormattingFunction` to match the flow within that function.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint

private Type stripTopLevelSpecifiersOnly(Type t) {
  result = stripTopLevelSpecifiersOnly(t.(SpecifiedType).getBaseType())
  or
  result = t and
  not t instanceof SpecifiedType
}

/**
 * A type that is used as a format string by any formatting function.
 */
Type getAFormatterWideType() {
  exists(FormattingFunction ff |
    result = stripTopLevelSpecifiersOnly(ff.getFormatCharType()) and
    result.getSize() != 1
  )
}

/**
 * A type that is used as a format string by any formatting function, or `wchar_t` if
 * there is none.
 */
private Type getAFormatterWideTypeOrDefault() {
  result = getAFormatterWideType()
  or
  not exists(getAFormatterWideType()) and
  result instanceof Wchar_t
}

/**
 * A standard library function that uses a `printf`-like formatting string.
 */
abstract class FormattingFunction extends ArrayFunction, TaintFunction {
  /** Gets the position at which the format parameter occurs. */
  abstract int getFormatParameterIndex();

  override string getAPrimaryQlClass() { result = "FormattingFunction" }

  /**
   * Holds if this `FormattingFunction` is in a context that supports
   * Microsoft rules and extensions.
   */
  predicate isMicrosoft() { anyFileCompiledAsMicrosoft() }

  /**
   * Gets the character type used in the format string for this function.
   */
  Type getFormatCharType() {
    result =
      stripTopLevelSpecifiersOnly(stripTopLevelSpecifiersOnly(getParameter(getFormatParameterIndex())
              .getType()
              .getUnderlyingType()).(PointerType).getBaseType())
  }

  /**
   * Gets the default character type expected for `%s` by this function.  Typically
   * `char` or `wchar_t`.
   */
  Type getDefaultCharType() {
    isMicrosoft() and
    result = getFormatCharType()
    or
    not isMicrosoft() and
    result instanceof PlainCharType
  }

  /**
   * Gets the non-default character type expected for `%S` by this function.  Typically
   * `wchar_t` or `char`.  On some snapshots there may be multiple results where we can't tell
   * which is correct for a particular function.
   */
  Type getNonDefaultCharType() {
    getDefaultCharType().getSize() = 1 and
    result = getWideCharType()
    or
    not getDefaultCharType().getSize() = 1 and
    result instanceof PlainCharType
  }

  /**
   * Gets the wide character type for this function.  This is usually `wchar_t`.  On some
   * snapshots there may be multiple results where we can't tell which is correct for a
   * particular function.
   */
  pragma[nomagic]
  Type getWideCharType() {
    result = getFormatCharType() and
    result.getSize() > 1
    or
    not getFormatCharType().getSize() > 1 and
    result = getAFormatterWideTypeOrDefault() // may have more than one result
  }

  /**
   * Gets the position at which the output parameter, if any, occurs. If
   * `isStream` is `true`, the output parameter is a stream (that is, this
   * function behaves like `fprintf`). If `isStream` is `false`, the output
   * parameter is a buffer (that is, this function behaves like `sprintf`).
   */
  int getOutputParameterIndex(boolean isStream) { none() }

  /**
   * Holds if this function outputs to a global stream such as standard output,
   * standard error or a system log. For example `printf`.
   */
  predicate isOutputGlobal() { none() }

  /**
   * Gets the position of the first format argument, corresponding with
   * the first format specifier in the format string.
   */
  int getFirstFormatArgumentIndex() {
    result = getNumberOfParameters() and
    // the formatting function either has a definition in the snapshot, or all
    // `DeclarationEntry`s agree on the number of parameters (otherwise we don't
    // really know the correct number)
    (
      hasDefinition()
      or
      forall(FunctionDeclarationEntry fde | fde = getADeclarationEntry() |
        result = fde.getNumberOfParameters()
      )
    )
  }

  /**
   * Gets the position of the buffer size argument, if any.
   */
  int getSizeParameterIndex() { none() }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    bufParam = getFormatParameterIndex()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = getOutputParameterIndex(false) and
    countParam = getSizeParameterIndex()
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    bufParam = getOutputParameterIndex(false) and
    not exists(getSizeParameterIndex())
  }

  override predicate hasArrayInput(int bufParam) { bufParam = getFormatParameterIndex() }

  override predicate hasArrayOutput(int bufParam) { bufParam = getOutputParameterIndex(false) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(int arg |
      (
        arg = getFormatParameterIndex() or
        arg >= getFirstFormatArgumentIndex()
      ) and
      input.isParameterDeref(arg) and
      output.isParameterDeref(getOutputParameterIndex(_))
    )
  }
}

/**
 * The standard functions `snprintf` and `swprintf`, and their
 * Microsoft and glib variants.
 */
abstract class Snprintf extends FormattingFunction {
  /**
   * Holds if this function returns the length of the formatted string
   * that would have been output, regardless of the amount of space
   * in the buffer.
   */
  predicate returnsFullFormatLength() { none() }
}
