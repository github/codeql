/**
 * @name Cast from char* to wchar_t*
 * @description Casting a byte string to a wide-character string is likely
 *              to yield a string that is incorrectly terminated or aligned.
 *              This can lead to undefined behavior, including buffer overruns.
 * @kind problem
 * @id cpp/incorrect-string-type-conversion
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-704
 *       external/microsoft/c/c6276
 */

import cpp

class WideCharPointerType extends PointerType {
  WideCharPointerType() { this.getBaseType() instanceof WideCharType }
}

from Expr e1, Cast e2
where
  e2 = e1.getConversion() and
  exists(WideCharPointerType w, CharPointerType c |
    w = e2.getUnspecifiedType().(PointerType) and
    c = e1.getUnspecifiedType().(PointerType)
  )
select e1,
  "Conversion from " + e1.getType().toString() + " to " + e2.getType().toString() +
    ". Use of invalid string can lead to undefined behavior."
