import ql
private import Builtins
private import codeql_ql.ast.internal.Module
private import codeql_ql.ast.internal.AstNodes as AstNodes

private class TClasslessPredicateOrNewTypeBranch =
  AstNodes::TClasslessPredicate or AstNodes::TNewTypeBranch;

string getPredicateName(TClasslessPredicateOrNewTypeBranch p) {
  result = p.(ClasslessPredicate).getName() or
  result = p.(NewTypeBranch).getName()
}

private predicate definesPredicate(
  FileOrModule m, string name, int arity, TClasslessPredicateOrNewTypeBranch p, boolean public
) {
  m = getEnclosingModule(p) and
  name = getPredicateName(p) and
  public = getPublicBool(p) and
  arity = [p.(ClasslessPredicate).getArity(), count(p.(NewTypeBranch).getField(_))]
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
    arity = alias.getArity()
  )
}

cached
private module Cached {
  cached
  predicate resolvePredicateExpr(PredicateExpr pe, ClasslessPredicate p) {
    exists(FileOrModule m, boolean public |
      not exists(pe.getQualifier()) and
      m = getEnclosingModule(pe).getEnclosing*() and
      public = [false, true]
      or
      m = pe.getQualifier().getResolvedModule() and
      public = true
    |
      definesPredicate(m, pe.getName(), count(p.getParameter(_)), p, public)
    )
  }

  private predicate resolvePredicateCall(PredicateCall pc, PredicateOrBuiltin p) {
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
      definesPredicate(m, pc.getPredicateName(), pc.getNumberOfArguments(), p.getDeclaration(),
        public)
    )
  }

  private predicate resolveMemberCall(MemberCall mc, PredicateOrBuiltin p) {
    exists(Type t |
      t = mc.getBase().getType() and
      p = t.getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments())
    )
    or
    // super calls
    exists(Super sup, ClassType type |
      mc.getBase() = sup and
      sup.getEnclosingPredicate().(ClassPredicate).getParent().getType() = type and
      p = type.getASuperType().getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments())
    )
  }

  pragma[noinline]
  private predicate candidate(Relation rel, PredicateCall pc) {
    rel.getName() = pc.getPredicateName()
  }

  private predicate resolveDBRelation(PredicateCall pc, DefinedPredicate p) {
    exists(Relation rel | p = TPred(rel) |
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

  cached
  predicate resolveCall(Call c, PredicateOrBuiltin p) {
    resolvePredicateCall(c, p)
    or
    resolveMemberCall(c, p)
    or
    not resolvePredicateCall(c, _) and
    resolveDBRelation(c, p)
  }

  cached
  module NewTypeDef {
    cached
    newtype TPredOrBuiltin =
      TPred(Predicate p) or
      TNewTypeBranch(NewTypeBranch b) or
      TBuiltinClassless(string ret, string name, string args) {
        isBuiltinClassless(ret, name, args)
      } or
      TBuiltinMember(string qual, string ret, string name, string args) {
        isBuiltinMember(qual, ret, name, args)
      }
  }
}

import Cached
private import NewTypeDef

class PredicateOrBuiltin extends TPredOrBuiltin {
  string getName() { none() }

  string toString() { result = getName() }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    if exists(getDeclaration())
    then
      getDeclaration()
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    else (
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }

  AstNode getDeclaration() { none() }

  Type getDeclaringType() { none() }

  Type getParameterType(int i) { none() }

  Type getReturnType() { none() }

  int getArity() { result = count(getParameterType(_)) }

  predicate isPrivate() { none() }
}

private class DefinedPredicate extends PredicateOrBuiltin, TPred {
  Predicate decl;

  DefinedPredicate() { this = TPred(decl) }

  override Predicate getDeclaration() { result = decl }

  override string getName() { result = decl.getName() }

  override Type getReturnType() { result = decl.getReturnType() }

  override Type getParameterType(int i) { result = decl.getParameter(i).getType() }

  // Can be removed when all types can be resolved
  override int getArity() { result = decl.getArity() }

  override Type getDeclaringType() {
    result = decl.(ClassPredicate).getDeclaringType()
    or
    result = decl.(CharPred).getDeclaringType()
  }

  override predicate isPrivate() {
    decl.(ClassPredicate).isPrivate() or decl.(ClassPredicate).isPrivate()
  }
}

private class DefinedNewTypeBranch extends PredicateOrBuiltin, TNewTypeBranch {
  NewTypeBranch b;

  DefinedNewTypeBranch() { this = TNewTypeBranch(b) }

  override NewTypeBranch getDeclaration() { result = b }

  override string getName() { result = b.getName() }

  override NewTypeBranchType getReturnType() { result.getDeclaration() = b }

  override Type getParameterType(int i) { result = b.getField(i).getType() }

  // Can be removed when all types can be resolved
  override int getArity() { result = count(b.getField(_)) }

  override Type getDeclaringType() { none() }

  override predicate isPrivate() { b.getNewType().isPrivate() }
}

private class TBuiltin = TBuiltinClassless or TBuiltinMember;

class BuiltinPredicate extends PredicateOrBuiltin, TBuiltin { }

private class BuiltinClassless extends BuiltinPredicate, TBuiltinClassless {
  string name;
  string ret;
  string args;

  BuiltinClassless() { this = TBuiltinClassless(ret, name, args) }

  override string getName() { result = name }

  override PrimitiveType getReturnType() { result.getName() = ret }

  override PrimitiveType getParameterType(int i) { result.getName() = getArgType(args, i) }
}

private class BuiltinMember extends BuiltinPredicate, TBuiltinMember {
  string name;
  string qual;
  string ret;
  string args;

  BuiltinMember() { this = TBuiltinMember(qual, ret, name, args) }

  override string getName() { result = name }

  override PrimitiveType getReturnType() { result.getName() = ret }

  override PrimitiveType getParameterType(int i) { result.getName() = getArgType(args, i) }

  override PrimitiveType getDeclaringType() { result.getName() = qual }
}

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
    c = strictcount(ClasslessPredicate p0 | resolvePredicateExpr(pe, p0)) and
    c > 1 and
    resolvePredicateExpr(pe, p)
  }

  query predicate multipleResolveCall(Call call, int c, PredicateOrBuiltin p) {
    c =
      strictcount(PredicateOrBuiltin p0 |
        resolveCall(call, p0) and
        // aliases are expected to resolve to multiple.
        not exists(p0.getDeclaration().(ClasslessPredicate).getAlias())
      ) and
    c > 1 and
    resolveCall(call, p)
  }
}
