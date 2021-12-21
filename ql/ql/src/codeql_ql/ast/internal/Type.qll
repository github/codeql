import ql
private import codeql_ql.ast.internal.AstNodes as AstNodes
private import codeql_ql.ast.internal.TreeSitter
private import codeql_ql.ast.internal.Module
private import codeql_ql.ast.internal.Predicate

cached
private newtype TType =
  TClass(Class c) { isActualClass(c) } or
  TNewType(NewType n) or
  TNewTypeBranch(NewTypeBranch b) or
  TPrimitive(string s) { primTypeName(s) } or
  TUnion(Class c) { exists(c.getUnionMember()) } or
  TDontCare() or
  TClassChar(Class c) { isActualClass(c) } or
  TClassDomain(Class c) { isActualClass(c) } or
  TDatabase(string s) { exists(TypeExpr t | t.isDBType() and s = t.getClassName()) }

private predicate primTypeName(string s) { s = ["int", "float", "string", "boolean", "date"] }

private predicate isActualClass(Class c) {
  not exists(c.getAliasType()) and
  not exists(c.getUnionMember())
}

/**
 * A type, such as `int` or `Node`.
 */
class Type extends TType {
  string toString() { result = this.getName() }

  string getName() { result = "???" }

  /**
   * Gets a supertype of this type. This follows the user-visible type heirarchy,
   * and doesn't include internal types like the characteristic and domain types of classes.
   */
  Type getASuperType() { none() }

  /**
   * Gets a supertype of this type in the internal heirarchy,
   * which includes the characteristic and domain types of classes.
   */
  Type getAnInternalSuperType() { result = TDontCare() }

  AstNode getDeclaration() { none() }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    if exists(this.getDeclaration())
    then
      this.getDeclaration()
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

  pragma[nomagic]
  private predicate getClassPredicate0(string name, int arity, PredicateOrBuiltin p, Type t) {
    p = classPredCandidate(this, name, arity) and
    t = p.getDeclaringType().getASuperType+()
  }

  pragma[nomagic]
  private predicate getClassPredicate1(
    string name, int arity, PredicateOrBuiltin p1, PredicateOrBuiltin p2
  ) {
    this.getClassPredicate0(name, arity, p1, p2.getDeclaringType()) and
    p2 = classPredCandidate(this, name, arity)
  }

  cached
  PredicateOrBuiltin getClassPredicate(string name, int arity) {
    result = classPredCandidate(this, name, arity) and
    not this.getClassPredicate1(name, arity, _, result)
  }
}

class ClassType extends Type, TClass {
  Class decl;

  ClassType() { this = TClass(decl) }

  override string getName() { result = decl.getName() }

  override Class getDeclaration() { result = decl }

  override Type getASuperType() { result = decl.getASuperType().getResolvedType() }

  Type getAnInstanceofType() { result = decl.getAnInstanceofType().getResolvedType() }

  override Type getAnInternalSuperType() {
    result.(ClassCharType).getClassType() = this
    or
    result = super.getAnInternalSuperType()
  }

  VarDecl getField(string name) {
    result = fieldCandidate(this, name) and
    not exists(VarDecl other | other = fieldCandidate(this, name) |
      other.getDeclaringType().getASuperType+() = result.getDeclaringType()
    )
  }
}

private PredicateOrBuiltin declaredPred(Type ty, string name, int arity) {
  result.getDeclaringType() = ty and
  result.getName() = name and
  result.getArity() = arity
}

pragma[nomagic]
private PredicateOrBuiltin classPredCandidate(Type ty, string name, int arity) {
  result = declaredPred(ty, name, arity)
  or
  not exists(declaredPred(ty, name, arity)) and
  result = inherClassPredCandidate(ty, name, arity)
}

private PredicateOrBuiltin inherClassPredCandidate(Type ty, string name, int arity) {
  result = classPredCandidate(ty.getAnInternalSuperType(), name, arity) and
  not result.isPrivate()
}

predicate predOverrides(ClassPredicate sub, ClassPredicate sup) {
  sup = inherClassPredCandidate(sub.getDeclaringType(), sub.getName(), sub.getArity())
}

private VarDecl declaredField(ClassType ty, string name) {
  result = ty.getDeclaration().getAField().getVarDecl() and
  result.getName() = name
}

private VarDecl fieldCandidate(ClassType ty, string name) {
  result = declaredField(ty, name)
  or
  not exists(declaredField(ty, name)) and
  result = inherFieldCandidate(ty, name)
}

private VarDecl inherFieldCandidate(ClassType ty, string name) {
  result = fieldCandidate(ty.getASuperType(), name) and
  not result.isPrivate()
}

predicate fieldOverrides(VarDecl sub, VarDecl sup) {
  sup = inherFieldCandidate(sub.getDeclaringType(), sub.getName())
}

class ClassCharType extends Type, TClassChar {
  Class decl;

  ClassCharType() { this = TClassChar(decl) }

  override string getName() { exists(string n | n = decl.getName() | result = n + "." + n) }

  override Class getDeclaration() { result = decl }

  ClassType getClassType() { result = TClass(decl) }

  override Type getAnInternalSuperType() {
    result.(ClassDomainType).getClassType() = this.getClassType()
  }
}

class ClassDomainType extends Type, TClassDomain {
  Class decl;

