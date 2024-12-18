/**
 * @name Cast from char* to wchar_t*
 * @description Casting a byte string to a wide-character string is likely
 *              to yield a string that is incorrectly terminated or aligned.
 *              This can lead to undefined behavior, including buffer overruns.
 * @kind problem
 * @id cpp/incorrect-string-type-conversion
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @tags security
 *       external/cwe/cwe-704
 */

import cpp
import semmle.code.cpp.controlflow.Guards

class WideCharPointerType extends PointerType {
  WideCharPointerType() { this.getBaseType() instanceof WideCharType }
}

/**
 * Given type `t`, recurses through and returns all
 * intermediate base types, including `t`.
 */
Type getABaseType(Type t) {
  result = t
  or
  result = getABaseType(t.(DerivedType).getBaseType())
  or
  result = getABaseType(t.(TypedefType).getBaseType())
}

/**
 * A type that may also be `CharPointerType`, but that are likely used as arbitrary buffers.
 */
class UnlikelyToBeAStringType extends Type {
  UnlikelyToBeAStringType() {
    exists(Type targ | getABaseType(this) = targ |
      // NOTE: not using CharType isUnsigned, but rather look for any explicitly declared unsigned
      // char types. Assuming these are used for buffers, not strings.
      targ.(CharType).getName().toLowerCase().matches("unsigned%") or
      targ.getName().toLowerCase().matches(["uint8_t", "%byte%"])
    )
  }
}

// Types that can be wide depending on the UNICODE macro
// see https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
class UnicodeMacroDependentWidthType extends Type {
  UnicodeMacroDependentWidthType() {
    exists(Type targ | getABaseType(this) = targ |
      targ.getName() in [
          "LPCTSTR",
          "LPTSTR",
          "PCTSTR",
          "PTSTR",
          "TBYTE",
          "TCHAR"
        ]
    )
  }
}

class UnicodeMacro extends Macro {
  UnicodeMacro() { this.getName().toLowerCase().matches("%unicode%") }
}

class UnicodeMacroInvocation extends MacroInvocation {
  UnicodeMacroInvocation() { this.getMacro() instanceof UnicodeMacro }
}

/**
 * Holds when a expression whose type is UnicodeMacroDependentWidthType and
 * is observed to be guarded by a check involving a bitwise-and operation
 * with a UnicodeMacroInvocation.
 * Such expressions are assumed to be checked dynamically, i.e.,
 * the flag would indicate if UNICODE typing is set correctly to allow
 * or disallow a widening cast.
 */
predicate isLikelyDynamicallyChecked(Expr e) {
  e.getType() instanceof UnicodeMacroDependentWidthType and
  exists(GuardCondition gc, BitwiseAndExpr bai, UnicodeMacroInvocation umi |
    bai.getAnOperand() = umi.getExpr()
  |
    // bai == 0 is false when reaching `e.getBasicBlock()`.
    // That is, bai != 0 when reaching `e.getBasicBlock()`.
    gc.ensuresEq(bai, 0, e.getBasicBlock(), false)
    or
    // bai == k and k != 0 is true when reaching `e.getBasicBlock()`.
    gc.ensuresEq(bai, any(int k | k != 0), e.getBasicBlock(), true)
  )
}

from Expr e1, Cast e2
where
  e2 = e1.getConversion() and
  exists(WideCharPointerType w, CharPointerType c |
    w = e2.getUnspecifiedType().(PointerType) and
    c = e1.getUnspecifiedType().(PointerType)
  ) and
  // Avoid `BYTE`-like casting as they are typically false positives
  // Example: `BYTE* buffer;` ... `(wchar_t*) buffer;`
  not e1.getType() instanceof UnlikelyToBeAStringType and
  // Avoid castings from 'new' expressions as typically these will be safe
  // Example: `__Type* ret = reinterpret_cast<__Type*>(New(m_pmo) char[num * sizeof(__Type)]);`
  not exists(NewOrNewArrayExpr newExpr | newExpr.getAChild*() = e1) and
  // Avoid cases where the cast is guarded by a check to determine if
  // unicode encoding is enabled in such a way to disallow the dangerous cast
  // at runtime.
  not isLikelyDynamicallyChecked(e1)
select e1,
  "Conversion from " + e1.getType().toString() + " to " + e2.getType().toString() +
    ". Use of invalid string can lead to undefined behavior."
