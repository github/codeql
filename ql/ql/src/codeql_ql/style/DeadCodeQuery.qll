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
private AstNode queryable() {
  // result = query relation that is "transitively" imported by a .ql file.
  PathProblemQuery::importsQueryRelation(result).asFile().getExtension() = "ql"
  or
  // the from-where-select
  result instanceof Select
  or
  // child of the above.
  result = queryable().getAChild()
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
  result = queryable()
  or
  // 3) A module with an import that imports another file, the import can activate a file.
  result.(Module).getAMember().(Import).getResolvedModule().getFile() !=
    result.getLocation().getFile()
  or
  // 4) Things that aren't really alive, but that this query treats as live.
  result = hackyShouldBeTreatedAsAlive()
  or
  //
  // The recursive cases.
  //
  result.getEnclosingPredicate() = alive()
  or
  result = alive().(Call).getTarget()
  or
  alive().(ClassPredicate).overrides(result)
  or
  result.(ClassPredicate).overrides(alive())
  or
  result = alive().(PredicateExpr).getResolvedPredicate()
  or
  // if a sub-class is alive, then the super-class is alive.
  result = alive().(Class).getASuperType().getResolvedType().(ClassType).getDeclaration()
  or
  // if the super class is alive and abstract, then any sub-class is alive.
  exists(Class sup | sup = alive() and sup.isAbstract() |
    sup = result.(Class).getASuperType().getResolvedType().(ClassType).getDeclaration()
  )
  or
  result = alive().(Class).getAChild() and
  not result.hasAnnotation("private")
  or
  result = alive().getAnAnnotation()
  or
  result = alive().getQLDoc()
  or
  // any imported module is alive. We don't have to handle the "import a file"-case, those are treated as public APIs.
  result = alive().(Import).getResolvedModule().asModule()
  or
  result = alive().(VarDecl).getType().getDeclaration()
  or
  result = alive().(FieldDecl).getVarDecl()
  or
  result = alive().(InlineCast).getType().getDeclaration()
  or
  // a class overrides some predicate, is the super-predicate is alive.
  exists(ClassPredicate pred, ClassPredicate sup |
    pred.hasAnnotation("override") and
    pred.overrides(sup) and
    result = pred.getParent() and
    sup.getParent() = alive()
  )
  or
  // if a class is alive, so is it's super-class
  result =
    [alive().(Class).getASuperType(), alive().(Class).getAnInstanceofType()]
        .getResolvedType()
        .getDeclaration()
  or
  // if a class is alive and abstract, then any sub-class is alive.
  exists(Class clz, Class sup | result = clz |
    clz.getASuperType().getResolvedType().getDeclaration() = sup and
    sup.isAbstract() and
    sup = alive()
  )
  or
  // a module containing something live, is also alive.
  result.(Module).getAMember() = alive()
  or
  result = alive().(Module).getAlias()
  or
  result.(NewType).getABranch() = alive()
  or
  result = alive().(TypeExpr).getAChild()
  or
  result = alive().(FieldAccess).getDeclaration()
  or
  result = alive().(VarDecl).getTypeExpr()
  or
  result.(Import).getParent() = alive()
  or
  result = alive().(NewType).getABranch()
  or
  result = alive().(ModuleExpr).getAChild()
  or
  result = alive().(ModuleExpr).getResolvedModule().asModule()
  or
  result = alive().(InstanceOf).getType().getResolvedType().getDeclaration()
  or
  result = alive().(Annotation).getAChild()
  or
  result = alive().(Predicate).getReturnType().getDeclaration()
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

private predicate isDeadInternal(AstNode node) {
  not node = alive() and
  not node = deprecated() and
  not node = classUnion()
}

predicate isDead(AstNode node) {
  isDeadInternal(node) and
  not isDeadInternal(node.getParent()) and
  not node instanceof BlockComment and
  exists(node.toString()) and // <- invalid code
  node.getLocation().getFile().getExtension() = ["ql", "qll"] and // ignore dbscheme files
  // cached-stages pattern
  not node.(Module).getAMember().(ClasslessPredicate).getName() = "forceStage" and
  not node.(ClasslessPredicate).getName() = "forceStage" and
  not node.getLocation().getFile().getBaseName() = "Caching.qll" and
  not node.getLocation().getFile().getRelativePath().matches("%/tutorials/%") // sometimes contains dead code - ignore
}
