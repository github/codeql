private import cpp

/**
 * A module for reasoning about macro expansion in C/C++ code.
 *
 * The library allows one to construct path-problem queries that
 * display paths through nested macro invocations to make
 * alerts in macro expansions easier to understand.
 */
module MacroFlow {
  /**
   * Configuration for defining which expressions are interesting for paths from
   * an inner-most macro expansion to an outer-most macro expansion that results
   * in an expression.
   *
   * For example, to find paths from macro invocations that expand to
   * `sizeof` expressions with literal arguments, one could do:
   * ```
   * module MyConfig implements ConfigSig {
   *  predicate isSink(Expr e) { e.(SizeofExprOperator).getExprOperand() instanceof Literal }
   * }
   *
   * module Flow = Make<MyConfig>;
   * import Flow::PathGraph
   *
   * from Flow::Node n1, Flow::Node n2, Expr e
   * where Flow::flowsTo(n1, n2, e)
   * select e, n1, n2, "Use of sizeof with literal argument."
   *
   * ```
   */
  signature module ConfigSig {
    predicate isSink(Expr e);
  }

  /**
   * Constructs a successor relation over macro invocations and expressions
   * based on the given configuration.
   */
  module Make<ConfigSig Config> {
    private predicate hasChildSink(Expr e) { Config::isSink(e.getAChild*()) }

    private predicate rev(MacroInvocation mi) {
      hasChildSink(mi.getExpr())
      or
      exists(MacroInvocation mi1 | rev(mi1) | mi.getParentInvocation() = mi1)
    }

    private predicate isSource(MacroInvocation mi) {
      rev(mi) and
      not exists(MacroInvocation mi0 | rev(mi0) | mi0.getParentInvocation() = mi)
    }

    private predicate fwd(MacroInvocation mi) {
      rev(mi) and
      (
        isSource(mi)
        or
        exists(MacroInvocation mi0 | fwd(mi0) | mi0.getParentInvocation() = mi)
      )
    }

    private newtype TNode =
      TMacroInvocationNode(MacroInvocation mi) { fwd(mi) } or
      TExprNode(Expr e) {
        hasChildSink(e) and
        (
          exists(MacroInvocation mi |
            fwd(mi) and
            mi.getExpr() = e
          )
          or
          // Handle empty paths (i.e., the expression does not have any macros)
          not exists(MacroInvocation mi | mi.getExpr() = e)
        )
      }

    /**
     * A node in the path graph. A node is either a macro invocation or a sink
     * expression.
     */
    abstract private class NodeImpl extends TNode {
      /** Gets the macro invocation associated with this node, if any. */
      abstract MacroInvocation getMacroInvocation();

      /** Gets the expression associated with this node, if any. */
      abstract Expr getExpr();

      /** Gets the string representation of this node. */
      abstract string toString();

      /** Gets the location of this node. */
      abstract Location getLocation();
    }

    final class Node = NodeImpl;

    private class MacroInvocationNode extends NodeImpl, TMacroInvocationNode {
      MacroInvocation mi;

      MacroInvocationNode() { this = TMacroInvocationNode(mi) }

      override MacroInvocation getMacroInvocation() { result = mi }

      override Expr getExpr() { none() }

      override Location getLocation() { result = mi.getMacro().getLocation() }

      final override string toString() { result = this.getMacroInvocation().toString() }
    }

    private class ExprNode extends NodeImpl, TExprNode {
      Expr e;

      ExprNode() { this = TExprNode(e) }

      override Expr getExpr() { result = e }

      override MacroInvocation getMacroInvocation() {
        result = any(MacroInvocation mi | mi.getExpr() = e)
      }

      override Location getLocation() { result = e.getLocation() }

      final override string toString() { result = e.toString() }
    }

    private predicate steps(Node n1, Node n2) {
      exists(MacroInvocation mi | n1.(MacroInvocationNode).getMacroInvocation() = mi |
        mi.getParentInvocation() = n2.(MacroInvocationNode).getMacroInvocation()
        or
        not exists(mi.getParentInvocation()) and
        exists(ExprNode en | en = n2 |
          mi = en.getMacroInvocation()
          or
          // Handle empty paths
          not exists(en.getMacroInvocation()) and
          en.getExpr() = mi.getExpr()
        )
      )
    }

    private predicate isSinkNode(Node n) { hasChildSink(n.(ExprNode).getExpr()) }

    private predicate isSourceNode(Node n) {
      isSource(n.(MacroInvocationNode).getMacroInvocation())
      or
      not exists(any(MacroInvocationNode invocation).getMacroInvocation()) and
      isSinkNode(n)
    }

    private predicate stepsPlus(Node n1, Node n2) =
      doublyBoundedFastTC(steps/2, isSourceNode/1, isSinkNode/1)(n1, n2)

    private predicate stepsStar(Node n1, Node n2) {
      stepsPlus(n1, n2)
      or
      // Handle empty paths
      n1 = n2 and
      isSourceNode(n1) and
      isSinkNode(n2)
    }

    predicate flowsTo(Node n, ExprNode n2, Expr e, boolean exact) {
      stepsStar(n, n2) and
      Config::isSink(e) and
      (
        n2.getExpr() = e and
        exact = true
        or
        n2.getExpr().getAChild+() = e and
        exact = false
      )
    }

    /**
     * Provides the query predicates needed to include a graph in a path-problem
     * query.
     */
    module PathGraph {
      query predicate edges(Node n1, Node n2) {
        steps(n1, n2)
        or
        // Handle empty paths
        isSourceNode(n1) and
        isSinkNode(n2) and
        n1 = n2
      }
    }
  }
}
