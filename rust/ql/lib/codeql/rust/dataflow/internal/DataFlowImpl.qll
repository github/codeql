/**
 * Provides Rust-specific definitions for use in the data flow library.
 */

private import codeql.util.Void
private import codeql.util.Unit
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import rust
private import SsaImpl as SsaImpl
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.Ssa

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned from a
 * callable.
 *
 * The only return kind is a "normal" return from a `return` statement or an
 * expression body.
 */
final class ReturnKind extends TNormalReturnKind {
  string toString() { result = "return" }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
final class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   */
  CfgScope asCfgScope() { this = TCfgScope(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = this.asCfgScope().toString() }

  /** Gets the location of this callable. */
  Location getLocation() { result = this.asCfgScope().getLocation() }
}

final class DataFlowCall extends TDataFlowCall {
  private CallExprBaseCfgNode call;

  DataFlowCall() { this = TCall(call) }

  /** Gets the underlying call in the CFG, if any. */
  CallExprCfgNode asCallExprCfgNode() { result = call }

  MethodCallExprCfgNode asMethodCallExprCfgNode() { result = call }

  CallExprBaseCfgNode asCallBaseExprCfgNode() { result = call }

  DataFlowCallable getEnclosingCallable() {
    result = TCfgScope(call.getExpr().getEnclosingCfgScope())
  }

  string toString() { result = this.asCallBaseExprCfgNode().toString() }

  Location getLocation() { result = this.asCallBaseExprCfgNode().getLocation() }
}

/**
 * The position of a parameter or an argument in a function or call.
 *
 * As there is a 1-to-1 correspondence between parameter positions and
 * arguments positions in Rust we use the same type for both.
 */
final class ParameterPosition extends TParameterPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalParameterPosition(result) }

  /** Holds if this position represents the `self` position. */
  predicate isSelf() { this = TSelfParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    result = this.getPosition().toString()
    or
    result = "self" and this.isSelf()
  }

  ParamBase getParameterIn(ParamList ps) {
    result = ps.getParam(this.getPosition())
    or
    result = ps.getSelfParam() and this.isSelf()
  }
}

/** Holds if `arg` is an argument of `call` at the position `pos`. */
private predicate isArgumentForCall(ExprCfgNode arg, CallExprBaseCfgNode call, ParameterPosition pos) {
  arg = call.getArgument(pos.getPosition())
  or
  // The self argument in a method call.
  arg = call.(MethodCallExprCfgNode).getReceiver() and pos.isSelf()
}

module Node {
  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  abstract class Node extends TNode {
    /** Gets the location of this node. */
    abstract Location getLocation();

    /** Gets a textual representation of this node. */
    abstract string toString();

    /**
     * Gets the expression that corresponds to this node, if any.
     */
    ExprCfgNode asExpr() { none() }

    /**
     * Gets the pattern that corresponds to this node, if any.
     */
    PatCfgNode asPat() { none() }

    /** Gets the enclosing callable. */
    DataFlowCallable getEnclosingCallable() { result = TCfgScope(this.getCfgScope()) }

    /** Do not call: use `getEnclosingCallable()` instead. */
    abstract CfgScope getCfgScope();

    /**
     * Gets the control flow node that corresponds to this data flow node.
     */
    CfgNode getCfgNode() { none() }

    /**
     * Gets this node's underlying SSA definition, if any.
     */
    Ssa::Definition asDefinition() { none() }
  }

  /** A node type that is not implemented. */
  final class NaNode extends Node {
    NaNode() { none() }

    override CfgScope getCfgScope() { none() }

    override string toString() { result = "N/A" }

    override Location getLocation() { none() }
  }

  /** A data flow node that corresponds directly to a CFG node for an AST node. */
  abstract class AstCfgFlowNode extends Node {
    AstCfgNode n;

    final override CfgNode getCfgNode() { result = n }

    final override CfgScope getCfgScope() { result = n.getAstNode().getEnclosingCfgScope() }

