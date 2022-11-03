/**
 * @name Cast between HRESULT and a Boolean type
 * @description Casting an HRESULT to/from a Boolean type and then using it in a test expression will yield an incorrect result because success (S_OK) in HRESULT is indicated by a value of 0.
 * @kind problem
 * @id cpp/hresult-boolean-conversion
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-253
 *       external/microsoft/C6214
 *       external/microsoft/C6215
 *       external/microsoft/C6216
 *       external/microsoft/C6217
 *       external/microsoft/C6230
 */

import cpp

predicate isHresultBooleanConverted(Expr e1, Cast e2) {
  exists(Type t1, Type t2 |
    t1 = e1.getType() and
    t2 = e2.getType() and
    (
      (t1.hasName("bool") or t1.hasName("BOOL") or t1.hasName("_Bool")) and
      t2.hasName("HRESULT")
      or
      (t2.hasName("bool") or t2.hasName("BOOL") or t2.hasName("_Bool")) and
      t1.hasName("HRESULT")
    )
  )
}

predicate isHresultBooleanConverted(Expr e1) {
  exists(Cast e2 |
    e2 = e1.getConversion() and
    isHresultBooleanConverted(e1, e2)
  )
}

from Expr e1, string msg
where
  exists(Cast e2 | e2 = e1.getConversion() |
    isHresultBooleanConverted(e1, e2) and
    if e2.isImplicit()
    then
      msg = "Implicit conversion from " + e1.getType().toString() + " to " + e2.getType().toString()
    else
      msg = "Explicit conversion from " + e1.getType().toString() + " to " + e2.getType().toString()
  )
  or
  exists(ControlStructure ctls |
    ctls.getControllingExpr() = e1 and
    e1.getType().(TypedefType).hasName("HRESULT") and
    not isHresultBooleanConverted(e1) and
    not ctls instanceof SwitchStmt and // not controlled by a boolean condition
    msg = "Direct usage of a type " + e1.getType().toString() + " as a conditional expression"
  )
  or
  (
    exists(BinaryLogicalOperation blop | blop.getAnOperand() = e1 |
      e1.getType().(TypedefType).hasName("HRESULT") and
      msg =
        "Usage of a type " + e1.getType().toString() +
          " as an argument of a binary logical operation"
    )
    or
    exists(UnaryLogicalOperation ulop | ulop.getAnOperand() = e1 |
      e1.getType().(TypedefType).hasName("HRESULT") and
      msg =
        "Usage of a type " + e1.getType().toString() +
          " as an argument of a unary logical operation"
    ) and
    not isHresultBooleanConverted(e1)
  )
select e1, msg
