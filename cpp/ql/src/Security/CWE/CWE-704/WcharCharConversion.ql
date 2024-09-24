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

class WideCharPointerType extends PointerType {
  WideCharPointerType() { this.getBaseType() instanceof WideCharType }
}

/**
 * Recurse through types to find any intermediate type or final type
 * that suggests the type is unlikely to be a string.
 * Specifically looking for any unsigned character, or datatype with name containing "byte"
 * or datatype uint8_t.
 */
predicate recursiveIsUnlikelyString(Type t) {
  t.(CharType).isUnsigned()
  or
  t.getName().toLowerCase().matches("%byte%")
  or
  t.getName().toLowerCase().matches("uint8_t")
  or
  recursiveIsUnlikelyString(t.(DerivedType).getBaseType())
  or
  recursiveIsUnlikelyString(t.(TypedefType).getBaseType())
}

/**
 * A type that may also be `CharPointerType`, but that are likely used as arbitrary buffers.
 */
class UnlikelyToBeAStringType extends Type {
  UnlikelyToBeAStringType() { recursiveIsUnlikelyString(this) }
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
  not exists(NewOrNewArrayExpr newExpr | newExpr.getAChild*() = e1)
select e1,
  "Conversion from " + e1.getType().toString() + " to " + e2.getType().toString() +
    ". Use of invalid string can lead to undefined behavior."
