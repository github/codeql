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
 * Recurse through types to find any intermediate type or final type
 * that suggests the type is unlikely to be a string.
 * Specifically looking for any unsigned character, or datatype with name containing "byte"
 * or datatype uint8_t.
 */
predicate hasIntermediateType(Type cur, Type targ) {
  cur = targ
  or
  hasIntermediateType(cur.(DerivedType).getBaseType(), targ)
  or
  hasIntermediateType(cur.(TypedefType).getBaseType(), targ)
}

/**
 * A type that may also be `CharPointerType`, but that are likely used as arbitrary buffers.
 */
class UnlikelyToBeAStringType extends Type {
  UnlikelyToBeAStringType() {
    exists(Type targ |
      targ.(CharType).isUnsigned() or
      targ.getName().toLowerCase().matches(["uint8_t", "%byte%"])
    |
      hasIntermediateType(this, targ)
    )
  }
}

// Types that can be wide depending on the UNICODE macro
// see https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
class UnicodeMacroDependentWidthType extends Type {
  UnicodeMacroDependentWidthType() {
    exists(Type targ |
      targ.getName() in [
          "LPCTSTR",
          "LPTSTR",
          "PCTSTR",
          "PTSTR",
          "TBYTE",
          "TCHAR"
        ]
    |
      hasIntermediateType(this, targ)
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
predicate isLikelyDynamicChecked(Expr e, GuardCondition gc) {
  e.getType() instanceof UnicodeMacroDependentWidthType and
  exists(BitwiseAndExpr bai, UnicodeMacroInvocation umi | bai.getAnOperand() = umi.getExpr() |
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
  not isLikelyDynamicChecked(e1, _)
select e1,
  "Conversion from " + e1.getType().toString() + " to " + e2.getType().toString() +
    ". Use of invalid string can lead to undefined behavior."
