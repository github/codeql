import cpp
import semmle.code.cpp.pointsto.PointsTo

// a TargetPointsToExpr has points-to information for expressions
// that will help build an accurate call-graph (i.e. expressions
// in function-pointer calls and qualifiers of virtual calls)
class TargetPointsToExpr extends PointsToExpr {
  override predicate interesting() {
    exists(ExprCall ec | ec.getExpr() = this)
    or
    exists(Call c | c.getQualifier() = this)
    or
    exists(DeleteExpr d | d.getExpr() = this)
  }

  // resolve a virtual-call where this is the qualifier
  VirtualFunction resolve() { pointstosets(this.resolveToSet(), unresolveElement(result)) }

  int resolveToSet() {
    exists(int cset, VirtualFunction static |
      this.interesting() and
      parentSetFor(cset, underlyingElement(this)) and
      static = this.staticTarget() and
      childrenByElement(cset, static, result)
    )
  }

  VirtualFunction staticTarget() {
    exists(Function f, DeleteExpr d |
      f.calls(result, d) and
      d.getExpr() = this
    )
    or
    exists(Function f, FunctionCall c |
      f.calls(result, c) and
      c.getQualifier() = this
    )
  }
}

predicate resolvedCall(Call call, Function called) {
  call.(FunctionCall).getTarget() = called
  or
  call.(DestructorCall).getTarget() = called
  or
  exists(ExprCall ec, TargetPointsToExpr pte |
    ec = call and ec.getExpr() = pte and pte.pointsTo() = called
  )
  or
  exists(TargetPointsToExpr pte |
    call.getQualifier() = pte and
    pte.resolve() = called
  )
}

predicate ptrCalls(Function f, Function g) {
  exists(ExprCall ec |
    ec.getEnclosingFunction() = f and
    ec.getExpr().(TargetPointsToExpr).pointsTo() = g
  )
}

predicate virtualCalls(Function f, VirtualFunction g) {
  exists(DeleteExpr d, TargetPointsToExpr ptexpr, VirtualFunction static |
    f.calls(static, d) and
    d.getExpr() = ptexpr and
    ptexpr.resolve() = g
  )
  or
  exists(Call c, TargetPointsToExpr ptexpr, VirtualFunction static |
    f.calls(static, c) and
    c.getQualifier() = ptexpr and
    ptexpr.resolve() = g
  )
}

predicate allCalls(Function f, Function g) { f.calls(g) or ptrCalls(f, g) or virtualCalls(f, g) }