  ClassDomainType() { this = TClassDomain(decl) }

  override string getName() { result = decl.getName() + ".extends" }

  override Class getDeclaration() { result = decl }

  ClassType getClassType() { result = TClass(decl) }

  override Type getAnInternalSuperType() { result = this.getClassType().getASuperType() }
}

class PrimitiveType extends Type, TPrimitive {
  string name;

  PrimitiveType() { this = TPrimitive(name) }

  override string getName() { result = name }

  override Type getASuperType() { name = "int" and result.(PrimitiveType).getName() = "float" }

  override Type getAnInternalSuperType() {
    result = this.getASuperType()
    or
    result = super.getAnInternalSuperType()
  }
}

class DontCareType extends Type, TDontCare {
  override string getName() { result = "_" }

  override Type getAnInternalSuperType() { none() }
}

class NewTypeType extends Type, TNewType {
  NewType decl;

  NewTypeType() { this = TNewType(decl) }

  override NewType getDeclaration() { result = decl }

  NewTypeBranchType getABranch() { result = TNewTypeBranch(decl.getABranch()) }

  override string getName() { result = decl.getName() }
}

class NewTypeBranchType extends Type, TNewTypeBranch {
  NewTypeBranch decl;

  NewTypeBranchType() { this = TNewTypeBranch(decl) }

  override NewTypeBranch getDeclaration() { result = decl }

  override string getName() { result = decl.getName() }

  override Type getASuperType() {
    result = TNewType(decl.getParent())
    or
    result.(UnionType).getUnionMember() = this
  }

  override Type getAnInternalSuperType() {
    result = this.getASuperType()
    or
    result = super.getAnInternalSuperType()
  }
}

class UnionType extends Type, TUnion {
  Class decl;

  UnionType() { this = TUnion(decl) }

  override Class getDeclaration() { result = decl }

  override string getName() { result = decl.getName() }

  Type getUnionMember() { result = decl.getUnionMember().getResolvedType() }
}

class DatabaseType extends Type, TDatabase {
  string name;

  DatabaseType() { this = TDatabase(name) }

  override string getName() { result = name }
}

cached
predicate resolveTypeExpr(TypeExpr te, Type t) {
  if te.isDBType()
  then t = TDatabase(te.getClassName())
  else
    if primTypeName(te.getClassName())
    then t = TPrimitive(te.getClassName())
    else
      exists(FileOrModule m, boolean public, string clName | qualifier(te, m, public, clName) |
        defines(m, clName, t, public)
      )
}

pragma[noinline]
private predicate qualifier(TypeExpr te, FileOrModule m, boolean public, string clName) {
  te.getClassName() = clName and
  if exists(te.getModule())
  then (
    public = true and m = te.getModule().getResolvedModule()
  ) else (
    (public = true or public = false) and
    m = getEnclosingModule(te).getEnclosing*()
  )
}

pragma[nomagic]
private predicate defines(FileOrModule m, string name, Type t, boolean public) {
  exists(Class ty | t = TClass(ty) |
    getEnclosingModule(ty) = m and
    ty.getName() = name and
    public = getPublicBool(ty)
  )
  or
  exists(NewType ty | t = TNewType(ty) |
    getEnclosingModule(ty) = m and
    ty.getName() = name and
    public = getPublicBool(ty)
  )
  or
  exists(NewTypeBranch ty | t = TNewTypeBranch(ty) |
    getEnclosingModule(ty) = m and
    ty.getName() = name and
    public = getPublicBool(ty.getParent())
  )
  or
  exists(Class ty | t = TUnion(ty) |
    getEnclosingModule(ty) = m and
    ty.getName() = name and
    public = getPublicBool(ty)
  )
  or
  exists(Class ty | t = ty.getAliasType().getResolvedType() |
    getEnclosingModule(ty) = m and
    ty.getName() = name and
    public = getPublicBool(ty)
  )
  or
  exists(Import im |
    getEnclosingModule(im) = m and
    not exists(im.importedAs()) and
    public = getPublicBool(im) and
    defines(im.getResolvedModule(), name, t, true)
  )
}

module TyConsistency {
  query predicate noResolve(TypeExpr te) {
    not resolveTypeExpr(te, _) and
    not te.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  query predicate multipleResolve(TypeExpr te, int c, Type t) {
    c = strictcount(Type t0 | resolveTypeExpr(te, t0)) and
    c > 1 and
    resolveTypeExpr(te, t)
  }

  query predicate multiplePrimitives(TypeExpr te, int c, PrimitiveType t) {
    c = strictcount(PrimitiveType t0 | resolveTypeExpr(te, t0)) and
    c > 1 and
    resolveTypeExpr(te, t)
  }

  query predicate varDefNoType(VarDef def) {
    not exists(def.getType()) and
    not def.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  query predicate exprNoType(Expr e) {
    not exists(e.getType()) and
    not exists(PredicateOrBuiltin p |
      p = e.(Call).getTarget() and
      not exists(p.getReturnType())
    ) and
    not e instanceof Formula and
    not e.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  query predicate multiplePrimitivesExpr(Expr e, int c, PrimitiveType t) {
    c = strictcount(PrimitiveType t0 | t0 = e.getType()) and
    c > 1 and
    t = e.getType()
  }
}
