/**
 * @name Wrong type of arguments to formatting function
 * @description Calling a printf-like function with the wrong type of arguments causes unpredictable
 *              behavior.
 * @kind problem
 * @problem.severity error
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
pragma[noopt]
private predicate formattingFunctionCallExpectedType(FormattingFunctionCall ffc, int pos, Type expected) {
    exists(FormattingFunction f, int i, FormatLiteral fl |
      ffc instanceof FormattingFunctionCall and
      ffc.getTarget() = f and
      f.getFormatParameterIndex() = i and
      ffc.getArgument(i) = fl and
      fl.getConversionType(pos) = expected
    )
}

/**
 * Holds if the argument corresponding to the `pos` conversion specifier
 * of `ffc` is expected to have type `expected` and the corresponding
 * argument `arg` has type `actual`.
 */
pragma[noopt]
predicate formatArgType(FormattingFunctionCall ffc, int pos, Type expected, Expr arg, Type actual) {
  exists(Expr argConverted |
    formattingFunctionCallExpectedType(ffc, pos, expected) and
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
predicate formatOtherArgType(FormattingFunctionCall ffc, int pos, Type expected, Expr arg, Type actual) {
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
class ExpectedType extends Type
{
  ExpectedType() {
    formatArgType(_, _, this, _, _) or
    formatOtherArgType(_, _, this, _, _) or
    exists(ExpectedType t |
      this = t.(PointerType).getBaseType()
    )
  }
}

/**
 * Gets an 'interesting' type that can be reached from `t` by removing
 * typedefs and specifiers.  Note that this does not always mean removing
 * all typedefs and specifiers as `Type.getUnspecifiedType()` would, for
 * example if the interesting type is itself a typedef.
 */
ExpectedType getAnUnderlyingExpectedType(Type t) {
  (
    result = t
  ) or (
    result = getAnUnderlyingExpectedType(t.(TypedefType).getBaseType())
  ) or (
    result = getAnUnderlyingExpectedType(t.(SpecifiedType).getBaseType())
  )
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
  formatArgType(_, _, expected, _, actual) and

  exists(Type actualU |
    actualU = actual.getUnspecifiedType() and
    (
      (
        // allow a pointer type to be displayed with `%p`
        expected instanceof VoidPointerType and actualU instanceof PointerType
      ) or (
        // allow a function pointer type to be displayed with `%p`
        expected instanceof VoidPointerType and actualU instanceof FunctionPointerType and expected.getSize() = actual.getSize()
      ) or (
        // allow an `enum` type to be displayed with `%i`, `%c` etc
        expected instanceof IntegralType and actualU instanceof Enum
      ) or (
        // allow any `char *` type to be displayed with `%s`
        expected instanceof CharPointerType and actualU instanceof CharPointerType
      ) or (
        // allow `wchar_t *`, or any pointer to an integral type of the same size, to be displayed
        // with `%ws`
        expected.(PointerType).getBaseType().hasName("wchar_t") and
        exists(Wchar_t t |
          actual.getUnspecifiedType().(PointerType).getBaseType().(IntegralType).getSize() = t.getSize()
        )
      ) or (
        // allow an `int` (or anything promoted to `int`) to be displayed with `%c`
        expected instanceof CharType and actualU instanceof IntType
      ) or (
        // allow an `int` (or anything promoted to `int`) to be displayed with `%wc`
        expected instanceof Wchar_t and actualU instanceof IntType
      ) or (
        expected instanceof UnsignedCharType and actualU instanceof IntType
      ) or (
        // allow the underlying type of a `size_t` (e.g. `unsigned long`) for
        // `%zu`, since this is the type of a `sizeof` expression
        expected instanceof Size_t and
        actual.getUnspecifiedType() = expected.getUnspecifiedType()
      ) or (
        // allow the underlying type of a `ssize_t` (e.g. `long`) for `%zd`
        expected instanceof Ssize_t and
        actual.getUnspecifiedType() = expected.getUnspecifiedType()
      ) or (
        // allow any integral type of the same size 
        // (this permits signedness changes)
        expected.(IntegralType).getSize() = actualU.(IntegralType).getSize()
      ) or (
        // allow a pointer to any integral type of the same size
        // (this permits signedness changes)
        expected.(PointerType).getBaseType().(IntegralType).getSize() = actualU.(PointerType).getBaseType().(IntegralType).getSize()
      ) or (
        // allow expected, or a typedef or specified version of expected
        expected = getAnUnderlyingExpectedType(actual)
      )
    )
  )
}

/**
 * Gets the size of the `int` type.
 */
int sizeof_IntType() {
  exists(IntType it | result = it.getSize())
}

from FormattingFunctionCall ffc, int n, Expr arg, ExpectedType expected, Type actual
where (
        (
          formatArgType(ffc, n, expected, arg, actual) and
          not trivialConversion(expected, actual)
        )
        or
        (
          formatOtherArgType(ffc, n, expected, arg, actual) and
          not actual.getUnderlyingType().(IntegralType).getSize() = sizeof_IntType()
        )
      )
      and not arg.isAffectedByMacro()
select arg, "This argument should be of type '"+expected.getName()+"' but is of type '"+actual.getUnspecifiedType().getName() + "'"
