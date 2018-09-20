/**
 * @name Cast between semantically different integer types: HRESULT to/from a Boolean type
 * @description Cast between semantically different integer types: HRESULT to/from a Boolean type.
 *              Boolean types indicate success by a non-zero value, whereas success (S_OK) in HRESULT is indicated by a value of 0. 
 *              Casting an HRESULT to/from a Boolean type and then using it in a test expression will yield an incorrect result.
 * @kind problem
 * @id cpp/incorrect-type-conversion
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-704
 *       external/microsoft/C6214
 *       external/microsoft/C6215
 *       external/microsoft/C6216
 *       external/microsoft/C6217
 *       external/microsoft/C6230
 */
import cpp

from Expr e1, Cast e2, string msg
where e2 = e1.getConversion() and
  exists ( Type t1, Type t2 |
    t1 = e1.getType() and
    t2 = e2.getType() and 
    ((t1.hasName("bool") or t1.hasName("BOOL")) and t2.hasName("HRESULT") or 
     (t2.hasName("bool") or t2.hasName("BOOL")) and t1.hasName("HRESULT") 
  ))
  and if e2.isImplicit() then ( msg = "Implicit" ) 
      else ( msg = "Explicit" )
select e1, msg + " conversion from " + e1.getType().toString() + " to " +  e2.getType().toString() 