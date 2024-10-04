private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT
base private import java as B
overlay private import java as O

module DataFlow {
  import DF::DataFlowMake<Location, JavaDataFlow>
  import JavaDataFlow::Public
}

module TaintTracking {
  import TT::TaintFlowMake<Location, JavaDataFlow, JavaTaintTracking>
}

private newtype TLocation =
  TBaseLocation(B::Location loc) or
  TOverlayLocation(O::Location loc)

private class Location extends TLocation {
  B::Location asBase() { this = TBaseLocation(result) }

  O::Location asOverlay() { this = TOverlayLocation(result) }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() {
    result = this.asBase().getStartLine() or result = this.asOverlay().getStartLine()
  }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() {
    result = this.asBase().getStartColumn() or result = this.asOverlay().getStartColumn()
  }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { result = this.asBase().getEndLine() or result = this.asOverlay().getEndLine() }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() {
    result = this.asBase().getEndColumn() or result = this.asOverlay().getEndColumn()
  }

  /** Gets a textual representation of this location. */
  string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startColumn` of line `startLine` to
   * column `endColumn` of line `endLine` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asBase().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
    this.asOverlay().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private module BaseDf {
  base import semmle.code.java.dataflow.internal.DataFlowNodes
  base import semmle.code.java.dataflow.internal.DataFlowPrivate
  base import semmle.code.java.dataflow.internal.DataFlowUtil
  base import semmle.code.java.dataflow.internal.DataFlowDispatch
  import Public
  import Private
}

private module OverlayDf {
  overlay import semmle.code.java.dataflow.internal.DataFlowNodes
  overlay import semmle.code.java.dataflow.internal.DataFlowPrivate
  overlay import semmle.code.java.dataflow.internal.DataFlowUtil
  overlay import semmle.code.java.dataflow.internal.DataFlowDispatch
  import Public
  import Private
}

private string overlayFile() {
  exists(O::Expr e |
    exists(e.getEnclosingCallable()) and e.getLocation().hasLocationInfo(result, _, _, _, _)
  )
}

private predicate baseType(BaseDf::DataFlowType t, string package, string name, boolean inOverlay) {
  not t instanceof B::LocalClassOrInterface and
  not t instanceof B::AnonymousClass and
  t.hasQualifiedName(package, name) and
  if t.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
  then inOverlay = true
  else inOverlay = false
}

private predicate overlayType(
  OverlayDf::DataFlowType t, string package, string name, boolean inOverlay
) {
  not t instanceof O::LocalClassOrInterface and
  not t instanceof O::AnonymousClass and
  t.hasQualifiedName(package, name) and
  if t.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
  then inOverlay = true
  else inOverlay = false
}

private predicate updatedType(OverlayDf::DataFlowType ot, BaseDf::DataFlowType bt) {
  exists(string package, string name |
    overlayType(ot, package, name, true) and
    baseType(bt, package, name, true)
  )
}

private predicate baseTypeRef(OverlayDf::DataFlowType ot, BaseDf::DataFlowType bt) {
  exists(string package, string name |
    overlayType(ot, package, name, false) and
    baseType(bt, package, name, false)
  )
}

private predicate baseMember(
  B::Member m, string package, string type, string name, string sig, boolean inOverlay
) {
  baseType(m.getDeclaringType().getErasure(), package, type, inOverlay) and
  m.getName() = name and
  if m instanceof B::Callable
  then sig = m.(B::Callable).getSignature() and m.(B::Callable).isSourceDeclaration()
  else sig = ""
}

private predicate overlayMember(
  O::Member m, string package, string type, string name, string sig, boolean inOverlay
) {
  overlayType(m.getDeclaringType().getErasure(), package, type, inOverlay) and
  m.getName() = name and
  if m instanceof O::Callable
  then sig = m.(O::Callable).getSignature() and m.(O::Callable).isSourceDeclaration()
  else sig = ""
}

private predicate updatedMember(O::Member om, B::Member bm) {
  exists(string package, string type, string name, string sig |
    overlayMember(om, package, type, name, sig, true) and
    baseMember(bm, package, type, name, sig, true)
  )
}

private predicate baseMemberRef(O::Member om, B::Member bm) {
  exists(string package, string type, string name, string sig |
    overlayMember(om, package, type, name, sig, false) and
    baseMember(bm, package, type, name, sig, false)
  )
}

private module JavaDataFlow implements DF::InputSig<Location> {
  private newtype TNode =
    TBaseNode(BaseDf::Node node) {
      not node.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
    } or
    TOverlayNode(OverlayDf::Node node) {
      not baseMemberRef(node.(OverlayDf::FieldValueNode).getField(), _)
    }

  additional module Public {
    class Node extends TNode {
      BaseDf::Node asBase() { this = TBaseNode(result) }

      OverlayDf::Node asOverlay() { this = TOverlayNode(result) }

      string toString() {
        result = this.asBase().toString() or result = this.asOverlay().toString()
      }

      Location getLocation() {
        result.asBase() = this.asBase().getLocation() or
        result.asOverlay() = this.asOverlay().getLocation()
      }
    }
  }

  import Public

  private Node nodeFromBase(BaseDf::Node node) {
    result.asBase() = node
    or
    exists(OverlayDf::FieldValueNode on |
      updatedMember(on.getField(), node.(BaseDf::FieldValueNode).getField())
    |
      result.asOverlay() = on
    )
  }

  private Node nodeFromOverlay(OverlayDf::Node node) {
    result.asOverlay() = node
    or
    exists(BaseDf::FieldValueNode bn |
      baseMemberRef(node.(OverlayDf::FieldValueNode).getField(), bn.getField())
    |
      result.asBase() = bn
    )
  }

  class ParameterNode extends Node {
    ParameterNode() {
      this.asBase() instanceof BaseDf::ParameterNode or
      this.asOverlay() instanceof OverlayDf::ParameterNode
    }
  }

  class ArgumentNode extends Node {
    ArgumentNode() {
      this.asBase() instanceof BaseDf::ArgumentNode or
      this.asOverlay() instanceof OverlayDf::ArgumentNode
    }
  }

  class ReturnNode extends Node {
    ReturnNode() {
      this.asBase() instanceof BaseDf::ReturnNode or
      this.asOverlay() instanceof OverlayDf::ReturnNode
    }

    ReturnKind getKind() { any() }
  }

  class OutNode extends Node {
    OutNode() {
      this.asBase() instanceof BaseDf::OutNode or this.asOverlay() instanceof OverlayDf::OutNode
    }
  }

  class PostUpdateNode extends Node {
    PostUpdateNode() {
      this.asBase() instanceof BaseDf::PostUpdateNode or
      this.asOverlay() instanceof OverlayDf::PostUpdateNode
    }

    Node getPreUpdateNode() {
      result.asBase() = this.asBase().(BaseDf::PostUpdateNode).getPreUpdateNode() or
      result.asOverlay() = this.asOverlay().(OverlayDf::PostUpdateNode).getPreUpdateNode()
    }
  }

  class CastNode extends Node {
    CastNode() {
      this.asBase() instanceof BaseDf::CastNode or this.asOverlay() instanceof OverlayDf::CastNode
    }
  }

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    BaseDf::isParameterNode(p.asBase(), c.asBase(), pos) or
    OverlayDf::isParameterNode(p.asOverlay(), c.asOverlay(), pos)
  }

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    BaseDf::isArgumentNode(n.asBase(), call.asBase(), pos) or
    OverlayDf::isArgumentNode(n.asOverlay(), call.asOverlay(), pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) {
    result.asBase() = BaseDf::nodeGetEnclosingCallable(node.asBase()) or
    result.asOverlay() = OverlayDf::nodeGetEnclosingCallable(node.asOverlay())
  }

  DataFlowType getNodeType(Node node) {
    result = fromBase(BaseDf::getNodeType(node.asBase())) or
    result = fromOverlay(OverlayDf::getNodeType(node.asOverlay()))
  }

  predicate nodeIsHidden(Node node) {
    BaseDf::nodeIsHidden(node.asBase()) or OverlayDf::nodeIsHidden(node.asOverlay())
  }

  private newtype TDataFlowExpr =
    TBaseDataFlowExpr(BaseDf::DataFlowExpr e) {
      not e.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
    } or
    TOverlayDataFlowExpr(OverlayDf::DataFlowExpr e)

  class DataFlowExpr extends TDataFlowExpr {
    BaseDf::DataFlowExpr asBase() { this = TBaseDataFlowExpr(result) }

    OverlayDf::DataFlowExpr asOverlay() { this = TOverlayDataFlowExpr(result) }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }

    Location getLocation() {
      result.asBase() = this.asBase().getLocation() or
      result.asOverlay() = this.asOverlay().getLocation()
    }
  }

  Node exprNode(DataFlowExpr e) {
    result.asBase() = BaseDf::exprNode(e.asBase()) or
    result.asOverlay() = OverlayDf::exprNode(e.asOverlay())
  }

  private newtype TDataFlowCall =
    TBaseDataFlowCall(BaseDf::DataFlowCall c) {
      not c.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
    } or
    TOverlayDataFlowCall(OverlayDf::DataFlowCall c)

  class DataFlowCall extends TDataFlowCall {
    BaseDf::DataFlowCall asBase() { this = TBaseDataFlowCall(result) }

    OverlayDf::DataFlowCall asOverlay() { this = TOverlayDataFlowCall(result) }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }

    Location getLocation() {
      result.asBase() = this.asBase().getLocation() or
      result.asOverlay() = this.asOverlay().getLocation()
    }

    DataFlowCallable getEnclosingCallable() {
      result.asBase() = this.asBase().getEnclosingCallable() or
      result.asOverlay() = this.asOverlay().getEnclosingCallable()
    }
  }

  private newtype TDataFlowCallable =
    TBaseDataFlowCallable(BaseDf::DataFlowCallable c) {
      not c.getLocation().hasLocationInfo(overlayFile(), _, _, _, _)
    } or
    TOverlayDataFlowCallable(OverlayDf::DataFlowCallable c)

  class DataFlowCallable extends TDataFlowCallable {
    BaseDf::DataFlowCallable asBase() { this = TBaseDataFlowCallable(result) }

    OverlayDf::DataFlowCallable asOverlay() { this = TOverlayDataFlowCallable(result) }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }

    Location getLocation() {
      result.asBase() = this.asBase().getLocation() or
      result.asOverlay() = this.asOverlay().getLocation()
    }
  }

  class ReturnKind = BaseDf::ReturnKind; // singleton

  private module OverlayToBaseDispatch {
    base private import semmle.code.java.dispatch.VirtualDispatch as BaseVd
    overlay private import semmle.code.java.dataflow.TypeFlow as OverlayTypeFlow

    private predicate qualType0(O::VirtualMethodCall ma, O::RefType t, boolean exact) {
      OverlayTypeFlow::exprTypeFlow(ma.getQualifier(), t, exact)
    }

    private predicate qualType(O::VirtualMethodCall ma, O::RefType t, boolean exact) {
      qualType0(ma, t, exact)
      or
      not qualType0(ma, _, _) and
      exact = false and
      (
        ma.getQualifier().getType() = t
        or
        not exists(ma.getQualifier()) and
        (
          ma.isOwnMethodCall() and t = ma.getEnclosingCallable().getDeclaringType()
          or
          ma.isEnclosingMethodCall(t)
        )
      )
    }

    // private predicate calls(B::Call bc, O::Call oc) {
    //     updatedMember(oc.getEnclosingCallable(), bc.getEnclosingCallable()) and
    //     bc.getCallee().getName() = oc.getCallee().getName()
    // }
    // private B::Callable via(O::Call call) {
    //     exists(B::Call bc |
    //       calls(bc, call) and
    //       result = BaseVd::viableCallable(bc)
    //     )
    // }
    B::Callable viableImpl(O::Call call) {
      call instanceof O::ConstructorCall and
      baseMemberRef(call.getCallee().getSourceDeclaration(), result)
      or
      not result.isAbstract() and
      if call instanceof O::VirtualMethodCall
      then
        exists(B::SrcMethod def, O::RefType ot, B::RefType bt, boolean exact |
          baseMemberRef(call.getCallee().getSourceDeclaration(), def) and
          qualType(call, ot, exact) and
          baseTypeRef(ot.getErasure(), bt)
        |
          exact = true and result = BaseVd::exactMethodImpl(def, bt)
          or
          exact = false and
          result = BaseVd::viableMethodImpl(def, bt, _)
        )
      else baseMemberRef(call.getCallee().getSourceDeclaration(), result)
    }
  }

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c) {
    result.asBase() = BaseDf::viableCallable(c.asBase()) or
    result.asOverlay() = OverlayDf::viableCallable(c.asOverlay()) or
    updatedMember(result.asOverlay().asCallable(), BaseDf::viableCallable(c.asBase()).asCallable()) or
    result.asBase().asCallable() = OverlayToBaseDispatch::viableImpl(c.asOverlay().asCall())
  }

  predicate mayBenefitFromCallContext(DataFlowCall call) {
    // TODO: Possibly consider call contexts for overlay calls
    BaseDf::mayBenefitFromCallContext(call.asBase())
  }

  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    exists(BaseDf::DataFlowCallable tgt |
      tgt = BaseDf::viableImplInCallContext(call.asBase(), ctx.asBase())
    |
      result.asBase() = tgt or
      updatedMember(result.asOverlay().asCallable(), tgt.asCallable())
    )
    or
    exists(BaseDf::DataFlowCall bcall |
      bcall = call.asBase() and
      BaseDf::mayBenefitFromCallContext(bcall) and
      result = viableCallable(call) and
      bcall.getEnclosingCallable().asCallable() =
        OverlayToBaseDispatch::viableImpl(ctx.asOverlay().asCall())
    )
  }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    result.asBase() = BaseDf::getAnOutNode(call.asBase(), kind)
    or
    result.asOverlay() = OverlayDf::getAnOutNode(call.asOverlay(), _) and exists(kind)
  }

  private newtype TDataFlowType =
    TBaseDataFlowType(BaseDf::DataFlowType t) { not updatedType(_, t) } or
    TOverlayDataFlowType(OverlayDf::DataFlowType t) { not baseTypeRef(t, _) }

  class DataFlowType extends TDataFlowType {
    BaseDf::DataFlowType asBase() { this = TBaseDataFlowType(result) }

    OverlayDf::DataFlowType asOverlay() { this = TOverlayDataFlowType(result) }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }
  }

  private DataFlowType fromBase(BaseDf::DataFlowType t) {
    result = TBaseDataFlowType(t)
    or
    exists(OverlayDf::DataFlowType ot | updatedType(ot, t) | result = TOverlayDataFlowType(ot))
  }

  private DataFlowType fromOverlay(OverlayDf::DataFlowType t) {
    result = TOverlayDataFlowType(t)
    or
    exists(BaseDf::DataFlowType bt | baseTypeRef(t, bt) | result = TBaseDataFlowType(bt))
  }

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
    exists(BaseDf::DataFlowType bt1, BaseDf::DataFlowType bt2 |
      BaseDf::compatibleTypes(bt1, bt2) and
      t1 = fromBase(bt1) and
      t2 = fromBase(bt2)
    )
    or
    exists(OverlayDf::DataFlowType ot1, OverlayDf::DataFlowType ot2 |
      OverlayDf::compatibleTypes(ot1, ot2) and
      t1 = fromOverlay(ot1) and
      t2 = fromOverlay(ot2)
    )
  }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
    exists(BaseDf::DataFlowType bt1, BaseDf::DataFlowType bt2 |
      BaseDf::typeStrongerThan(bt1, bt2) and
      t1 = fromBase(bt1) and
      t2 = fromBase(bt2)
    )
    or
    exists(OverlayDf::DataFlowType ot1, OverlayDf::DataFlowType ot2 |
      OverlayDf::typeStrongerThan(ot1, ot2) and
      t1 = fromOverlay(ot1) and
      t2 = fromOverlay(ot2)
    )
  }

  private newtype TContent =
    TBaseFieldContent(B::InstanceField f) { not updatedMember(_, f) } or
    TOverlayFieldContent(O::InstanceField f) { not baseMemberRef(f, _) } or
    TArrayContent() or
    TCollectionContent() or
    TMapKeyContent() or
    TMapValueContent() or
    TBaseCapturedVariableContent(BaseDf::CapturedVariable v) or
    TOverlayCapturedVariableContent(OverlayDf::CapturedVariable v) or
    TSyntheticFieldContent(string s) {
      s = any(BaseDf::SyntheticFieldContent c).getField() or
      s = any(OverlayDf::SyntheticFieldContent c).getField()
    }

  additional Content contentFromBase(BaseDf::Content c) {
    result = TBaseFieldContent(c.(BaseDf::FieldContent).getField())
    or
    exists(O::InstanceField f | updatedMember(f, c.(BaseDf::FieldContent).getField()) |
      result = TOverlayFieldContent(f)
    )
    or
    result = TArrayContent() and c instanceof BaseDf::ArrayContent
    or
    result = TCollectionContent() and c instanceof BaseDf::CollectionContent
    or
    result = TMapKeyContent() and c instanceof BaseDf::MapKeyContent
    or
    result = TMapValueContent() and c instanceof BaseDf::MapValueContent
    or
    result = TBaseCapturedVariableContent(c.(BaseDf::CapturedVariableContent).getVariable())
    or
    result = TSyntheticFieldContent(c.(BaseDf::SyntheticFieldContent).getField())
  }

  additional Content contentFromOverlay(OverlayDf::Content c) {
    result = TOverlayFieldContent(c.(OverlayDf::FieldContent).getField())
    or
    exists(B::InstanceField f | baseMemberRef(c.(OverlayDf::FieldContent).getField(), f) |
      result = TBaseFieldContent(f)
    )
    or
    result = TArrayContent() and c instanceof OverlayDf::ArrayContent
    or
    result = TCollectionContent() and c instanceof OverlayDf::CollectionContent
    or
    result = TMapKeyContent() and c instanceof OverlayDf::MapKeyContent
    or
    result = TMapValueContent() and c instanceof OverlayDf::MapValueContent
    or
    result = TOverlayCapturedVariableContent(c.(OverlayDf::CapturedVariableContent).getVariable())
    or
    result = TSyntheticFieldContent(c.(OverlayDf::SyntheticFieldContent).getField())
  }

  class Content extends TContent {
    string toString() {
      exists(BaseDf::Content c | this = contentFromBase(c) | result = c.toString())
      or
      exists(OverlayDf::Content c | this = contentFromOverlay(c) | result = c.toString())
    }
  }

  predicate forceHighPrecision(Content c) {
    exists(BaseDf::Content bc | c = contentFromBase(bc) | BaseDf::forceHighPrecision(bc))
    or
    exists(OverlayDf::Content oc | c = contentFromOverlay(oc) | OverlayDf::forceHighPrecision(oc))
  }

  class ContentSet instanceof Content {
    Content getAStoreContent() { result = this }

    Content getAReadContent() { result = this }

    string toString() { result = super.toString() }
  }

  private newtype TContentApprox =
    TBaseContentApprox(BaseDf::ContentApprox c) or
    TOverlayContentApprox(OverlayDf::ContentApprox c)

  class ContentApprox extends TContentApprox {
    BaseDf::ContentApprox asBase() { this = TBaseContentApprox(result) }

    OverlayDf::ContentApprox asOverlay() { this = TOverlayContentApprox(result) }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }
  }

  ContentApprox getContentApprox(Content c) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      result.asBase() = BaseDf::getContentApprox(bc)
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      result.asOverlay() = OverlayDf::getContentApprox(oc) and
      not c = contentFromBase(_)
    )
  }

  private int parameterPosition() {
    result in [-1, any(B::Parameter p).getPosition(), any(O::Parameter p).getPosition()]
  }

  class ParameterPosition extends int {
    ParameterPosition() { this = parameterPosition() }
  }

  class ArgumentPosition extends int {
    ArgumentPosition() { this = parameterPosition() }
  }

  pragma[inline]
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
    BaseDf::simpleLocalFlowStep(node1.asBase(), node2.asBase(), model) or
    OverlayDf::simpleLocalFlowStep(node1.asOverlay(), node2.asOverlay(), model)
  }

  bindingset[node1, node2]
  predicate validParameterAliasStep(Node node1, Node node2) {
    BaseDf::validParameterAliasStep(node1.asBase(), node2.asBase()) or
    OverlayDf::validParameterAliasStep(node1.asOverlay(), node2.asOverlay())
  }

  predicate jumpStep(Node node1, Node node2) {
    exists(BaseDf::Node n1, BaseDf::Node n2 |
      BaseDf::jumpStep(n1, n2) and
      node1 = nodeFromBase(n1) and
      node2 = nodeFromBase(n2)
    )
    or
    exists(OverlayDf::Node n1, OverlayDf::Node n2 |
      OverlayDf::jumpStep(n1, n2) and
      node1 = nodeFromOverlay(n1) and
      node2 = nodeFromOverlay(n2)
    )
  }

  predicate readStep(Node node1, ContentSet c, Node node2) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      BaseDf::readStep(node1.asBase(), bc, node2.asBase())
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      OverlayDf::readStep(node1.asOverlay(), oc, node2.asOverlay())
    )
  }

  predicate storeStep(Node node1, ContentSet c, Node node2) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      BaseDf::storeStep(node1.asBase(), bc, node2.asBase())
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      OverlayDf::storeStep(node1.asOverlay(), oc, node2.asOverlay())
    )
  }

  predicate clearsContent(Node n, ContentSet c) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      BaseDf::clearsContent(n.asBase(), bc)
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      OverlayDf::clearsContent(n.asOverlay(), oc)
    )
  }

  predicate expectsContent(Node n, ContentSet c) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      BaseDf::expectsContent(n.asBase(), bc)
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      OverlayDf::expectsContent(n.asOverlay(), oc)
    )
  }

  private newtype TNodeRegion =
    TBaseNodeRegion(BaseDf::NodeRegion nr) or
    TOverlayNodeRegion(OverlayDf::NodeRegion nr)

  class NodeRegion extends TNodeRegion {
    BaseDf::NodeRegion asBase() { this = TBaseNodeRegion(result) }

    OverlayDf::NodeRegion asOverlay() { this = TOverlayNodeRegion(result) }

    string toString() { result = "NodeRegion" }

    predicate contains(Node n) {
      this.asBase().contains(n.asBase()) or this.asOverlay().contains(n.asOverlay())
    }
  }

  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) {
    // TODO: could be improved, but should suffice for now.
    BaseDf::isUnreachableInCall(nr.asBase(), call.asBase()) or
    OverlayDf::isUnreachableInCall(nr.asOverlay(), call.asOverlay())
  }

  predicate allowParameterReturnInSelf(ParameterNode p) {
    BaseDf::allowParameterReturnInSelf(p.asBase()) or
    OverlayDf::allowParameterReturnInSelf(p.asOverlay())
  }

  predicate localMustFlowStep(Node node1, Node node2) {
    BaseDf::localMustFlowStep(node1.asBase(), node2.asBase()) or
    OverlayDf::localMustFlowStep(node1.asOverlay(), node2.asOverlay())
  }

  private newtype TLambdaCallKind =
    TBaseLambdaCallKind(BaseDf::LambdaCallKind k) { not updatedMember(_, k) } or
    TOverlayLambdaCallKind(OverlayDf::LambdaCallKind k) { not baseMemberRef(k, _) }

  class LambdaCallKind extends TLambdaCallKind {
    BaseDf::LambdaCallKind asBase() { this = TBaseLambdaCallKind(result) }

    OverlayDf::LambdaCallKind asOverlay() { this = TOverlayLambdaCallKind(result) }

    string toString() { result = "LambdaCallKind" }
  }

  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
    exists(BaseDf::LambdaCallKind k | BaseDf::lambdaCreation(creation.asBase(), k, c.asBase()) |
      kind.asBase() = k or
      updatedMember(kind.asOverlay(), k)
    )
    or
    exists(OverlayDf::LambdaCallKind k |
      OverlayDf::lambdaCreation(creation.asOverlay(), k, c.asOverlay())
    |
      kind.asOverlay() = k or
      baseMemberRef(k, kind.asBase())
    )
  }

  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
    exists(BaseDf::LambdaCallKind k | BaseDf::lambdaCall(call.asBase(), k, receiver.asBase()) |
      kind.asBase() = k or
      updatedMember(kind.asOverlay(), k)
    )
    or
    exists(OverlayDf::LambdaCallKind k |
      OverlayDf::lambdaCall(call.asOverlay(), k, receiver.asOverlay())
    |
      kind.asOverlay() = k or
      baseMemberRef(k, kind.asBase())
    )
  }

  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) {
    BaseDf::knownSourceModel(source.asBase(), model) or
    OverlayDf::knownSourceModel(source.asOverlay(), model)
  }

  predicate knownSinkModel(Node sink, string model) {
    BaseDf::knownSinkModel(sink.asBase(), model) or
    OverlayDf::knownSinkModel(sink.asOverlay(), model)
  }

  private newtype TDataFlowSecondLevelScope =
    TBaseDataFlowSecondLevelScope(BaseDf::DataFlowSecondLevelScope s) or
    TOverlayDataFlowSecondLevelScope(OverlayDf::DataFlowSecondLevelScope s)

  class DataFlowSecondLevelScope extends TDataFlowSecondLevelScope {
    BaseDf::DataFlowSecondLevelScope asBase() { this = TBaseDataFlowSecondLevelScope(result) }

    OverlayDf::DataFlowSecondLevelScope asOverlay() {
      this = TOverlayDataFlowSecondLevelScope(result)
    }

    string toString() { result = this.asBase().toString() or result = this.asOverlay().toString() }
  }

  DataFlowSecondLevelScope getSecondLevelScope(Node n) {
    result.asBase() = BaseDf::getSecondLevelScope(n.asBase()) or
    result.asOverlay() = OverlayDf::getSecondLevelScope(n.asOverlay())
  }
}

base private import semmle.code.java.dataflow.internal.TaintTrackingUtil as BaseTt
overlay private import semmle.code.java.dataflow.internal.TaintTrackingUtil as OverlayTt

private module JavaTaintTracking implements TT::InputSig<Location, JavaDataFlow> {
  private import JavaDataFlow

  predicate defaultTaintSanitizer(Node node) {
    BaseTt::defaultTaintSanitizer(node.asBase()) or
    OverlayTt::defaultTaintSanitizer(node.asOverlay())
  }

  predicate defaultAdditionalTaintStep(Node src, Node sink, string model) {
    BaseTt::defaultAdditionalTaintStep(src.asBase(), sink.asBase(), model) or
    OverlayTt::defaultAdditionalTaintStep(src.asOverlay(), sink.asOverlay(), model)
  }

  bindingset[node]
  predicate defaultImplicitTaintRead(Node node, ContentSet c) {
    exists(BaseDf::Content bc |
      c = contentFromBase(bc) and
      BaseTt::defaultImplicitTaintRead(node.asBase(), bc)
    )
    or
    exists(OverlayDf::Content oc |
      c = contentFromOverlay(oc) and
      OverlayTt::defaultImplicitTaintRead(node.asOverlay(), oc)
    )
  }
}