    final override Location getLocation() { result = n.getAstNode().getLocation() }

    final override string toString() { result = n.getAstNode().toString() }
  }

  /**
   * A node in the data flow graph that corresponds to an expression in the
   * AST.
   *
   * Note that because of control flow splitting, one `Expr` may correspond
   * to multiple `ExprNode`s, just like it may correspond to multiple
   * `ControlFlow::Node`s.
   */
  class ExprNode extends AstCfgFlowNode, TExprNode {
    override ExprCfgNode n;

    ExprNode() { this = TExprNode(n) }

    override ExprCfgNode asExpr() { result = n }
  }

  final class PatNode extends AstCfgFlowNode, TPatNode {
    override PatCfgNode n;

    PatNode() { this = TPatNode(n) }

    override PatCfgNode asPat() { result = n }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  final class ParameterNode extends AstCfgFlowNode, TParameterNode {
    override ParamBaseCfgNode n;

    ParameterNode() { this = TParameterNode(n) }

    /** Gets the parameter in the CFG that this node corresponds to. */
    ParamBaseCfgNode getParameter() { result = n }
  }

  final class ArgumentNode extends ExprNode {
    ArgumentNode() { isArgumentForCall(n, _, _) }
  }

  /** An SSA node. */
  class SsaNode extends Node, TSsaNode {
    SsaImpl::DataFlowIntegration::SsaNode node;
    SsaImpl::DefinitionExt def;

    SsaNode() {
      this = TSsaNode(node) and
      def = node.getDefinitionExt()
    }

    override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }

    SsaImpl::DefinitionExt getDefinitionExt() { result = def }

    override Location getLocation() { result = node.getLocation() }

    override string toString() { result = "[SSA] " + node.toString() }
  }

  /** A data flow node that represents a value returned by a callable. */
  final class ReturnNode extends ExprNode {
    ReturnNode() { this.getCfgNode().getASuccessor() instanceof AnnotatedExitCfgNode }

    ReturnKind getKind() { any() }
  }

  /** A data-flow node that represents the output of a call. */
  abstract class OutNode extends Node, ExprNode {
    /** Gets the underlying call for this node. */
    abstract DataFlowCall getCall();
  }

  final private class ExprOutNode extends ExprNode, OutNode {
    ExprOutNode() { this.asExpr() instanceof CallExprBaseCfgNode }

    /** Gets the underlying call CFG node that includes this out node. */
    override DataFlowCall getCall() { result.asCallBaseExprCfgNode() = this.getCfgNode() }
  }

  /**
   * A node associated with an object after an operation that might have
   * changed its state.
   *
   * This can be either the argument to a callable after the callable returns
   * (which might have mutated the argument), or the qualifier of a field after
   * an update to the field.
   *
   * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
   * to the value before the update.
   */
  final class PostUpdateNode extends Node, TExprPostUpdateNode {
    private ExprCfgNode n;

    PostUpdateNode() { this = TExprPostUpdateNode(n) }

    /** Gets the node before the state update. */
    Node getPreUpdateNode() { result = TExprNode(n) }

    final override CfgScope getCfgScope() { result = n.getScope() }

    final override Location getLocation() { result = n.getLocation() }

    final override string toString() { result = "[post] " + n.toString() }
  }

  final class CastNode = NaNode;
}

final class Node = Node::Node;

/** Provides logic related to SSA. */
module SsaFlow {
  private module SsaFlow = SsaImpl::DataFlowIntegration;

  private Node::ParameterNode toParameterNode(ParamCfgNode p) {
    result.(Node::ParameterNode).getParameter() = p
  }

  /** Converts a control flow node into an SSA control flow node. */
  SsaFlow::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(SsaFlow::ExprNode).getExpr() = n.asExpr()
    or
    result.(SsaFlow::ExprPostUpdateNode).getExpr() =
      n.(Node::PostUpdateNode).getPreUpdateNode().asExpr()
    or
    n = toParameterNode(result.(SsaFlow::ParameterNode).getParameter())
  }

  predicate localFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
    SsaFlow::localFlowStep(def, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    SsaFlow::localMustFlowStep(def, asNode(nodeFrom), asNode(nodeTo))
  }
}

