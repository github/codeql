/**
 * @id cpp/microsoft/public/drivers/incorrect-usage-of-rtlcomparememory
 * @name Incorrect usage of RtlCompareMemory
 * @description `RtlCompareMemory` routine compares two blocks of memory and returns the number of bytes that match, not a boolean value indicating a full comparison like `RtlEqualMemory` does.
 *     This query detects the return value of `RtlCompareMemory` being handled as a boolean.
 * @security.severity Important
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 *       kernel
 */

import cpp

predicate isLiteralABooleanMacro(Literal l) {
  exists(MacroInvocation mi | mi.getExpr() = l |
    mi.getMacroName() in ["true", "false", "TRUE", "FALSE"]
  )
}

from FunctionCall fc, Function f, Expr e, string msg
where
  f.getQualifiedName() = "RtlCompareMemory" and
  f.getACallToThisFunction() = fc and
  (
    exists(UnaryLogicalOperation ulo | e = ulo |
      ulo.getAnOperand() = fc and
      msg = "as an operand in an unary logical operation"
    )
    or
    exists(BinaryLogicalOperation blo | e = blo |
      blo.getAnOperand() = fc and
      msg = "as an operand in a binary logical operation"
    )
    or
    exists(Conversion conv | e = conv |
      (
        conv.getType().hasName("bool") or
        conv.getType().hasName("BOOLEAN") or
        conv.getType().hasName("_Bool")
      ) and
      conv.getUnconverted() = fc and
      msg = "as a boolean"
    )
    or
    exists(IfStmt s | e = s.getControllingExpr() |
      s.getControllingExpr() = fc and
      msg = "as the controlling expression in an If statement"
    )
    or
    exists(EqualityOperation bao, Expr e2 | e = bao |
      bao.hasOperands(fc, e2) and
      isLiteralABooleanMacro(e2) and
      msg =
        "as an operand in an equality operation where the other operand is a boolean value (high precision result)"
    )
    or
    exists(EqualityOperation bao, Expr e2 | e = bao |
      bao.hasOperands(fc, e2) and
      (e2.(Literal).getValue().toInt() = 1 or e2.(Literal).getValue().toInt() = 0) and
      not isLiteralABooleanMacro(e2) and
      msg =
        "as an operand in an equality operation where the other operand is likely a boolean value (lower precision result, needs to be reviewed)"
    )
  )
select e,
  "This $@ is being handled $@ instead of the number of matching bytes. Please review the usage of this function and consider replacing it with `RtlEqualMemory`.",
  fc, "call to `RtlCompareMemory`", e, msg
