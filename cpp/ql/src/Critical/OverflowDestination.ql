/**
 * @name Copy function using source size
 * @description Calling a copy operation with a size derived from the source
 *              buffer instead of the destination buffer may result in a buffer overflow
 * @kind problem
 * @id cpp/overflow-destination
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */
import cpp
import semmle.code.cpp.pointsto.PointsTo

predicate sourceSized(FunctionCall fc)
{
  exists(string name |
    (name = "strncpy" or name = "strncat" or name = "memcpy" or name = "memmove") and
    fc.getTarget().hasQualifiedName(name))
  and
  exists(Expr dest, Expr src, Expr size, Variable v |
    fc.getArgument(0) = dest and fc.getArgument(1) = src and fc.getArgument(2) = size and
    src = v.getAnAccess() and size.getAChild+() = v.getAnAccess() and
    not exists(Variable other |
      dest = other.getAnAccess() and size.getAChild+() = other.getAnAccess())
    and
    not exists(ArrayType srctype, ArrayType desttype |
      dest.getType().getUnderlyingType() = desttype and
      src.getType().getUnderlyingType() = srctype and
      desttype.getBaseType().getUnderlyingType() = srctype.getBaseType().getUnderlyingType() and
      desttype.getArraySize() = srctype.getArraySize()))
}

class VulnerableArgument extends PointsToExpr
{
  VulnerableArgument() { sourceSized(this.getParent()) }
  override predicate interesting() { sourceSized(this.getParent()) }
}

predicate taintingFunction(Function f, int buf)
{
  (f.hasQualifiedName("read") and buf = 1) or
  (f.hasQualifiedName("fgets") and buf = 0) or
  (f.hasQualifiedName("fread") and buf = 0)
}

// Taint `argv[i]`, for all i, but also `*argv`, etc.
predicate commandLineArg(Expr e)
{
  exists(Function f, Parameter argv, VariableAccess access |
    f.hasQualifiedName("main") and f.getParameter(1) = argv and
    argv.getAnAccess() = access and access.isRValue() and
    pointer(access, e))
}

predicate tainted(Expr e)
{
  exists(FunctionCall fc, int arg |
    taintingFunction(fc.getTarget(), arg) and
    e = fc.getArgument(arg))
  or
  e.(FunctionCall).getTarget().hasQualifiedName("getenv")
  or
  commandLineArg(e)
}

class TaintedArgument extends PointsToExpr
{
  TaintedArgument() { tainted(this) }
  override predicate interesting() { tainted(this) }
}

from FunctionCall fc, VulnerableArgument vuln, TaintedArgument tainted
where sourceSized(fc)
  and fc.getArgument(1) = vuln
  and vuln.pointsTo() = tainted.pointsTo()
  and vuln.confidence() > 0.01
select fc, "To avoid overflow, this operation should be bounded by destination-buffer size, not source-buffer size."