/**
 * Gets a node that may execute last in `n`, and which, when it executes last,
 * will be the value of `n`.
 */
private ExprCfgNode getALastEvalNode(ExprCfgNode e) {
  e = any(IfExprCfgNode n | result = [n.getThen(), n.getElse()]) or
  result = e.(LoopExprCfgNode).getLoopBody() or
  result = e.(ReturnExprCfgNode).getExpr() or
  result = e.(BreakExprCfgNode).getExpr() or
  result = e.(BlockExprCfgNode).getTailExpr() or
  result = e.(MatchExprCfgNode).getArmExpr(_) or
  result.(BreakExprCfgNode).getTarget() = e
}

module LocalFlow {
  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.getCfgNode() = getALastEvalNode(nodeTo.getCfgNode())
    or
    exists(LetStmtCfgNode s |
      nodeFrom.getCfgNode() = s.getInitializer() and
      nodeTo.getCfgNode() = s.getPat()
    )
    or
    // An edge from a pattern/expression to its corresponding SSA definition.
    nodeFrom.(Node::AstCfgFlowNode).getCfgNode() =
      nodeTo.(Node::SsaNode).getDefinitionExt().(Ssa::WriteDefinition).getControlFlowNode()
    or
    nodeFrom.(Node::ParameterNode).getParameter().(ParamCfgNode).getPat() = nodeTo.asPat()
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    or
    exists(AssignmentExprCfgNode a |
      a.getRhs() = nodeFrom.getCfgNode() and
      a.getLhs() = nodeTo.getCfgNode()
    )
    or
    exists(MatchExprCfgNode match |
      nodeFrom.asExpr() = match.getScrutinee() and
      nodeTo.asPat() = match.getArmPat(_)
    )
    or
    nodeFrom.asPat().(OrPatCfgNode).getAPat() = nodeTo.asPat()
  }
}

private import codeql.util.Option

private class CrateOrigin extends string {
  CrateOrigin() {
    this = [any(Item i).getCrateOrigin(), any(Resolvable r).getResolvedCrateOrigin()]
  }
}

private class CrateOriginOption = Option<CrateOrigin>::Option;

pragma[nomagic]
private predicate hasExtendedCanonicalPath(Item i, CrateOriginOption crate, string path) {
  path = i.getExtendedCanonicalPath() and
  (
    crate.asSome() = i.getCrateOrigin()
    or
    crate.isNone() and
    not i.hasCrateOrigin()
  )
}

pragma[nomagic]
private predicate variantHasExtendedCanonicalPath(
  Enum e, Variant v, CrateOriginOption crate, string path, string name
) {
  hasExtendedCanonicalPath(e, crate, path) and
  v = e.getVariantList().getAVariant() and
  name = v.getName().getText()
}

pragma[nomagic]
private predicate resolveExtendedCanonicalPath(Resolvable r, CrateOriginOption crate, string path) {
  path = r.getResolvedPath() and
  (
    crate.asSome() = r.getResolvedCrateOrigin()
    or
    crate.isNone() and
    not r.hasResolvedCrateOrigin()
  )
}

/**
 * A path to a value contained in an object. For example a field name of a struct.
 */
abstract class Content extends TContent {
  /** Gets a textual representation of this content. */
  abstract string toString();
}

/** A canonical path pointing to an enum variant. */
private class VariantCanonicalPath extends MkVariantCanonicalPath {
  CrateOriginOption crate;
  string path;
  string name;

  VariantCanonicalPath() { this = MkVariantCanonicalPath(crate, path, name) }

  /** Gets the underlying variant. */
  Variant getVariant() { variantHasExtendedCanonicalPath(_, result, crate, path, name) }

  string toString() { result = name }

  Location getLocation() { result = this.getVariant().getLocation() }
}

