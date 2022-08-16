import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.semantic.Semantic
import semmle.code.cpp.ir.IR as IR

int semLowerBound(Expr expr) {
  exists(SemExpr e, SemZeroBound b |
    semBounded(e, b, result, false, _) and
    expr = e.(IR::Instruction).getAst()
  )
}

from VariableAccess expr, string sem, string simple, string bounds
where
  bounds = "sem = " + sem + " but simple = " + simple and
  (
    semLowerBound(expr) != lowerBound(expr) and
    sem = semLowerBound(expr).toString() and
    simple = lowerBound(expr).toString()
    or
    sem = semLowerBound(expr).toString() and
    not exists(lowerBound(expr)) and
    simple = "unbounded"
    or
    not exists(semLowerBound(expr)) and
    sem = "unbounded" and
    simple = lowerBound(expr).toString()
  )
select expr, bounds
