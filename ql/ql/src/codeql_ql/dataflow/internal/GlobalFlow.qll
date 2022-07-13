/**
 * Models global flow, that is, flow between predicates and across disjunctions.
 *
 * We say an expression `A` "flows to" another expression `B` if some series of transformations
 * would move/copy them into the same conjunction, where they are bound by equality (or are the same variable).
 *
 * The transformations permitted are:
 * - Apply distributive law to lift a disjunction out: `A and (B or C) -> (A and B) or (A and C)`
 * - Inline a predicate call.
 *
 * Both of these tend to copy expressions, and we just ask if some copy of `A` and some copy of `B` could
 * end up in the same place.
 *
 * For example, `A` flows to both `B` and `C`, but `B` does not flow to `C`:
 * ```
 * x = A and (x = B or x = C)
 * -->
 * (x = A and x = B) or (x = A and x = C)
 * ```
 *
 * We don't actually perform these exponential-cost transformations, we just use them to specify what "flow" means.
 *
 * The problem of determining which expression flows where is reduced to a graph problem.
 * The edges in the graph represent inlining of a predicate or lifting of a disjunction.
 * The resulting graph is similar to the call/return edges from procedural languages, but with a
 * few tweaks -- see `EdgeLabel`.
 *
 * Note that the "flows to" relation is symmetric, but variations like "flows to using call steps" are not.
 * So we use the term "flows to" rather than a more naturally symmetric term like "unifiable with".
 */

private import codeql_ql.ast.Ast
private import codeql_ql.dataflow.DataFlow
private import VarScoping

cached
private module Cached {
  /**
   * An edge or a `Tracker` state.
   *
   * An edge represents a call site or a disjunction, and a `Tracker` state is an
   * edge or one of the special values `NoEdge` or `HasCall`.
   *
   * The tracker state could be defined as
   * ```
   * newtype TTracker = MkReturn(TEdgeLabel edge) or MkNoEdge() or MkHasCall()
   * ```
   * but for efficiency, `TTracker` and `TEdgeLabel` have been merged.
   */
  cached
  newtype TEdgeLabelOrTrackerState =
    MkCall(Call call) or
    MkMemberToCharPred(ClassPredicate p) or // implicit call to charpred in a member predicate
    MkTypeToCharPred(TypeExpr t) or // implicit call to charpred from a type annotation
    MkDisjunction(DisjunctionOperator disj) or // "call" into a disjunction branch
    MkNoEdge() or
    MkHasCall()

  /**
   * Label for a directed edge (see `EdgeLabel` class).
   */
  class TEdgeLabel = MkCall or MkMemberToCharPred or MkTypeToCharPred or MkDisjunction;

  /**
   * Holds if `argument` is passed to `parameter` via an edge of the given `edge`.
   */
  cached
  predicate directedEdge(Node argument, Node parameter, EdgeLabel edge) {
    // Argument-passing via an explicit call
    exists(Call call, Predicate target |
      call.getTarget() = target and
      edge = EdgeLabel::call(call)
    |
      exists(int i |
        argument = astNode(call.getArgument(i)) and
        parameter = astNode(target.getParameter(i))
      )
      or
      argument = astNode(call.(MemberCall).getBase()) and
      parameter = thisNode(target)
      or
      argument = astNode(call) and
      parameter = resultNode(target)
    )
    or
    // Implicit charpred call in member predicate: passes `this` and each field to the charpred
    exists(Class cls, ClassPredicate p |
      p = cls.getAClassPredicate() and
      edge = EdgeLabel::memberToCharPred(p)
    |
      argument = thisNode(p) and
      parameter = thisNode(cls.getCharPred())
      or
      exists(FieldDecl fieldDecl |
        argument = fieldNode(p, fieldDecl) and
        parameter = fieldNode(cls.getCharPred(), fieldDecl)
      )
    )
    or
    // Type test passes the tested value to the charpred of the type
    exists(TypeExpr type |
      edge = EdgeLabel::typeToCharPred(type) and
      parameter = thisNode(type.getResolvedType().getDeclaration().(Class).getCharPred())
    |
      exists(VarDecl var |
        argument = [scopedVariable(var, _), astNode(var)] and
        type = var.getTypeExpr()
      )
      or
      exists(Predicate p |
        argument = resultNode(p) and
        type = p.getReturnTypeExpr()
      )
      or
      exists(InlineCast cast |
        argument = astNode(cast.getBase()) and
        type = cast.getTypeExpr()
      )
      or
      exists(InstanceOf expr |
        argument = astNode(expr.getExpr()) and
        type = expr.getType()
      )
    )
    or
    // Flow between differently-scoped copies of the same variable, going into a disjunction
    exists(VarDef var, AstNode inner, AstNode outer, DisjunctionOperator disjunction |
      isRefinement(var, inner, outer) and
      disjunction.getAnOperand() = inner and
      edge = EdgeLabel::disjunction(disjunction)
    |
      // Scoped variable to an inner scoped variable
      argument = scopedVariable(var, outer) and
      parameter = scopedVariable(var, inner) and
      // Avoid loop edge when a VarAccess is also a disjunct (because it's an element of a set literal)
      argument != parameter
      or
      // VarDef to a scoped variable
      outer = getVarDefScope(var) and
      argument = astNode(var) and
      parameter = scopedVariable(var, inner)
    )
    or
    // Flow into a set literal, similar to flow into disjunctions.
    // If we consider a desugared set literal, `[x,y] -> any(T v | v = x or v = y)`, this edge
    // corresponds to the edges going from `T v` to its scoped variables.
    exists(Set set |
      edge = EdgeLabel::disjunction(set) and
      argument = astNode(set) and
      parameter = astNode(set.getAnElement())
    )
  }

