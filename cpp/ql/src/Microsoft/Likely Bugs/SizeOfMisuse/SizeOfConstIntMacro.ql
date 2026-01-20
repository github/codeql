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

/**
 * Holds if `type` is a `Type` that typically should not be used for `sizeof` in macros or function return values.
 */
predicate isTypeDangerousForSizeof(Expr e) {
  exists(Type type |
    (
      if e.getImplicitlyConverted().hasExplicitConversion()
      then type = e.getExplicitlyConverted().getType()
      else type = e.getUnspecifiedType()
    )
  |
    type instanceof IntegralOrEnumType and
    // ignore string literals
    not type instanceof WideCharType and
    not type instanceof CharType
  )
}

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
  // in these cases, the precompiler turns the string value into an integer, making it appear to be
  // a const macro of interest, but strings should be ignored.
  not exists(Macro m | m = mi.getMacro() | m.getBody().toString().regexpMatch("^'.{4}'$")) and
  // Special case macros that are known to be used in buffer streams
  // where it is common index into a buffer or allocate a buffer size based on a constant
  // this includes known protocol constants and magic numbers
  not (
    // ignoring any string looking like a magic number, part of the smb2 protocol or csc protocol
    mi.getMacroName().toLowerCase().matches(["%magic%", "%smb2%", "csc_%"]) and
    // but only ignore if the macro does not also appear to be a size or length macro
    not mi.getMacroName().toLowerCase().matches(["%size%", "%length%"])
  )
}

from CandidateSizeofCall sizeofExpr, MacroInvocation mi, string inMacro
where
  isSizeOfExprOperandMacroInvocationAConstInteger(sizeofExpr, mi, _) and
  (if sizeofExpr.isInMacroExpansion() then inMacro = " (in a macro expansion) " else inMacro = " ")
select sizeofExpr,
  "sizeof" + inMacro +
    "of integer macro $@ will always return the size of the underlying integer type.",
  mi.getMacro(), mi.getMacro().getName()
