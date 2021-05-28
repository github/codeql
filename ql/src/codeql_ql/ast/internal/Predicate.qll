import ql
private import Builtins
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
    definesPredicate(m, pc.getPredicateName(), p.getDeclaration(), public) and
    p.getArity() = pc.getNumberOfArguments()
  )
}

private predicate resolveMemberCall(MemberCall mc, PredicateOrBuiltin p) {
  exists(Type t |
    t = mc.getBase().getType() and
    p = t.getClassPredicate(mc.getMemberName(), mc.getNumberOfArguments())
  )
}

predicate resolveCall(Call c, PredicateOrBuiltin p) {
  resolvePredicateCall(c, p)
  or
  resolveMemberCall(c, p)
}

private newtype TPredOrBuiltin =
  TPred(Predicate p) or
  TBuiltinClassless(string ret, string name, string args) { isBuiltinClassless(ret, name, args) } or
  TBuiltinMember(string qual, string ret, string name, string args) {
    isBuiltinMember(qual, ret, name, args)
  }

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

  Predicate getDeclaration() { none() }

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

  query predicate multipleResolveCall(Call call, int c, PredicateOrBuiltin p) {
    c = strictcount(PredicateOrBuiltin p0 | resolveCall(call, p0)) and
    c > 1 and
    resolveCall(call, p)
  }
}
