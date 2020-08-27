/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import javascript
import DeadStore

/**
 * Holds if `vd` is a definition of variable `v` that is dead, that is,
 * the value it assigns to `v` is not read.
 *
 * Captured variables may be read by closures, so we restrict this to
 * purely local variables.
 */
predicate deadStoreOfLocal(VarDef vd, PurelyLocalVariable v) {
  v = vd.getAVariable() and
  (exists(vd.getSource()) or exists(vd.getDestructuringSource())) and
  // the definition is not in dead code
  exists(ReachableBasicBlock rbb | vd = rbb.getANode()) and
  // but it has no associated SSA definition, that is, it is dead
  not exists(SsaExplicitDefinition ssa | ssa.defines(vd, v))
}

from VarDef dead, PurelyLocalVariable v, string msg
where
  deadStoreOfLocal(dead, v) and
  // the variable should be accessed somewhere; otherwise it will be flagged by UnusedVariable
  exists(v.getAnAccess()) and
  // don't flag ambient variable definitions
  not dead.(ASTNode).isAmbient() and
  // don't flag variables with ambient uses
  not exists(LexicalAccess access |
    access.getALexicalName() = v.getADeclaration().getALexicalName() and
    access.isAmbient()
  ) and
  // don't flag function expressions
  not exists(FunctionExpr fe | dead = fe.getIdentifier()) and
  // don't flag function declarations nested inside blocks or other compound statements;
  // their meaning is only partially specified by the standard
  not exists(FunctionDeclStmt fd, StmtContainer outer |
    dead = fd.getIdentifier() and outer = fd.getEnclosingContainer()
  |
    not fd = outer.getBody().(BlockStmt).getAStmt()
  ) and
  // don't flag overwrites with `null` or `undefined`
  not SyntacticConstants::isNullOrUndefined(dead.getSource()) and
  // don't flag default inits that are later overwritten
  not (isDefaultInit(dead.getSource().(Expr).getUnderlyingValue()) and dead.isOverwritten(v)) and
  // don't flag assignments in externs
  not dead.(ASTNode).inExternsFile() and
  // don't flag exported variables
  not any(ES2015Module m).exportsAs(v, _) and
  // don't flag 'exports' assignments in closure modules
  not any(Closure::ClosureModule mod).getExportsVariable() = v and
  (
    // To avoid confusion about the meaning of "definition" and "declaration" we avoid
    // the term "definition" when the alert location is a variable declaration.
    if
      dead instanceof VariableDeclarator and
      not exists(SsaImplicitInit init | init.getVariable().getSourceVariable() = v) // the variable is dead at the hoisted implicit initialization.
    then msg = "The initial value of " + v.getName() + " is unused, since it is always overwritten."
    else msg = "The value assigned to " + v.getName() + " here is unused."
  )
select dead, msg
