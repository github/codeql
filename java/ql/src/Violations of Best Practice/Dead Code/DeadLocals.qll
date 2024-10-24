/**
 * Provides classes and predicates for "dead locals": which variables are used, which assignments are useless, etc.
 */

import java
import semmle.code.java.dataflow.SSA
private import semmle.code.java.frameworks.Assertions

private predicate emptyDecl(LocalVariableDeclExpr decl) {
  not exists(decl.getInit()) and
  not exists(EnhancedForStmt for | for.getVariable() = decl)
}

/** A dead variable update. */
predicate deadLocal(VariableUpdate upd) {
  upd.getDestVar() instanceof LocalScopeVariable and
  not exists(SsaExplicitUpdate ssa | upd = ssa.getDefiningExpr()) and
  not emptyDecl(upd) and
  not readImplicitly(upd, _)
}

/**
 * A dead variable update that is expected to be dead as indicated by an assertion.
 */
predicate expectedDead(VariableUpdate upd) { assertFail(upd.getBasicBlock(), _) }

/**
 * A dead update that is overwritten by a live update.
 */
predicate overwritten(VariableUpdate upd) {
  deadLocal(upd) and
  exists(VariableUpdate overwrite |
    overwrite.getDestVar() = upd.getDestVar() and
    not deadLocal(overwrite) and
    not overwrite instanceof LocalVariableDeclExpr and
    exists(BasicBlock bb1, BasicBlock bb2, int i, int j |
      bb1.getNode(i) = upd.getControlFlowNode() and
      bb2.getNode(j) = overwrite.getControlFlowNode()
    |
      bb1.getABBSuccessor+() = bb2
      or
      bb1 = bb2 and i < j
    )
  )
}

/**
 * A local variable with a read access.
 */
predicate read(LocalScopeVariable v) {
  exists(VarAccess va | va = v.getAnAccess() | va.isVarRead())
  or
  readImplicitly(_, v)
}

predicate readImplicitly(VariableUpdate upd, LocalScopeVariable v) {
  v = upd.getDestVar() and
  exists(TryStmt try | try.getAResourceVariable() = upd.getDestVar())
}

/**
 * A local variable with a write access.
 */
predicate assigned(LocalScopeVariable v) {
  exists(VarAccess va | va = v.getAnAccess() | va.isVarWrite())
}

/**
 * An expression without side-effects.
 */
predicate exprHasNoEffect(Expr e) {
  inInitializer(e) and
  not exists(Expr bad | bad = e.getAChildExpr*() |
    bad instanceof Assignment
    or
    bad instanceof UnaryAssignExpr
    or
    exists(ClassInstanceExpr cie, Constructor c |
      bad = cie and c = cie.getConstructor().getSourceDeclaration()
    |
      constructorHasEffect(c)
    )
    or
    exists(MethodCall ma, Method m | bad = ma and m = ma.getMethod().getAPossibleImplementation() |
      methodHasEffect(m) or not m.fromSource()
    )
  )
}

private predicate inInitializer(Expr e) {
  exists(LocalVariableDeclExpr decl | e = decl.getInit().getAChildExpr*())
}

// The next two predicates are somewhat conservative.
private predicate constructorHasEffect(Constructor c) {
  // Only assign fields of the class - do not call methods,
  // create new objects or assign any other variables.
  exists(MethodCall ma | ma.getEnclosingCallable() = c)
  or
  exists(ClassInstanceExpr cie | cie.getEnclosingCallable() = c)
  or
  exists(Assignment a | a.getEnclosingCallable() = c |
    not exists(VarAccess va | va = a.getDest() |
      va.getVariable() instanceof LocalVariableDecl or
      va.(FieldAccess).isOwnFieldAccess()
    )
  )
}

private predicate methodHasEffect(Method m) {
  exists(MethodCall ma | ma.getEnclosingCallable() = m) or
  exists(Assignment a | a.getEnclosingCallable() = m) or
  exists(ClassInstanceExpr cie | cie.getEnclosingCallable() = m) or
  exists(ThrowStmt throw | throw.getEnclosingCallable() = m) or
  m.isNative()
}
