import ql
private import Builtins
private import codeql_ql.ast.internal.Module
private import codeql_ql.ast.internal.AstNodes

pragma[nomagic]
private predicate definesPredicate(
  FileOrModule m, string name, int arity, Predicate p, boolean public
) {
  (
    p instanceof NewTypeBranch or
    p instanceof ClasslessPredicate
  ) and
  (
    m = getEnclosingModule(p) and
    name = p.getName() and
    public = getPublicBool(p) and
    arity = p.getArity()
    or
    // import X
    exists(Import imp, FileOrModule m0 |
      m = getEnclosingModule(imp) and
      m0 = imp.getResolvedModule() and
      not exists(imp.importedAs()) and
      definesPredicate(m0, name, arity, p, true) and
      public = getPublicBool(imp)
    )
    or
    // predicate X = Y
    exists(ClasslessPredicate alias |
      m = getEnclosingModule(alias) and
      name = alias.getName() and
      resolvePredicateExpr(alias.getAlias(), p) and
      public = getPublicBool(alias) and
      arity = alias.getArity() and
      arity = p.getArity()
    )
  )
}

cached
private module Cached {
  cached
  predicate resolvePredicateExpr(PredicateExpr pe, Predicate p) {
    exists(FileOrModule m, boolean public |
      not exists(pe.getQualifier()) and
      m = getEnclosingModule(pe).getEnclosing*() and
      public = [false, true]
      or
      m = pe.getQualifier().getResolvedModule() and
      public = true
    |
      definesPredicate(m, pe.getName(), p.getArity(), p, public) and
      p.getArity() = pe.getArity()
    )
  }

  private predicate resolvePredicateCall(PredicateCall pc, PredicateOrBuiltin p) {
    // calls to class methods
    exists(Class c, ClassType t |
      c = pc.getParent*() and
      t = c.getType() and
      p = t.getClassPredicate(pc.getPredicateName(), pc.getNumberOfArguments()) and
      not exists(pc.getQualifier()) // no module qualifier, because then it's not a call to a class method.
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
      definesPredicate(m, pc.getPredicateName(), pc.getNumberOfArguments(), p, public)
    )
    or
    exists(Module mod, PredicateExpr sig, int i |
      mod.hasParameter(i, pc.getPredicateName(), sig) and
      sig.getArity() = pc.getNumberOfArguments()
    |
      // resolve to the signature predicate
      p = sig.getResolvedPredicate() // <- this is a `signature predicate`, but that's fine.
      or
      // resolve to the instantiations
      exists(ModuleExpr inst, SignatureExpr arg | inst.getResolvedModule().asModule() = mod |
        arg = inst.getArgument(i) and
        p = arg.asPredicate().getResolvedPredicate()
      )
    )
  }

  pragma[nomagic]
  private ClassPredicate getClassPredicate(Class c, string name, int arity) {
    result = c.getClassPredicate(name) and
    arity = result.getArity()
  }

  pragma[nomagic]
  private predicate resolveSelfClassCalls0(Class c, string name, int arity, MemberCall mc) {
    mc.getBase() instanceof ThisAccess and
    c = mc.getEnclosingPredicate().getParent() and
    name = mc.getMemberName() and
    arity = mc.getNumberOfArguments()
  }

  /**
   *  Holds if `mc` is a `this.method()` call to a predicate defined in the same class.
   * helps avoid spuriously resolving to predicates in super-classes.
   */
  private predicate resolveSelfClassCalls(MemberCall mc, PredicateOrBuiltin p) {
    exists(Class c, string name, int arity |
      resolveSelfClassCalls0(c, name, arity, mc) and
      p = getClassPredicate(c, name, arity)
    )
  }

