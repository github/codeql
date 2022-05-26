import ql
import codeql_ql.bugs.PathProblemQueryQuery as PathProblemQuery
import codeql_ql.ast.internal.Module

/** Gets something that can be imported by a ".qll" file. */
private AstNode publicApi() {
  // base case - the toplevel is always "exported".
  result instanceof TopLevel
  or
  // recursive case. A public class/module/predicate/import that is a child of a public API.
  not result.hasAnnotation("private") and
  not result.getLocation().getFile().getExtension() = "ql" and // everything in ".ql" files is kinda private, as you can't import it. Query predicates/from-where-select is handled in `queryable`.
  result.getParent() = publicApi() and
  (
    result instanceof Class
    or
    result instanceof ClasslessPredicate
    or
    result instanceof Module
    or
    result instanceof Import
  )
  or
  result = publicApi().(Import).getResolvedModule().asModule()
}

/**
 * Gets any AstNode that directly computes a result of a query.
 * I.e. a query predicate or the from-where-select.
 */
private AstNode queryPredicate() {
  // result = query relation that is "transitively" imported by a .ql file.
  PathProblemQuery::importsQueryRelation(result).asFile().getExtension() = "ql"
  or
  // the from-where-select
  result instanceof Select
  or
  // child of the above.
  result = queryPredicate().getAChild()
}

AstNode hackyShouldBeTreatedAsAlive() {
  // Stages from the shared DataFlow impl are copy-pasted, so predicates that are dead in one stage are not dead in another.
  result = any(Module mod | mod.getName().matches("Stage%")).getAMember().(ClasslessPredicate) and
  result.getLocation().getFile().getBaseName().matches("DataFlowImpl%")
  or
  // Python stuff
  result.(Predicate).getName() = "quickEvalMe" // private predicate used for quick-eval
  or
  result.(Module).getName() = "FutureWork" // holder for later.
  or
  result = hackyShouldBeTreatedAsAlive().getAChild()
}

/**
 * Gets an AST node that is alive.
 * That is, an API node that may in some way be part of or affect a query result or a publicly available API.
 */
private AstNode alive() {
  //
  // The 4 base cases.
  //
  // 1) everything that can be imported.
  result = publicApi()
  or
  // 2) everything that can be an output when running a query
  result = queryPredicate()
  or
  // 3) A module with an import that imports another file, the import can activate a file.
  result.(Module).getAMember().(Import).getResolvedModule().getFile() !=
    result.getLocation().getFile()
  or
  // 4) Things that aren't really alive, but that this query treats as live.
  result = hackyShouldBeTreatedAsAlive()
  or
  result instanceof TopLevel // toplevel is always alive.
  or
  // recurisve cases
  result = aliveStep(alive())
}