  /**
   * Holds if `argument` is passed to `parameter` via an edge of the given `kind`.
   *
   * This is identical to `directedEdge` where the operands are mapped to their super nodes.
   */
  cached
  predicate directedEdgeSuper(SuperNode argument, SuperNode parameter, EdgeLabel edge) {
    directedEdge(argument.getANode(), parameter.getANode(), edge)
  }
}

import Cached

/**
 * Label for a directed edge.
 *
 * This is either a call (implicit or explicit) or a disjunction.
 *
 * All edges are considered "call" edges in their default orientation (even disjunction edges).
 * Flipping an edge turns it into a "return" edge (there is no separate label for return edges).
 *
 * Data flow allows any number of return edges followed by any number of call edges,
 * with this additional rule:
 *
 * - The first call edge must not have the same label as the last return edge.
 *
 * The above rule is the reason this class exists.
 *
 * - The rule ensures flow cannot step out of a disjunction, and then
 *   into another branch of the same disjunction (because they'd use the same label).
 *
 * - A byproduct of the rule is that we cannot step directly into the call edge we just came from.
 *   We lose no real flow from this, as the flow direction can just flip one step earlier.
 *
 * - It would not be enough to only enforce this for disjunction edges, because it would
 *   allow the path to "reset" its last-used edge by stepping out of a call and
 *   immediately back in again (the kind of flow mentioned above).
 */
class EdgeLabel extends TEdgeLabel {
  /** Gets a location associated with this edge label. */
  Location getLocation() {
    exists(Call call | this = EdgeLabel::call(call) | result = call.getLocation())
    or
    exists(ClassPredicate p | this = EdgeLabel::memberToCharPred(p) | result = p.getLocation())
    or
    exists(TypeExpr t | this = EdgeLabel::typeToCharPred(t) | result = t.getLocation())
    or
    exists(DisjunctionOperator disj | this = EdgeLabel::disjunction(disj) |
      result = disj.getLocation()
    )
  }

  /** Gets a string representation of this edge label. */
  string toString() {
    exists(Call call | this = EdgeLabel::call(call) |
      result =
        call.toString() + ":" + call.getLocation().getStartLine() + ":" +
          call.getLocation().getStartColumn()
    )
    or
    exists(ClassPredicate p | this = EdgeLabel::memberToCharPred(p) |
      result = "MemberToCharPred call from " + p.getName()
    )
    or
    exists(TypeExpr t | this = EdgeLabel::typeToCharPred(t) |
      result = "TypeToCharPred call from " + t.getResolvedType().getName()
    )
    or
    exists(DisjunctionOperator disj | this = EdgeLabel::disjunction(disj) |
      result =
        disj.toString() + ":" + disj.getLocation().getStartLine() + ":" +
          disj.getLocation().getStartColumn()
    )
  }
}

module EdgeLabel {
  /** Gets the edge label representing the given explicit call. */
  EdgeLabel call(Call call) { result = MkCall(call) }

  /** Gets the edge label for the implicit call to the charpred in a member predicate. */
  EdgeLabel memberToCharPred(ClassPredicate p) { result = MkMemberToCharPred(p) }

  /** Gets the edge label for the implicit call to the charpred from a type annotation. */
  EdgeLabel typeToCharPred(TypeExpr t) { result = MkTypeToCharPred(t) }

  /** Gets the edge label for the edge stepping into the given disjunction. */
  EdgeLabel disjunction(DisjunctionOperator disj) { result = MkDisjunction(disj) }
}
