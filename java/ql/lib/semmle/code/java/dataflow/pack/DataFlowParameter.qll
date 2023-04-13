signature module DataFlowParameter {
  class Node {
    /** Gets a textual representation of this element. */
    string toString();

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    );
  }

  class ReturnNode extends Node {
    ReturnKind getKind();
  }

  class OutNode extends Node;

  class PostUpdateNode extends Node {
    Node getPreUpdateNode();
  }

  class CastNode extends Node;

  predicate isParameterNode(Node p, DataFlowCallable c, ParameterPosition pos);

  predicate isArgumentNode(Node n, DataFlowCall call, ArgumentPosition pos);

  DataFlowCallable nodeGetEnclosingCallable(Node node);

  DataFlowType getNodeType(Node node);

  predicate nodeIsHidden(Node node);

  class DataFlowExpr;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) ;

  class DataFlowCall {
    /** Gets a textual representation of this element. */
    string toString();

    DataFlowCallable getEnclosingCallable();
  }

  class DataFlowCallable {
    /** Gets a textual representation of this element. */
    string toString();
  }

  class ReturnKind {
    /** Gets a textual representation of this element. */
    string toString();
  }

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c);

  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context.
   */
  predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c);

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx);

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind);

  class DataFlowType;

  string ppReprType(DataFlowType t);

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2);

  class Content {
    /** Gets a textual representation of this element. */
    string toString();
  }

  predicate forceHighPrecision(Content c);

  /**
   * An entity that represents a set of `Content`s.
   *
   * The set may be interpreted differently depending on whether it is
   * stored into (`getAStoreContent`) or read from (`getAReadContent`).
   */
  class ContentSet {
    /** Gets a content that may be stored into when storing into this set. */
    Content getAStoreContent();

    /** Gets a content that may be read from when reading from this set. */
    Content getAReadContent();
  }

  class ContentApprox {
    /** Gets a textual representation of this element. */
    string toString();
  }

  ContentApprox getContentApprox(Content c);

  class ParameterPosition {
    /** Gets a textual representation of this element. */
    string toString();
  }

  class ArgumentPosition;

  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos);

  predicate simpleLocalFlowStep(Node node1, Node node2);

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2);

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet c, Node node2);

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet c, Node node2);

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet c);

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet c);

  /**
   * Holds if the node `n` is unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(Node n, DataFlowCall call);

  default int accessPathLimit() { result = 5 }

  /**
   * Holds if flow is allowed to pass from parameter `p` and back to itself as a
   * side-effect, resulting in a summary from `p` to itself.
   *
   * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
   * by default as a heuristic.
   */
  // predicate allowParameterReturnInSelf(ParameterNode p);
  predicate allowParameterReturnInSelf(Node p);

  class LambdaCallKind;

  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c);

  /** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver);

  /** Extra data-flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue);

  /**
   * Gets an additional term that is added to the `join` and `branch` computations to reflect
   * an additional forward or backwards branching factor that is not taken into account
   * when calculating the (virtual) dispatch cost.
   *
   * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
   */
  //   int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p);
  int getAdditionalFlowIntoCallNodeTerm(Node arg, Node p);

  //   predicate golangSpecificParamArgFilter(DataFlowCall call, ParameterNode p, ArgumentNode arg);
  predicate golangSpecificParamArgFilter(DataFlowCall call, Node p, Node arg);
}