private AstNode aliveStep(AstNode prev) {
  //
  // The recursive cases.
  //
  result.getEnclosingPredicate() = prev
  or
  result = prev.(Call).getTarget()
  or
  prev.(ClassPredicate).overrides(result)
  or
  result.(ClassPredicate).overrides(prev)
  or
  result = prev.(PredicateExpr).getResolvedPredicate()
  or
  // if a sub-class is alive, then the super-class is alive.
  result = prev.(Class).getASuperType().getResolvedType().(ClassType).getDeclaration()
  or
  // if the super class is alive and abstract, then any sub-class is alive.
  exists(Class sup | sup = prev and sup.isAbstract() |
    sup = result.(Class).getASuperType().getResolvedType().(ClassType).getDeclaration()
  )
  or
  result = prev.(Class).getAChild() and
  not result.hasAnnotation("private")
  or
  result = prev.getAnAnnotation()
  or
  result = prev.getQLDoc()
  or
  // any imported module is alive. We don't have to handle the "import a file"-case, those are treated as public APIs.
  result = prev.(Import).getResolvedModule().asModule()
  or
  result = prev.(VarDecl).getType().getDeclaration()
  or
  result = prev.(FieldDecl).getVarDecl()
  or
  result = prev.(InlineCast).getType().getDeclaration()
  or
  // a class overrides some predicate, is the super-predicate is alive.
  exists(ClassPredicate pred, ClassPredicate sup |
    pred.hasAnnotation("override") and
    pred.overrides(sup) and
    result = pred.getParent() and
    sup.getParent() = prev
  )
  or
  // if a class is alive, so is it's super-class
  result =
    [prev.(Class).getASuperType(), prev.(Class).getAnInstanceofType()]
        .getResolvedType()
        .getDeclaration()
  or
  // if a class is alive and abstract, then any sub-class is alive.
  exists(Class clz, Class sup | result = clz |
    clz.getASuperType().getResolvedType().getDeclaration() = sup and
    sup.isAbstract() and
    sup = prev
  )
  or
  // a module containing something live, is also alive.
  result.(Module).getAMember() = prev
  or
  result = prev.(Module).getAlias()
  or
  result.(NewType).getABranch() = prev
  or
  result = prev.(TypeExpr).getAChild()
  or
  result = prev.(FieldAccess).getDeclaration()
  or
  result = prev.(VarDecl).getTypeExpr()
  or
  result.(Import).getParent() = prev
  or
  result = prev.(NewType).getABranch()
  or
  result = prev.(ModuleExpr).getAChild()
  or
  result = prev.(ModuleExpr).getResolvedModule().asModule()
  or
  result = prev.(InstanceOf).getType().getResolvedType().getDeclaration()
  or
  result = prev.(Annotation).getAChild()
  or
  result = prev.(Predicate).getReturnType().getDeclaration()
}

private AstNode deprecated() {
  result.hasAnnotation("deprecated")
  or
  result = deprecated().getQLDoc()
  or
  result = deprecated().getAnAnnotation()
  or
  result = deprecated().getAChild()
}

// our type-resolution skips these, so ignore.
private AstNode classUnion() {
  exists(result.(Class).getUnionMember())
  or
  exists(result.(Class).getAliasType())
  or
  result = classUnion().(Class).getUnionMember()
  or
  result = classUnion().(Class).getAliasType()
  or
  result = classUnion().getAnAnnotation()
  or
  result = classUnion().getQLDoc()
  or
  result = classUnion().(TypeExpr).getAChild()
  or
  result = classUnion().(ModuleExpr).getAChild()
}

private AstNode benign() {
  not result.getLocation().getFile().getExtension() = ["ql", "qll"] or // ignore dbscheme files
  result instanceof BlockComment or
  not exists(result.toString()) or // <- invalid code
  // cached-stages pattern
  result.(Module).getAMember().(ClasslessPredicate).getName() = "forceStage" or
  result.(ClasslessPredicate).getName() = "forceStage" or
  result.getLocation().getFile().getBaseName() = "Caching.qll" or
  // sometimes contains dead code - ignore
  result.getLocation().getFile().getRelativePath().matches("%/tutorials/%") or
  result = classUnion()
}

private predicate isDeadInternal(AstNode node) {
  not node = alive() and
  not node = deprecated()
}

predicate isDead(AstNode node) {
  isDeadInternal(node) and
  not isDeadInternal(node.getParent()) and
  not node = benign()
}

/**
 * Gets an AST node that affects a query.
 */
private AstNode queryable() {
  //
  // The base cases.
  //
  // everything that can be an output when running a query
  result = queryPredicate()
  or
  // A module with an import that imports another file, the import can activate a file.
  result.(Module).getAMember().(Import).getResolvedModule().getFile() !=
    result.getLocation().getFile()
  or
  result instanceof TopLevel // toplevel is always alive.
  or
  // recurisve cases
  result = aliveStep(queryable())
}

/**
 * Gets an AstNode that does not affect any query result.
 * Is interresting as an quick-eval target to investigate dead code.
 * (It is intentional that this predicate is a result of this predicate).
 */
AstNode unQueryable(string msg) {
  not result = queryable() and
  not result = deprecated() and
  not result = benign() and
  not result.getParent() = any(AstNode node | not node = queryable()) and
  msg = result.getLocation().getFile().getBaseName() and
  result.getLocation().getFile().getAbsolutePath().matches("%/javascript/%")
}
