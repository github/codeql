/**
 * @name Wrong type of arguments to formatting function
 * @description Calling a printf-like function with the wrong type of arguments causes unpredictable
 *              behavior.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cpp/wrong-type-format-argument
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-686
 */

import cpp

/**
 * Holds if the argument corresponding to the `pos` conversion specifier
 * of `ffc` is expected to have type `expected`.
 */
private predicate formattingFunctionCallExpectedType(
  FormattingFunctionCall ffc, int pos, Type expected
) {
  ffc.getFormat().(FormatLiteral).getConversionType(pos) = expected
}

/**
 * Holds if the argument corresponding to the `pos` conversion specifier
 * of `ffc` could alternatively have type `expected`, for example on a different
 * platform.
 */
private predicate formattingFunctionCallAlternateType(
  FormattingFunctionCall ffc, int pos, Type expected
) {
  ffc.getFormat().(FormatLiteral).getConversionTypeAlternate(pos) = expected
}

/**
 * Holds if the argument corresponding to the `pos` conversion specifier
 * of `ffc` is `arg` and has type `actual`.
 */
pragma[noopt]
predicate formattingFunctionCallActualType(
  FormattingFunctionCall ffc, int pos, Expr arg, Type actual
) {
  exists(Expr argConverted |
    ffc.getConversionArgument(pos) = arg and
    argConverted = arg.getFullyConverted() and
    actual = argConverted.getType()
  )
}

/**
 * Holds if the argument corresponding to the `pos` conversion specifier
 * of `ffc` is expected to have a width or precision argument of type
 * `expected` and the corresponding argument `arg` has type `actual`.
 */
pragma[noopt]
predicate formatOtherArgType(
  FormattingFunctionCall ffc, int pos, Type expected, Expr arg, Type actual
) {
  exists(Expr argConverted |
    (arg = ffc.getMinFieldWidthArgument(pos) or arg = ffc.getPrecisionArgument(pos)) and
    argConverted = arg.getFullyConverted() and
    actual = argConverted.getType() and
    exists(IntType it | it instanceof IntType and it.isImplicitlySigned() and expected = it)
  )
}

/**
 * A type that may be expected by a printf format parameter, or that may
 * be pointed to by such a type (e.g. `wchar_t`, from `wchar_t *`).
 */
class ExpectedType extends Type {
  ExpectedType() {
    exists(Type t |
      (
        formattingFunctionCallExpectedType(_, _, t) or
        formattingFunctionCallAlternateType(_, _, t) or
        formatOtherArgType(_, _, t, _, _)
      ) and
      this = t.getUnspecifiedType()
    )
  }
}

/**
 * Holds if it is safe to display a value of type `actual` when `printf`
 * expects a value of type `expected`.
 *
 * Note that variadic arguments undergo default argument promotions before
 * they reach `printf`, notably `bool`, `char`, `short` and `enum` types
 * are promoted to `int` (or `unsigned int`, as appropriate) and `float`s
 * are converted to `double`.
 */
predicate trivialConversion(ExpectedType expected, Type actual) {
  exists(Type exp, Type act |
    (
      formattingFunctionCallExpectedType(_, _, exp) or
      formattingFunctionCallAlternateType(_, _, exp)
    ) and
    formattingFunctionCallActualType(_, _, _, act) and
    expected = exp.getUnspecifiedType() and
    actual = act.getUnspecifiedType()
  ) and
  (
    // allow a pointer type to be displayed with `%p`
    expected instanceof VoidPointerType and actual instanceof PointerType
    or
    // allow a function pointer type to be displayed with `%p`
    expected instanceof VoidPointerType and
    actual instanceof FunctionPointerType and
    expected.getSize() = actual.getSize()
    or
    // allow an `enum` type to be displayed with `%i`, `%c` etc
    expected instanceof IntegralType and actual instanceof Enum
    or
    // allow any `char *` type to be displayed with `%s`
    expected instanceof CharPointerType and actual instanceof CharPointerType
    or
    // allow `wchar_t *`, or any pointer to an integral type of the same size, to be displayed
    // with `%ws`
    expected.(PointerType).getBaseType().hasName("wchar_t") and
    exists(Wchar_t t |
      actual.getUnspecifiedType().(PointerType).getBaseType().(IntegralType).getSize() = t.getSize()
    )
    or
    // allow an `int` (or anything promoted to `int`) to be displayed with `%c`
    expected instanceof CharType and actual instanceof IntType
    or
    // allow an `int` (or anything promoted to `int`) to be displayed with `%wc`
    expected instanceof Wchar_t and actual instanceof IntType
    or
    expected instanceof UnsignedCharType and actual instanceof IntType
    or
    // allow any integral type of the same size
    // (this permits signedness changes)
    expected.(IntegralType).getSize() = actual.(IntegralType).getSize()
    or
    // allow a pointer to any integral type of the same size
    // (this permits signedness changes)
    expected.(PointerType).getBaseType().(IntegralType).getSize() =
      actual.(PointerType).getBaseType().(IntegralType).getSize()
    or
    expected = actual
  )
}

/**
 * Gets the size of the `int` type.
 */
int sizeof_IntType() { exists(IntType it | result = it.getSize()) }

from FormattingFunctionCall ffc, int n, Expr arg, Type expected, Type actual
where
  (
    formattingFunctionCallExpectedType(ffc, n, expected) and
    formattingFunctionCallActualType(ffc, n, arg, actual) and
    not exists(Type anyExpected |
      (
        formattingFunctionCallExpectedType(ffc, n, anyExpected) or
        formattingFunctionCallAlternateType(ffc, n, anyExpected)
      ) and
      trivialConversion(anyExpected.getUnspecifiedType(), actual.getUnspecifiedType())
    )
    or
    formatOtherArgType(ffc, n, expected, arg, actual) and
    not actual.getUnspecifiedType().(IntegralType).getSize() = sizeof_IntType()
  ) and
  not arg.isAffectedByMacro() and
  not arg.isFromUninstantiatedTemplate(_) and
  not actual.stripType() instanceof ErroneousType and
  not arg.(Call).mayBeFromImplicitlyDeclaredFunction()
select arg,
  "This format specifier for type '" + expected.getName() + "' does not match the argument type '" +
    actual.getUnspecifiedType().getName() + "'."
