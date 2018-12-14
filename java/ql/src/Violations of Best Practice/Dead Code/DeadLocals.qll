/*
 * Provides classes and predicates for "dead locals": which variables are used, which assignments are useless, etc.
 */

import java
import semmle.code.java.dataflow.SSA
private import semmle.code.java.frameworks.Assertions

private predicate emptyDecl(SsaExplicitUpdate ssa) {
  exists(LocalVariableDeclExpr decl |
    decl = ssa.getDefiningExpr() and
    not exists(decl.getInit()) and
    not exists(EnhancedForStmt for | for.getVariable() = decl)
  )
}

/**
 * A dead SSA variable. Excludes parameters, and phi nodes are never dead, so only includes `VariableUpdate`s.
 */
predicate deadLocal(SsaExplicitUpdate ssa) {
  ssa.getSourceVariable().getVariable() instanceof LocalScopeVariable and
  not exists(ssa.getAUse()) and
  not exists(SsaPhiNode phi | phi.getAPhiInput() = ssa) and
  not exists(SsaImplicitInit init | init.captures(ssa)) and
  not emptyDecl(ssa) and
  not readImplicitly(ssa, _)
}

/**
 * A dead SSA variable that is expected to be dead as indicated by an assertion.
 */
predicate expectedDead(SsaExplicitUpdate ssa) {
  deadLocal(ssa) and
  assertFail(ssa.getBasicBlock(), _)
}

/**
 * A dead SSA variable that is overwritten by a live SSA definition.
 */
predicate overwritten(SsaExplicitUpdate ssa) {
  deadLocal(ssa) and
  exists(SsaExplicitUpdate overwrite |
    overwrite.getSourceVariable() = ssa.getSourceVariable() and
    not deadLocal(overwrite) and
    not overwrite.getDefiningExpr() instanceof LocalVariableDeclExpr and
    exists(BasicBlock bb1, BasicBlock bb2, int i, int j |
      bb1.getNode(i) = ssa.getCFGNode() and
      bb2.getNode(j) = overwrite.getCFGNode()
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
  exists(VarAccess va | va = v.getAnAccess() | va.isRValue())
  or
  readImplicitly(_, v)
}

private predicate readImplicitly(SsaExplicitUpdate ssa, LocalScopeVariable v) {
  v = ssa.getSourceVariable().getVariable() and
  exists(TryStmt try | try.getAResourceVariable() = ssa.getDefiningExpr().getDestVar())
}

/**
 * A local variable with a write access.
 */
predicate assigned(LocalScopeVariable v) {
  exists(VarAccess va | va = v.getAnAccess() | va.isLValue())
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
    exists(MethodAccess ma, Method m |
      bad = ma and m = ma.getMethod().getAPossibleImplementation()
    |
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
  exists(MethodAccess ma | ma.getEnclosingCallable() = c)
  or
  exists(ClassInstanceExpr cie | cie.getEnclosingCallable() = c)
  or
  exists(Assignment a | a.getEnclosingCallable() = c |
    not exists(VarAccess va | va = a.getDest() |
      va.getVariable() instanceof LocalVariableDecl
      or
      exists(Field f | f = va.getVariable() |
        va.getQualifier() instanceof ThisAccess or
        not exists(va.getQualifier())
      )
    )
  )
}

private predicate methodHasEffect(Method m) {
  exists(MethodAccess ma | ma.getEnclosingCallable() = m) or
  exists(Assignment a | a.getEnclosingCallable() = m) or
  exists(ClassInstanceExpr cie | cie.getEnclosingCallable() = m) or
  exists(ThrowStmt throw | throw.getEnclosingCallable() = m) or
  m.isNative()
}
