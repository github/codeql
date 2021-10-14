/**
 * @name Non-portable call to printf
 * @description When using a format specifier like %d ("int"), on a 32-bit architecture it's acceptable to pass a long since it's of the same size;
 *    when migrating to a 64-bit architecture this becomes problematic. Similar problems exist when printing pointers using 32-bit-wide format specifiers.
 * @kind problem
 * @id cpp/non-portable-printf
 * @problem.severity warning
 * @tags maintainability
 *       portability
 */

import cpp
import semmle.code.cpp.padding.Padding

/**
 * Used to avoid reporting conflicts between a char
 * pointer type with specified signedness and an unspecified
 * char pointer (whose signedness is compiler-dependent).
 */
class SignedOrUnsignedCharPointerType extends CharPointerType {
  SignedOrUnsignedCharPointerType() {
    this.getBaseType().(CharType).isUnsigned() or
    this.getBaseType().(CharType).isSigned()
  }
}

pragma[noopt]
private predicate formattingFunctionCallExpectedType(
  FormattingFunctionCall ffc, int pos, Type expected
) {
  exists(FormattingFunction f, int i, FormatLiteral fl |
    ffc.getTarget() = f and
    ffc instanceof FormattingFunctionCall and
    f.getFormatParameterIndex() = i and
    ffc.getArgument(i) = fl and
    fl.getConversionType(pos) = expected
  )
}

pragma[noopt]
predicate formatArgType(FormattingFunctionCall ffc, int pos, Type expected, Expr arg, Type actual) {
  formattingFunctionCallExpectedType(ffc, pos, expected) and
  ffc.getConversionArgument(pos) = arg and
  exists(Type t | t = arg.getActualType() and t.getUnspecifiedType() = actual)
}

pragma[noopt]
predicate formatOtherArgType(
  FormattingFunctionCall ffc, int pos, Type expected, Expr arg, Type actual
) {
  (arg = ffc.getMinFieldWidthArgument(pos) or arg = ffc.getPrecisionArgument(pos)) and
  actual = arg.getActualType() and
  exists(IntType it | it instanceof IntType and it.isImplicitlySigned() and expected = it)
}

predicate trivialConversion(Type expected, Type actual) {
  formatArgType(_, _, expected, _, actual) and
  (
    expected instanceof VoidPointerType and actual instanceof PointerType
    or
    expected instanceof IntegralType and actual instanceof Enum
    or
    expected instanceof CharPointerType and actual instanceof SignedOrUnsignedCharPointerType
    or
    expected instanceof SignedOrUnsignedCharPointerType and actual instanceof CharPointerType
    or
    expected instanceof CharType and actual instanceof IntType
    or
    expected instanceof UnsignedCharType and actual instanceof IntType
    or
    expected.(IntegralType).getUnsigned() = actual.(IntegralType).getUnsigned()
    or
    expected = actual
  )
}

from
  FormattingFunctionCall ffc, int n, Expr arg, Type expected, Type actual, ILP32 ilp32, LP64 lp64,
  int size32, int size64
where
  (
    formatArgType(ffc, n, expected, arg, actual) and
    not trivialConversion(expected, actual)
    or
    formatOtherArgType(ffc, n, expected, arg, actual) and
    not actual instanceof IntType
  ) and
  not arg.isAffectedByMacro() and
  size32 = ilp32.paddedSize(actual) and
  size64 = lp64.paddedSize(actual) and
  size64 != size32 and
  not actual instanceof ErroneousType
select arg,
  "This argument should be of type '" + expected.getName() + "' but is of type '" + actual.getName()
    + "' (which changes size from " + size32 + " to " + size64 + " on 64-bit systems)."