  private predicate resolveMemberCall(MemberCall mc, PredicateOrBuiltin p) {
    resolveSelfClassCalls(mc, p)
    or
    not resolveSelfClassCalls(mc, _) and
    exists(Type t |
      t = mc.getBase().getType() and
      p = t.getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments())
    )
    or
    // super calls - and `this.method()` calls in charpreds. (Basically: in charpreds there is no difference between super and this.)
    exists(AstNode sup, Type supertype |
      sup instanceof Super
      or
      sup.(ThisAccess).getEnclosingPredicate() instanceof CharPred
    |
      mc.getBase() = sup and
      p = supertype.getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments()) and
      (
        // super.method()
        not exists(mc.getSuperType()) and
        exists(ClassType type |
          sup.getEnclosingPredicate().getParent().(Class).getType() = type and
          supertype in [type.getASuperType(), type.getAnInstanceofType()]
        )
        or
        // Class.super.method()
        supertype = mc.getSuperType().getResolvedType()
      )
    )
  }

  pragma[noinline]
  private predicate candidate(Relation rel, PredicateCall pc) {
    rel.getName() = pc.getPredicateName()
  }

  private predicate resolveDBRelation(PredicateCall pc, Predicate p) {
    exists(Relation rel | p = rel |
      candidate(rel, pc) and
      rel.getArity() = pc.getNumberOfArguments() and
      (
        exists(YAML::QLPack libPack, YAML::QLPack qlPack |
          rel.getLocation().getFile() = libPack.getDBScheme() and
          qlPack.getADependency*() = libPack and
          qlPack.getAFileInPack() = pc.getLocation().getFile()
        )
        or
        // upgrade scripts don't have a qlpack
        rel.getLocation().getFile().getParentContainer() =
          pc.getLocation().getFile().getParentContainer()
      )
    )
  }

  private predicate resolveBuiltinPredicateCall(PredicateCall call, BuiltinClassless pred) {
    call.getNumberOfArguments() = pred.getArity() and
    call.getPredicateName() = pred.getName()
  }

  cached
  predicate resolveCall(Call c, PredicateOrBuiltin p) {
    resolvePredicateCall(c, p)
    or
    not resolvePredicateCall(c, _) and
    resolveBuiltinPredicateCall(c, p)
    or
    resolveMemberCall(c, p)
    or
    not resolvePredicateCall(c, _) and
    resolveDBRelation(c, p)
    or
    // getAQlClass() is special
    c.(MemberCall).getMemberName() = "getAQlClass" and
    p.(BuiltinMember).getName() = "getAQlClass"
  }
}

import Cached

module PredConsistency {
  query predicate noResolvePredicateExpr(PredicateExpr pe) {
    not resolvePredicateExpr(pe, _) and
    not pe.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  query predicate noResolveCall(Call c) {
    not resolveCall(c, _) and
    not c instanceof NoneCall and
    not c instanceof AnyCall and
    not c.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  query predicate multipleResolvePredicateExpr(PredicateExpr pe, int c, ClasslessPredicate p) {
    c =
      strictcount(ClasslessPredicate p0 |
        resolvePredicateExpr(pe, p0) and
        // aliases are expected to resolve to multiple.
        not exists(p0.getAlias())
      ) and
    c > 1 and
    resolvePredicateExpr(pe, p) and
    // parameterized modules are expected to resolve to multiple.
    not exists(Predicate sig | sig.getParent*().hasAnnotation("signature") |
      resolvePredicateExpr(pe, sig)
    )
  }

  query predicate multipleResolveCall(Call call, int c, PredicateOrBuiltin p) {
    c =
      strictcount(PredicateOrBuiltin p0 |
        resolveCall(call, p0) and
        // aliases are expected to resolve to multiple.
        not exists(p0.(ClasslessPredicate).getAlias()) and
        // overridden predicates may have multiple targets
        not p0.(ClassPredicate).isOverride() and
        not p0 instanceof Relation // <- DB relations resolve to both a relation and a predicate.
      ) and
    c > 1 and
    resolveCall(call, p) and
    // parameterized modules are expected to resolve to multiple.
    not exists(Predicate sig | sig.getParent*().hasAnnotation("signature") | resolveCall(call, sig))
  }
}
