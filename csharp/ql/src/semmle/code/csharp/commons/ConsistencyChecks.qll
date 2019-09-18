/**
 * INTERNAL: Do not use.
 *
 * Provides functionality for validating that the database and library are in a
 * consistent state.
 */

import csharp

private predicate missingLocation(Element e, string m) {
  (
    e instanceof Declaration or
    e instanceof Expr or
    e instanceof Stmt
  ) and
  not e instanceof ImplicitAccessorParameter and
  not e instanceof NullType and
  not e instanceof Parameter and // Bug in Roslyn - params occasionally lack locations
  not e.(Operator).getDeclaringType() instanceof IntType and // Roslyn quirk
  not e instanceof Constructor and
  not e instanceof ArrayType and
  not e instanceof UnknownType and
  not e instanceof ArglistType and
  not exists(TupleType t | e = t or e = t.getAField()) and
  not exists(e.getLocation()) and
  m = "Element does not have a location"
}

private predicate inconsistentGeneric(ConstructedGeneric g, string m) {
  not exists(g.getUnboundGeneric()) and
  m = "Constructed generic does not have an unbound generic"
  or
  g.getNumberOfTypeArguments() = 0 and
  m = "Constructed generic has no type arguments"
  or
  g.getUnboundGeneric().getNumberOfTypeParameters() != g.getNumberOfTypeArguments() and
  m = "Inconsistent number of type arguments/parameters"
}

module SsaChecks {
  import Ssa

  predicate nonUniqueSsaDef(AssignableRead read, string m) {
    exists(ControlFlow::Node cfn | strictcount(Definition def | def.getAReadAtNode(cfn) = read) > 1) and
    m = "Read is associated with multiple SSA definitions"
  }

  predicate notDominatedByDef(AssignableRead read, string m) {
    exists(Definition def, BasicBlock bb, ControlFlow::Node rnode, ControlFlow::Node dnode, int i |
      def.getAReadAtNode(rnode) = read
    |
      def.definesAt(bb, i) and
      dnode = bb.getNode(max(int j | j = i or j = 0)) and
      not dnode.dominates(rnode)
    ) and
    m = "Read is not dominated by SSA definition"
  }

  predicate localDeclWithSsaDef(LocalVariableDeclExpr d, string m) {
    // Local variables in C# must be initialized before every use, so uninitialized
    // local variables should not have an SSA definition, as that would imply that
    // the declaration is live (can reach a use without passing through a definition)
    exists(ExplicitDefinition def |
      d = def.getADefinition().(AssignableDefinitions::LocalVariableDefinition).getDeclaration()
    |
      not d = any(ForeachStmt fs).getVariableDeclExpr() and
      not d = any(SpecificCatchClause scc).getVariableDeclExpr() and
      not d.getVariable().getType() instanceof Struct and
      not d = any(BindingPatternExpr bpe).getVariableDeclExpr()
    ) and
    m = "Local variable declaration has unexpected SSA definition"
  }

  predicate ssaConsistencyFailure(Element e, string m) {
    nonUniqueSsaDef(e, m) or
    notDominatedByDef(e, m) or
    localDeclWithSsaDef(e, m)
  }
}

module CfgChecks {
  predicate multipleSuccessors(ControlFlowElement cfe, string m) {
    exists(ControlFlow::Node cfn | cfn = cfe.getAControlFlowNode() |
      strictcount(cfn.getASuccessorByType(any(ControlFlow::SuccessorTypes::NormalSuccessor e))) > 1 and
      m = "Multiple (non-conditional/exceptional) successors"
    )
  }
}

/**
 * Holds if element `e` has a consistency failure, as described by
 * the message in `m`.
 */
predicate consistencyFailure(Element e, string m) {
  missingLocation(e, m) or
  inconsistentGeneric(e, m) or
  SsaChecks::ssaConsistencyFailure(e, m) or
  CfgChecks::multipleSuccessors(e, m)
}