/**
 * A variant of an `enum`. In addition to the variant itself, this also includes the
 * position (for tuple variants) or the field name (for record variants).
 */
abstract class VariantContent extends Content { }

/** A tuple variant. */
private class VariantPositionContent extends VariantContent, TVariantPositionContent {
  private VariantCanonicalPath v;
  private int pos_;

  VariantPositionContent() { this = TVariantPositionContent(v, pos_) }

  VariantCanonicalPath getVariantCanonicalPath(int pos) { result = v and pos = pos_ }

  final override string toString() {
    // only print indices when the arity is > 1
    if exists(TVariantPositionContent(v, 1))
    then result = v.toString() + "(" + pos_ + ")"
    else result = v.toString()
  }
}

/** A record variant. */
private class VariantFieldContent extends VariantContent, TVariantFieldContent {
  private VariantCanonicalPath v;
  private string field_;

  VariantFieldContent() { this = TVariantFieldContent(v, field_) }

  VariantCanonicalPath getVariantCanonicalPath(string field) { result = v and field = field_ }

  final override string toString() {
    // only print field when the arity is > 1
    if strictcount(string f | exists(TVariantFieldContent(v, f))) > 1
    then result = v.toString() + "{" + field_ + "}"
    else result = v.toString()
  }
}

/** A canonical path pointing to a struct. */
private class StructCanonicalPath extends MkStructCanonicalPath {
  CrateOriginOption crate;
  string path;

  StructCanonicalPath() { this = MkStructCanonicalPath(crate, path) }

  /** Gets the underlying struct. */
  Struct getStruct() { hasExtendedCanonicalPath(result, crate, path) }

  string toString() { result = this.getStruct().getName().getText() }

  Location getLocation() { result = this.getStruct().getLocation() }
}

/** Content stored in a field on a struct. */
private class StructFieldContent extends Content, TStructFieldContent {
  private StructCanonicalPath s;
  private string field_;

  StructFieldContent() { this = TStructFieldContent(s, field_) }

  StructCanonicalPath getStructCanonicalPath(string field) { result = s and field = field_ }

  override string toString() { result = s.toString() + "." + field_.toString() }
}

/**
 * Content stored at a position in a tuple.
 *
 * NOTE: Unlike `struct`s and `enum`s tuples are structural and not nominal,
 * hence we don't store a canonical path for them.
 */
private class TuplePositionContent extends Content, TTuplePositionContent {
  private int pos;

  TuplePositionContent() { this = TTuplePositionContent(pos) }

  int getPosition() { result = pos }

  override string toString() { result = "tuple." + pos.toString() }
}

/** Holds if `access` indexes a tuple at an index corresponding to `c`. */
private predicate fieldTuplePositionContent(FieldExprCfgNode access, TuplePositionContent c) {
  access.getNameRef().getText().toInt() = c.getPosition()
}

/** A value that represents a set of `Content`s. */
abstract class ContentSet extends TContentSet {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets a content that may be stored into when storing into this set. */
  abstract Content getAStoreContent();

  /** Gets a content that may be read from when reading from this set. */
  abstract Content getAReadContent();
}

final private class SingletonContentSet extends ContentSet, TSingletonContentSet {
  private Content c;

  SingletonContentSet() { this = TSingletonContentSet(c) }

  Content getContent() { result = c }

  override string toString() { result = c.toString() }

  override Content getAStoreContent() { result = c }

  override Content getAReadContent() { result = c }
}

// Defines a set of aliases needed for the `RustDataFlow` module
private module Aliases {
  class DataFlowCallableAlias = DataFlowCallable;

  class ReturnKindAlias = ReturnKind;

  class DataFlowCallAlias = DataFlowCall;

  class ParameterPositionAlias = ParameterPosition;

  class ContentAlias = Content;

  class ContentSetAlias = ContentSet;
}

module RustDataFlow implements InputSig<Location> {
  private import Aliases

  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  final class Node = Node::Node;

  final class ParameterNode = Node::ParameterNode;

