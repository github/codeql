/**
 * @name Potentially unsafe use of strcat
 * @description Using 'strcat' without checking the size of the source string
 *              may result in a buffer overflow
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/unsafe-strcat
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-676
 *       external/cwe/cwe-120
 *       external/cwe/cwe-251
 */
import cpp
import Buffer

/**
 * An access to a variable that is initialized by a constant
 * expression, and is never used as an lvalue anywhere else.
 */
predicate isEffectivelyConstAccess(VariableAccess a)
{
  exists(Variable v |
    a.getTarget() = v and
    v.getInitializer().getExpr().isConstant() and
    not v.getAnAccess().isUsedAsLValue()
  )
}

from FunctionCall fc, VariableAccess src
where fc.getTarget().hasName("strcat") and
      src = fc.getArgument(1) and
      not src.getType() instanceof ArrayType and
      not exists(BufferSizeExpr bse |
        bse.getArg().(VariableAccess).getTarget() = src.getTarget()) and
      not isEffectivelyConstAccess(src)
select fc, "Always check the size of the source buffer when using strcat."
