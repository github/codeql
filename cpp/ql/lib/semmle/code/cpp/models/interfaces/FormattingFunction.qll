/**
 * Provides a class for modeling `printf`-style formatting functions. To use
 * this QL library, create a QL class extending `FormattingFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `FormattingFunction` to match the flow within that function.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint

pragma[nomagic]
private Type stripTopLevelSpecifiersOnly(Type t) {
  result = stripTopLevelSpecifiersOnly(pragma[only_bind_out](t.(SpecifiedType).getBaseType()))
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
  int firstFormatArgumentIndex;

  FormattingFunction() {
    firstFormatArgumentIndex > 0 and
    if this.hasDefinition()
    then firstFormatArgumentIndex = this.getDefinition().getNumberOfParameters()
    else
      if this instanceof BuiltInFunction
      then firstFormatArgumentIndex = this.getNumberOfParameters()
      else
        forex(FunctionDeclarationEntry fde | fde = this.getAnExplicitDeclarationEntry() |
          firstFormatArgumentIndex = fde.getNumberOfParameters()
        )
  }

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
      stripTopLevelSpecifiersOnly(stripTopLevelSpecifiersOnly(this.getParameter(this.getFormatParameterIndex())
              .getType()
              .getUnderlyingType()).(PointerType).getBaseType())
  }

  /**
   * Gets the default character type expected for `%s` by this function.  Typically
   * `char` or `wchar_t`.
   */
  Type getDefaultCharType() {
    this.isMicrosoft() and
    result = this.getFormatCharType()
    or
    not this.isMicrosoft() and
    result instanceof PlainCharType
  }

  /**
   * Gets the non-default character type expected for `%S` by this function.  Typically
   * `wchar_t` or `char`.  On some snapshots there may be multiple results where we can't tell
   * which is correct for a particular function.
   */
  Type getNonDefaultCharType() {
    this.getDefaultCharType().getSize() = 1 and
    result = this.getWideCharType()
    or
    not this.getDefaultCharType().getSize() = 1 and
    result instanceof PlainCharType
  }

  /**
   * Gets the wide character type for this function.  This is usually `wchar_t`.  On some
   * snapshots there may be multiple results where we can't tell which is correct for a
   * particular function.
   */
  pragma[nomagic]
  Type getWideCharType() {
    result = this.getFormatCharType() and
    result.getSize() > 1
    or
    not this.getFormatCharType().getSize() > 1 and
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
   * the first format specifier in the format string. We ignore all
   * implicit function definitions.
   */
  int getFirstFormatArgumentIndex() { result = firstFormatArgumentIndex }

  /**
   * Gets the position of the buffer size argument, if any.
   */
  int getSizeParameterIndex() { none() }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    bufParam = this.getFormatParameterIndex()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = this.getOutputParameterIndex(false) and
    countParam = this.getSizeParameterIndex()
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    bufParam = this.getOutputParameterIndex(false) and
    not exists(this.getSizeParameterIndex())
  }

  override predicate hasArrayInput(int bufParam) { bufParam = this.getFormatParameterIndex() }

  override predicate hasArrayOutput(int bufParam) { bufParam = this.getOutputParameterIndex(false) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(int arg |
      arg = this.getFormatParameterIndex() or
      arg >= this.getFirstFormatArgumentIndex()
    |
      (input.isParameterDeref(arg) or input.isParameter(arg)) and
      output.isParameterDeref(this.getOutputParameterIndex(_))
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
