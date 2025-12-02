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

int countMacros(Expr e) { result = count(MacroInvocation mi | mi.getExpr() = e | mi) }

predicate isSizeOfExprOperandMacroInvocationAConstInteger(
  CandidateSizeofCall sizeofExpr, MacroInvocation mi, Literal l
) {
  isTypeDangerousForSizeof(sizeofExpr.getExprOperand()) and
  l = mi.getExpr() and
  l = sizeofExpr.getExprOperand() and
  mi.getExpr() = l and
  // Special case for FPs that involve an inner macro that resolves to 0 such as _T('\0')
  // i.e., if a macro resolves to 0, the same 0 expression cannot be the macro
  // resolution of another macro invocation (a nested invocation).
  // Count the number of invocations resolving to the same literal, if >1, ignore.
  not exists(int macroCount | macroCount = countMacros(l) |
    macroCount > 1 and l.getValue().toInt() = 0
  ) and
  // Special case for wide-char literals when the compiler doesn't recognize wchar_t (i.e. L'\\', L'\0')
  // Accounting for parenthesis "()" around the value
  not exists(Macro m | m = mi.getMacro() |
    m.getBody().toString().regexpMatch("^[\\s(]*L'.+'[\\s)]*$")
  ) and
  // Special case for token pasting operator
  not exists(Macro m | m = mi.getMacro() | m.getBody().toString().regexpMatch("^.*\\s*##\\s*.*$")) and
  // Special case for multichar literal integers that are exactly 4 character long (i.e. 'val1')
  not exists(Macro m | m = mi.getMacro() | m.getBody().toString().regexpMatch("^'.{4}'$"))
}

from CandidateSizeofCall sizeofExpr, MacroInvocation mi, string inMacro
where
  isSizeOfExprOperandMacroInvocationAConstInteger(sizeofExpr, mi, _) and
  (if sizeofExpr.isInMacroExpansion() then inMacro = " (in a macro expansion) " else inMacro = " ")
select sizeofExpr,
  "$@: sizeof" + inMacro +
    "of integer macro $@ will always return the size of the underlying integer type.", sizeofExpr,
  sizeofExpr.getEnclosingFunction().getName(), mi.getMacro(), mi.getMacro().getName()
