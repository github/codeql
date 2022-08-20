/**
 * @name Transitively closed recursive delta
 * @description Using a transitively closed relation as the step in a recursive
 *              delta can perform poorly as it is inherently quadratic and may
 *              force materialization of a fastTC. The transitively closed delta
 *              can usually just be replaced by the underlying step relation as
 *              the recursive context will provide transitive closure.
 * @kind problem
 * @problem.severity error
 * @id ql/transitive-step
 * @tags performance
 * @precision high
 */

import ql

Expr getArg(Call c, int i) {
  result = c.getArgument(i)
  or
  result = c.(MemberCall).getBase() and i = -1
  or
  exists(c.getType()) and result = c and i = -2
}

newtype TParameter =
  TThisParam(ClassPredicate p) or
  TResultParam(Predicate p) { exists(p.getReturnType()) } or
  TVarParam(VarDecl v) { any(Predicate p).getParameter(_) = v }

class Parameter extends TParameter {
  string toString() {
    this instanceof TThisParam and result = "this"
    or
    this instanceof TResultParam and result = "result"
    or
    exists(VarDecl v | this = TVarParam(v) and result = v.toString())
  }

  Expr getAnAccess() {
    result instanceof ThisAccess and this = TThisParam(result.getEnclosingPredicate())
    or
    result instanceof ResultAccess and this = TResultParam(result.getEnclosingPredicate())
    or
    this = TVarParam(result.(VarAccess).getDeclaration())
  }

  predicate isParameterOf(Predicate p, int i) {
    this = TThisParam(p) and i = -1
    or
    this = TResultParam(p) and i = -2
    or
    this = TVarParam(p.getParameter(i))
  }
}

predicate hasTwoArgs(Call c, Expr arg1, Expr arg2) {
  exists(int i1, int i2 |
    arg1 = getArg(c, i1) and
    arg2 = getArg(c, i2) and
    i1 != i2 and
    strictcount(getArg(c, _)) = 2
  )
}

predicate transitivePred(Predicate p, AstNode tc) {
  exists(PredicateExpr pe |
    p.(ClasslessPredicate).getAlias() = pe and
    transitivePred(pe.getResolvedPredicate(), tc)
  )
  or
  p.(ClasslessPredicate).getAlias().(HigherOrderFormula).getName() = "fastTC" and
  tc = p
  or
  strictcount(Parameter par | par.isParameterOf(p, _)) = 2 and
  exists(Formula body | p.getBody() = body |
    transitiveCall(body, tc) and
    hasTwoArgs(body, any(Identifier i1), any(Identifier i2))
    or
    exists(ComparisonFormula eq, Call c |
      body = eq and
      eq.getOperator() = "=" and
      transitiveCall(c, tc) and
      getArg(c, _) instanceof Identifier and
      eq.getAnOperand() = c and
      eq.getAnOperand() instanceof Identifier
    )
  )
}

predicate transitiveCall(Call c, AstNode tc) {
  c.isClosure(_) and tc = c
  or
  transitivePred(c.getTarget(), tc)
}

class TransitivelyClosedCall extends Call {
  TransitivelyClosedCall() { transitiveCall(this, _) }

  predicate hasArgs(Expr arg1, Expr arg2) { hasTwoArgs(this, arg1, arg2) }

  AstNode getReason() { transitiveCall(this, result) }
}

AstNode getParentOfExpr(Expr e) { result = e.getParent() }

Formula getEnclosing(Expr e) { result = getParentOfExpr+(e) }

Formula enlargeScopeStep(Formula f) { result.(Conjunction).getAnOperand() = f }

Formula enlargeScope(Formula f) {
  result = enlargeScopeStep*(f) and not exists(enlargeScopeStep(result))
}

predicate varaccesValue(VarAccess va, VarDecl v, Formula scope) {
  va.getDeclaration() = v and
  scope = enlargeScope(getEnclosing(va))
}

predicate thisValue(ThisAccess ta, Formula scope) { scope = enlargeScope(getEnclosing(ta)) }

predicate resultValue(ResultAccess ra, Formula scope) { scope = enlargeScope(getEnclosing(ra)) }

predicate valueStep(Expr e1, Expr e2) {
  exists(VarDecl v, Formula scope |
    varaccesValue(e1, v, scope) and
    varaccesValue(e2, v, scope)
  )
  or
  exists(Formula scope |
    thisValue(e1, scope) and
    thisValue(e2, scope)
    or
    resultValue(e1, scope) and
    resultValue(e2, scope)
  )
  or
  exists(InlineCast c |
    e1 = c and e2 = c.getBase()
    or
    e2 = c and e1 = c.getBase()
  )
  or
  exists(ComparisonFormula eq |
    eq.getOperator() = "=" and
    eq.getAnOperand() = e1 and
    eq.getAnOperand() = e2 and
    e1 != e2
  )
}

predicate transitiveDelta(Call rec, TransitivelyClosedCall tc) {
  exists(Expr recarg, int i, Expr tcarg, Predicate pred, Parameter p |
    rec.getTarget() = pred and
    pred = rec.getEnclosingPredicate() and
    recarg = getArg(rec, i) and
    valueStep*(recarg, tcarg) and
    tc.hasArgs(tcarg, p.getAnAccess()) and
    p.isParameterOf(pred, i)
  )
}

from Call rec, TransitivelyClosedCall tc, AstNode reason
where transitiveDelta(rec, tc) and reason = tc.getReason()
select tc, "This recursive delta is transively closed $@, which may be a performance problem.",
  reason, "here"
