/**
 * @name Cast between semantically different string types: char* from/to wchar_t*
 * @description This rule indicates a potentially incorrect cast from/to an ANSI string (char *) to/from a Unicode string (wchar_t *). 
 *              This cast might yield strings that are not correctly terminated; 
 *              including potential buffer overruns when using such strings with some dangerous APIs.
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
  WideCharPointerType() { 
    this.getBaseType() instanceof WideCharType 
  }
}

from Expr e1, Cast e2
where 
  e2 = e1.getConversion() 
  and
  (
    exists( WideCharPointerType w, CharPointerType c  | 
      w = e1.getType().getUnspecifiedType().(PointerType)
      and c = e2.getType().getUnspecifiedType().(PointerType)
    )
    or exists
    ( 
      WideCharPointerType w, CharPointerType c | 
      w = e2.getType().getUnspecifiedType().(PointerType)
      and c = e1.getType().getUnspecifiedType().(PointerType)
    )
  )
select e1, "Conversion from " + e1.getType().toString() + " to " +  e2.getType().toString() + ". Use of invalid string can lead to undefined behavior."