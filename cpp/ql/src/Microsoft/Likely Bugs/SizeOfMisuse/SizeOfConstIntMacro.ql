/**
 * @id cpp/microsoft/public/sizeof/const-int-argument
 * @name Passing a constant integer macro to sizeof
 * @description The expression passed to sizeof is a macro that expands to an integer constant. A data type was likely intended instead.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import SizeOfTypeUtils

predicate isExprAConstInteger(Expr e, MacroInvocation mi) {
  exists(Type type |
    type = e.getExplicitlyConverted().getType() and
    isTypeDangerousForSizeof(type) and
    // Special case for wide-char literals when the compiler doesn't recognize wchar_t (i.e. L'\\', L'\0')
    // Accounting for parenthesis "()" around the value
    not exists(Macro m | m = mi.getMacro() |
      m.getBody().toString().regexpMatch("^[\\s(]*L'.+'[\\s)]*$")
    ) and
    // Special case for token pasting operator
    not exists(Macro m | m = mi.getMacro() | m.getBody().toString().regexpMatch("^.*\\s*##\\s*.*$")) and
    // Special case for multichar literal integers that are exactly 4 character long (i.e. 'val1')
    not exists(Macro m | m = mi.getMacro() |
      e.getType().toString() = "int" and
      m.getBody().toString().regexpMatch("^'.{4}'$")
    ) and
    e.isConstant()
  )
}

int countMacros(Expr e) { result = count(MacroInvocation mi | mi.getExpr() = e | mi) }

predicate isSizeOfExprOperandMacroInvocationAConstInteger(
  SizeofExprOperator sizeofExpr, MacroInvocation mi
) {
  exists(Expr e |
    e = mi.getExpr() and
    e = sizeofExpr.getExprOperand() and
    isExprAConstInteger(e, mi) and
    // Special case for FPs that involve an inner macro that resolves to 0 such as _T('\0')
    not exists(int macroCount | macroCount = countMacros(e) |
      macroCount > 1 and e.(Literal).getValue().toInt() = 0
    )
  )
}

from SizeofExprOperator sizeofExpr, MacroInvocation mi
where isSizeOfExprOperandMacroInvocationAConstInteger(sizeofExpr, mi)
select sizeofExpr,
  "$@: sizeof of integer macro $@ will always return the size of the underlying integer type.",
  sizeofExpr, sizeofExpr.getEnclosingFunction().getName(), mi.getMacro(), mi.getMacro().getName()
