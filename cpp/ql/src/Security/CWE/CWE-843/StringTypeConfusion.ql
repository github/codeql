/**
 * @name Cast between semantically different string types: char* to wchar_t*
 * @description This rule indicates a potentially incorrect cast from/to an ANSI string (char_t*) to/from a Unicode string (wchar_t *). 
 *              This cast might yield strings that are not correctly terminated; 
 *              including potential buffer overruns when using such strings with some dangerous APIs.
 * @kind problem
 * @id cpp/incorrect-string-type-conversion
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-843
 *       external/microsoft/C6276
 */
import cpp

from Expr e1, Cast e2, string msg
where e2 = e1.getConversion() and
  exists ( Type t1, Type t2 |
    t1 = e1.getType().resolveTypedefs() and
    t2 = e2.getType().resolveTypedefs() and 
    ( t1.getName().toString().regexpMatch("(const )*(_)*wchar_t \\*") 
        and t2.getName().toString().regexpMatch("(const )*char \\*") 
    or t2.getName().toString().regexpMatch("(const )*(_)*wchar_t \\*") 
        and t1.getName().toString().regexpMatch("(const )*char \\*") 
    )
  )
  and if e2.isImplicit() then ( msg = "Implicit" ) 
      else ( msg = "Explicit" )
select e1, msg + " conversion from " + e1.getType().toString() + " to " +  e2.getType().toString() + ". Use of invalid string can lead to undefined behavior."