  final class ArgumentNode = Node::ArgumentNode;

  final class ReturnNode = Node::ReturnNode;

  final class OutNode = Node::OutNode;

  final class PostUpdateNode = Node::PostUpdateNode;

  final class CastNode = Node::NaNode;

  /** Holds if `p` is a parameter of `c` at the position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.getCfgNode().getAstNode() = pos.getParameterIn(c.asCfgScope().(Callable).getParamList())
  }

  /** Holds if `n` is an argument of `c` at the position `pos`. */
  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    isArgumentForCall(n.getCfgNode(), call.asCallBaseExprCfgNode(), pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) { result = node.getEnclosingCallable() }

  DataFlowType getNodeType(Node node) { any() }

  predicate nodeIsHidden(Node node) { node instanceof Node::SsaNode }

  class DataFlowExpr = ExprCfgNode;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.asExpr() = e }

  final class DataFlowCall = DataFlowCallAlias;

  final class DataFlowCallable = DataFlowCallableAlias;

  final class ReturnKind = ReturnKindAlias;

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall call) {
    result.asCfgScope() = call.asCallBaseExprCfgNode().getCallExprBase().getStaticTarget()
  }

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    call = result.getCall() and exists(kind)
  }

  // NOTE: For now we use the type `Unit` and do not benefit from type
  // information in the data flow analysis.
  final class DataFlowType extends Unit {
    string toString() { result = "" }
  }

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

  class Content = ContentAlias;

  class ContentSet = ContentSetAlias;

  predicate forceHighPrecision(Content c) { none() }

  final class ContentApprox = Content; // TODO: Implement if needed

  ContentApprox getContentApprox(Content c) { result = c }

  class ParameterPosition = ParameterPositionAlias;

  class ArgumentPosition = ParameterPosition;

  /**
   * Holds if the parameter position `ppos` matches the argument position
   * `apos`.
   */
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  /**
   * Holds if there is a simple local flow step from `node1` to `node2`. These
   * are the value-preserving intra-callable flow steps.
   */
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo) and
    model = ""
  }

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2) { none() }

  /** Holds if path `p` resolves to struct `s`. */
  private predicate pathResolveToStructCanonicalPath(Path p, StructCanonicalPath s) {
    exists(CrateOriginOption crate, string path |
      resolveExtendedCanonicalPath(p, crate, path) and
      s = MkStructCanonicalPath(crate, path)
    )
  }

  /** Holds if path `p` resolves to variant `v`. */
  private predicate pathResolveToVariantCanonicalPath(Path p, VariantCanonicalPath v) {
    exists(CrateOriginOption crate, string path |
      resolveExtendedCanonicalPath(p.getQualifier(), crate, path) and
      v = MkVariantCanonicalPath(crate, path, p.getPart().getNameRef().getText())
    )
    or
    // TODO: Remove once library types are extracted
    not p.hasQualifier() and
    v = MkVariantCanonicalPath(_, "crate::std::option::Option", p.getPart().getNameRef().getText())
    or
    // TODO: Remove once library types are extracted
    not p.hasQualifier() and
    v = MkVariantCanonicalPath(_, "crate::std::result::Result", p.getPart().getNameRef().getText())
  }

  /** Holds if `p` destructs an enum variant `v`. */
  pragma[nomagic]
  private predicate tupleVariantDestruction(TupleStructPat p, VariantCanonicalPath v) {
    pathResolveToVariantCanonicalPath(p.getPath(), v)
  }

  /** Holds if `p` destructs an enum variant `v`. */
  pragma[nomagic]
  private predicate recordVariantDestruction(RecordPat p, VariantCanonicalPath v) {
    pathResolveToVariantCanonicalPath(p.getPath(), v)
  }

  /** Holds if `p` destructs a struct `s`. */
  pragma[nomagic]
  private predicate structDestruction(RecordPat p, StructCanonicalPath s) {
    pathResolveToStructCanonicalPath(p.getPath(), s)
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet cs, Node node2) {
    exists(Content c | c = cs.(SingletonContentSet).getContent() |
      exists(TupleStructPatCfgNode pat, int pos |
        pat = node1.asPat() and
        tupleVariantDestruction(pat.getPat(),
          c.(VariantPositionContent).getVariantCanonicalPath(pos)) and
        node2.asPat() = pat.getField(pos)
      )
      or
      exists(RecordPatCfgNode pat, string field |
        pat = node1.asPat() and
        (
          // Pattern destructs a struct-like variant.
          recordVariantDestruction(pat.getPat(),
            c.(VariantFieldContent).getVariantCanonicalPath(field))
          or
          // Pattern destructs a struct.
          structDestruction(pat.getPat(), c.(StructFieldContent).getStructCanonicalPath(field))
        ) and
        node2.asPat() = pat.getFieldPat(field)
      )
      or
      exists(FieldExprCfgNode access |
        // Read of a tuple entry
        fieldTuplePositionContent(access, c) and
        // TODO: Handle read of a struct field.
        node1.asExpr() = access.getExpr() and
        node2.asExpr() = access
      )
    )
  }

  /** Holds if `ce` constructs an enum value of type `v`. */
  pragma[nomagic]
  private predicate tupleVariantConstruction(CallExpr ce, VariantCanonicalPath v) {
    pathResolveToVariantCanonicalPath(ce.getFunction().(PathExpr).getPath(), v)
  }

  /** Holds if `re` constructs an enum value of type `v`. */
  pragma[nomagic]
  private predicate recordVariantConstruction(RecordExpr re, VariantCanonicalPath v) {
    pathResolveToVariantCanonicalPath(re.getPath(), v)
  }

  /** Holds if `re` constructs a struct value of type `s`. */
  pragma[nomagic]
  private predicate structConstruction(RecordExpr re, StructCanonicalPath s) {
    pathResolveToStructCanonicalPath(re.getPath(), s)
  }

  private predicate tupleAssignment(Node node1, Node node2, TuplePositionContent c) {
    exists(AssignmentExprCfgNode assignment, FieldExprCfgNode access |
      assignment.getLhs() = access and
      fieldTuplePositionContent(access, c) and
      node1.asExpr() = assignment.getRhs() and
      node2.asExpr() = access.getExpr()
    )
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet cs, Node node2) {
    exists(Content c | c = cs.(SingletonContentSet).getContent() |
      exists(CallExprCfgNode call, int pos |
        tupleVariantConstruction(call.getCallExpr(),
          c.(VariantPositionContent).getVariantCanonicalPath(pos)) and
        node1.asExpr() = call.getArgument(pos) and
        node2.asExpr() = call
      )
      or
      exists(RecordExprCfgNode re, string field |
        (
          // Expression is for a struct-like enum variant.
          recordVariantConstruction(re.getRecordExpr(),
            c.(VariantFieldContent).getVariantCanonicalPath(field))
          or
          // Expression is for a struct.
          structConstruction(re.getRecordExpr(),
            c.(StructFieldContent).getStructCanonicalPath(field))
        ) and
        node1.asExpr() = re.getFieldExpr(field) and
        node2.asExpr() = re
      )
      or
      exists(TupleExprCfgNode tuple |
        node1.asExpr() = tuple.getField(c.(TuplePositionContent).getPosition()) and
        node2.asExpr() = tuple
      )
      or
      tupleAssignment(node1, node2.(PostUpdateNode).getPreUpdateNode(), c)
    )
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet cs) {
    tupleAssignment(_, n, cs.(SingletonContentSet).getContent())
  }

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet c) { none() }

  class NodeRegion instanceof Void {
    string toString() { result = "NodeRegion" }

    predicate contains(Node n) { none() }
  }

  /**
   * Holds if the nodes in `nr` are unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

  /**
   * Holds if flow is allowed to pass from parameter `p` and back to itself as a
   * side-effect, resulting in a summary from `p` to itself.
   *
   * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
   * by default as a heuristic.
   */
  predicate allowParameterReturnInSelf(ParameterNode p) { none() }

  /**
   * Holds if the value of `node2` is given by `node1`.
   *
   * This predicate is combined with type information in the following way: If
   * the data flow library is able to compute an improved type for `node1` then
   * it will also conclude that this type applies to `node2`. Vice versa, if
   * `node2` must be visited along a flow path, then any type known for `node2`
   * must also apply to `node1`.
   */
  predicate localMustFlowStep(Node node1, Node node2) {
    SsaFlow::localMustFlowStep(_, node1, node2)
  }

  class LambdaCallKind = Unit;

  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
    exists(Expr cl | cl = creation.asExpr().getExpr() and cl = c.asCfgScope() |
      cl instanceof ClosureExpr or cl instanceof AsyncBlockExpr
    ) and
    exists(kind)
  }

  /**
   * Holds if `call` is a lambda call of kind `kind` where `receiver` is the
   * invoked expression.
   */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
    receiver.asExpr() = call.asCallExprCfgNode().getFunction() and
    // All calls to complex expressions and local variable accesses are lambda call.
    exists(Expr f | f = receiver.asExpr().getExpr() |
      f instanceof PathExpr implies f = any(Variable v).getAnAccess()
    ) and
    exists(kind)
  }

  /** Extra data flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) { none() }

  predicate knownSinkModel(Node sink, string model) { none() }

  class DataFlowSecondLevelScope = Void;
}

import MakeImpl<Location, RustDataFlow>

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(ExprCfgNode n) or
    TParameterNode(ParamBaseCfgNode p) or
    TPatNode(PatCfgNode p) or
    TExprPostUpdateNode(ExprCfgNode e) {
      isArgumentForCall(e, _, _) or e = any(FieldExprCfgNode access).getExpr()
    } or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node)

  cached
  newtype TDataFlowCall = TCall(CallExprBaseCfgNode c)

  cached
  newtype TDataFlowCallable = TCfgScope(CfgScope scope)

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node::Node nodeFrom, Node::Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
  }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
    } or
    TSelfParameterPosition()

  cached
  newtype TVariantCanonicalPath =
    MkVariantCanonicalPath(CrateOriginOption crate, string path, string name) {
      variantHasExtendedCanonicalPath(_, _, crate, path, name)
      or
      // TODO: Remove once library types are extracted
      crate.isNone() and
      path = "crate::std::option::Option" and
      name = "Some"
      or
      // TODO: Remove once library types are extracted
      crate.isNone() and
      path = "crate::std::result::Result" and
      name = ["Ok", "Err"]
    }

  cached
  newtype TStructCanonicalPath =
    MkStructCanonicalPath(CrateOriginOption crate, string path) {
      exists(Struct s | hasExtendedCanonicalPath(s, crate, path))
    }

  cached
  newtype TContent =
    TVariantPositionContent(VariantCanonicalPath v, int pos) {
      pos in [0 .. v.getVariant().getFieldList().(TupleFieldList).getNumberOfFields() - 1]
      or
      // TODO: Remove once library types are extracted
      v = MkVariantCanonicalPath(_, "crate::std::option::Option", "Some") and
      pos = 0
      or
      // TODO: Remove once library types are extracted
      v = MkVariantCanonicalPath(_, "crate::std::result::Result", ["Ok", "Err"]) and
      pos = 0
    } or
    TVariantFieldContent(VariantCanonicalPath v, string field) {
      field = v.getVariant().getFieldList().(RecordFieldList).getAField().getName().getText()
    } or
    TTuplePositionContent(int pos) {
      pos in [0 .. max([
                any(TuplePat pat).getNumberOfFields(),
                any(FieldExpr access).getNameRef().getText().toInt()
              ]
          )]
    } or
    TStructFieldContent(StructCanonicalPath s, string field) {
      field = s.getStruct().getFieldList().(RecordFieldList).getAField().getName().getText()
    }

  cached
  newtype TContentSet = TSingletonContentSet(Content c)
}

import Cached
