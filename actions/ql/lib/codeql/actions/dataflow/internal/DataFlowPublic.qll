private import codeql.dataflow.DataFlow
private import codeql.actions.Ast
private import codeql.actions.Cfg as Cfg
private import codeql.Locations
private import DataFlowPrivate

class Node extends TNode {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  AstNode asExpr() { none() }
}

/**
 * Any Ast Expression.
 * UsesExpr, RunExpr, ArgumentExpr, VarAccessExpr, ...
 */
class ExprNode extends Node, TExprNode {
  private DataFlowExpr expr;

  ExprNode() { this = TExprNode(expr) }

  Cfg::Node getCfgNode() { result = expr }

  override string toString() { result = expr.toString() }

  override Location getLocation() { result = expr.getLocation() }

  override AstNode asExpr() { result = expr.getAstNode() }
}

/**
 * Reusable workflow input nodes
 */
class ParameterNode extends ExprNode {
  private Input input;

  ParameterNode() { this.asExpr() = input }

  predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    input = c.(ReusableWorkflow).getInput(pos) or
    input = c.(CompositeAction).getInput(pos)
  }

  override string toString() { result = "input " + input.toString() }

  override Location getLocation() { result = input.getLocation() }

  Input getInput() { result = input }
}

/**
 * A call to a data flow callable (Uses).
 */
class CallNode extends ExprNode {
  private DataFlowCall call;

  CallNode() { this.getCfgNode() instanceof DataFlowCall }

  DataFlowCallable getCalleeNode() { result = viableCallable(this.getCfgNode()) }
}

/**
 * An argument to a Uses step (call).
 */
class ArgumentNode extends ExprNode {
  ArgumentNode() { this.getCfgNode().getAstNode() = any(Uses e).getArgumentExpr(_) }

  predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    this.getCfgNode() = call.(Cfg::Node).getASuccessor+() and
    call.(Cfg::Node).getAstNode() =
      any(Uses e | e.getArgumentExpr(pos) = this.getCfgNode().getAstNode())
  }
}

/**
 * Reusable workflow output nodes
 */
class ReturnNode extends ExprNode {
  private Outputs outputs;

  ReturnNode() {
    this.asExpr() = outputs and
    (
      exists(ReusableWorkflow w | w.getOutputs() = outputs) or
      exists(CompositeAction a | a.getOutputs() = outputs)
    )
  }

  ReturnKind getKind() { result = TNormalReturn() }

  override string toString() { result = "output " + outputs.toString() }

  override Location getLocation() { result = outputs.getLocation() }
}

/** Gets the node corresponding to `e`. */
Node exprNode(DataFlowExpr e) { result = TExprNode(e) }

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, the contents of an array or pointer.
 */
class Content extends TContent {
  /** Gets the type of the contained data for the purpose of type pruning. */
  DataFlowType getType() { any() }

  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    filepath = "" and startline = 0 and startcolumn = 0 and endline = 0 and endcolumn = 0
  }
}

/** A field of an object, for example an instance variable. */
class FieldContent extends Content, TFieldContent {
  private string name;

  FieldContent() { this = TFieldContent(name) }

  /** Gets the name of the field. */
  string getName() { result = name }

  override string toString() { result = name }
}

predicate hasLocalFlow(Node n1, Node n2) {
  n1 = n2 or
  simpleLocalFlowStep(n1, n2, _) or
  exists(ContentSet c | ctxFieldReadStep(n1, n2, c))
}

predicate hasLocalFlowExpr(AstNode n1, AstNode n2) {
  exists(Node dn1, Node dn2 |
    dn1.asExpr() = n1 and
    dn2.asExpr() = n2 and
    hasLocalFlow(dn1, dn2)
  )
}
