import ql
private import codeql_ql.ast.internal.Module

private predicate definesPredicate(FileOrModule m, string name, ClasslessPredicate p, boolean public) {
  m = getEnclosingModule(p) and
  name = p.getName() and
  public = getPublicBool(p)
  or
  // import X
  exists(Import imp, FileOrModule m0 |
    m = getEnclosingModule(imp) and
    m0 = imp.getResolvedModule() and
    not exists(imp.importedAs()) and
    definesPredicate(m0, name, p, true) and
    public = getPublicBool(imp)
  )
  or
  // predicate X = Y
  exists(ClasslessPredicate alias |
    m = getEnclosingModule(alias) and
    name = alias.getName() and
    resolvePredicateExpr(alias.getAlias(), p) and
    public = getPublicBool(alias)
  )
}

predicate resolvePredicateExpr(PredicateExpr pe, ClasslessPredicate p) {
  exists(FileOrModule m, boolean public |
    not exists(pe.getQualifier()) and
    m = getEnclosingModule(pe).getEnclosing*() and
    public = [false, true]
    or
    m = pe.getQualifier().getResolvedModule() and
    public = true
  |
    definesPredicate(m, pe.getName(), p, public) and
    count(p.getParameter(_)) = pe.getArity()
  )
}

private predicate resolvePredicateCall(PredicateCall pc, Predicate p) {
  exists(Class c, ClassType t |
    c = pc.getParent*() and
    t = c.getType() and
    p = t.getClassPredicate(pc.getPredicateName(), pc.getNumberOfArguments())
  )
  or
  exists(FileOrModule m, boolean public |
    not exists(pc.getQualifier()) and
    m = getEnclosingModule(pc).getEnclosing*() and
    public = [false, true]
    or
    m = pc.getQualifier().getResolvedModule() and
    public = true
  |
    definesPredicate(m, pc.getPredicateName(), p, public) and
    count(p.getParameter(_)) = pc.getNumberOfArguments()
  )
}

private predicate resolveMemberCall(MemberCall mc, Predicate p) {
  exists(ClassType t |
    t = mc.getBase().getType() and
    p = t.getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments())
  )
}

predicate resolveCall(Call c, Predicate p) {
  resolvePredicateCall(c, p)
  or
  resolveMemberCall(c, p)
}

module PredConsistency {
  query predicate noResolvePredicateExpr(PredicateExpr pe) {
    not resolvePredicateExpr(pe, _) and
    not pe.getLocation().getFile().getAbsolutePath().regexpMatch(".*/(test|examples)/.*")
  }

  query predicate noResolveCall(Call c) {
    not resolveCall(c, _) and
    not c.getLocation().getFile().getAbsolutePath().regexpMatch(".*/(test|examples)/.*")
  }

  query predicate multipleResolvePredicateExpr(PredicateExpr pe, int c, ClasslessPredicate p) {
    c = strictcount(ClasslessPredicate p0 | resolvePredicateExpr(pe, p0)) and
    c > 1 and
    resolvePredicateExpr(pe, p)
  }

  query predicate multipleResolveCall(Call call, int c, Predicate p) {
    c = strictcount(Predicate p0 | resolveCall(call, p0)) and
    c > 1 and
    resolveCall(call, p)
  }
}
