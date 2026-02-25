overlay[local?]
module;

private import minimal.minimal
private import minimal.minimal as JS
private import codeql.unified.UnifiedDataFlow
private import codeql.util.Boolean
import minimal.BasicBlockInternal as BB
private import PathResolution

module UnifiedDataFlow0 = MakeUnifiedDataFlow0<Location, BB::Cfg>;

module UnifiedDataFlow1 = MakeUnifiedDataFlow1<UnifiedDataFlowInput>;

module UnifiedDataFlow2 = MakeUnifiedDataFlow2<UnifiedDataFlowInput>;

module UnifiedDataFlow3 = MakeUnifiedDataFlow3<UnifiedDataFlowInput>;

module UnifiedDataFlow4 = MakeUnifiedDataFlow4<UnifiedDataFlowInput>;

import UnifiedDataFlow0
import UnifiedDataFlow1
import UnifiedDataFlow2
import UnifiedDataFlow3
import UnifiedDataFlow4

module UnifiedDataFlowInput implements
  UnifiedDataFlowSig1, UnifiedDataFlowSig2, UnifiedDataFlowSig3, UnifiedDataFlowSig4
{
  import NamespaceObjects
  import semmle.javascript.internal.unified.Constant

  class AstNode = JS::AstNode;

  class Callable = JS::StmtContainer;

  predicate lateStageStep(DataFlow2::Node node1, StepBase step, DataFlow2::Node node2) {
    importStep(node1, step, node2)
  }

  predicate isTrackedAllocationSite(DataFlow2::Node node) {
    node.isSyntheticNode(_,
      ["module-exports-object", "module-object", "prototype", "allocation-site"])
    or
    node.isValueOf(any(ObjectExpr e))
    or
    node.isIncomingValue(any(ClassDefinition def).getIdentifier())
    or
    exists(Function f |
      (
        if f instanceof FunctionDeclStmt
        then node.isIncomingValue(f.getIdentifier())
        else node.isValueOf(f)
      )
    )
  }

  Callable getCallableFromBasicBlock(BB::Cfg::BasicBlock bb) { result = bb.getContainer() }

  Callable getCallableFromCfgNode(ControlFlowNode node) { result = node.getContainer() }

  private newtype TCall =
    TOrdinaryCall(JS::InvokeExpr invoke) or
    TReflectiveCall(JS::MethodCallExpr call) { call.getMethodName() = ["call", "apply"] } or
    TJsxCall(JS::JsxElement elm) { not elm.getNameExpr() instanceof Label }

  class Call extends TCall {
    JS::InvokeExpr asOrdinaryCall() { this = TOrdinaryCall(result) }

    JS::MethodCallExpr asReflectiveCall() { this = TReflectiveCall(result) }

    JS::JsxElement asJsxCall() { this = TJsxCall(result) }

    string toString() {
      result = this.asOrdinaryCall().toString()
      or
      result = "[inner] " + this.asReflectiveCall().toString()
      or
      result = this.asJsxCall().toString()
    }

    Location getLocation() {
      result = this.asOrdinaryCall().getLocation()
      or
      result = this.asReflectiveCall().getLocation()
      or
      result = this.asJsxCall().getLocation()
    }

    JS::InvokeExpr getUnderlyingInvokeExpr() {
      result = this.asOrdinaryCall() or result = this.asReflectiveCall()
    }
  }

  predicate modelEntryPoint(string head, string operand, DataFlow2::Node node) {
    head = "PredefinedVar" and
    exists(Variable v |
      v.getName() = operand and
      (
        v.getScope().getScopeElement() instanceof TopLevel and
        node.isVariablePreInitializer(v)
        or
        v instanceof GlobalVariable and
        node.isValueOf(v.getAnAccess())
      )
    )
  }

  predicate argumentParameterContent(string operand, Content content) {
    operand = "" + content.asArrayIndex(_)
  }

  predicate isMethod(Callable callable) {
    exists(MethodDeclaration method |
      not method instanceof ConstructorDeclaration and
      callable = method.getBody()
    )
    or
    // For functions stored on an object, we don't know if it's a constructor stored on a namespace-like object,
    // or a method on the target object. Make a best-effort guess based on whether the name is capitalized.
    not callable instanceof ArrowFunctionExpr and
    (
      exists(AssignExpr assign |
        assign.getTarget().(PropAccess).getPropertyName().regexpMatch("[a-z].*") and
        callable = assign.getRhs()
      )
      or
      exists(Property prop |
        callable = prop.getInit() and
        prop.getName().regexpMatch("[a-z].*")
      )
    )
  }

  predicate isInstanceInitializer(Callable callable, ClassLikeObject cls) {
    callable = cls.getConstructor()
  }

  ControlFlowNode getCfgNodeFromCall(Call call) {
    result = call.asOrdinaryCall() or result = call.asReflectiveCall()
  }

  class LocalVariable = JS::LocalVariable;

  class GuardValue = Boolean;

  class Guard extends Expr {
    Guard() { this = any(ConditionGuardNode g).getTest() }

    private ConditionGuardNode getAConditionGuardNode() { result.getTest() = this }

    BB::Cfg::BasicBlock getOutcomeBlock(boolean branch) {
      // A ConditionGuardNode sits at the beginning of each outcome branch
      exists(ConditionGuardNode guard |
        guard = this.getAConditionGuardNode() and
        guard.getOutcome() = branch and
        result = guard.getBasicBlock()
      )
    }

    predicate hasValueBranchEdge(BB::Cfg::BasicBlock bb1, BB::Cfg::BasicBlock bb2, GuardValue branch) {
      exists(ConditionGuardNode guard |
        branch = guard.getOutcome() and
        bb1 = guard.getBasicBlock().getAPredecessor() and
        bb2 = guard.getBasicBlock()
      )
    }

    predicate valueControlsBranchEdge(
      BB::Cfg::BasicBlock bb1, BB::Cfg::BasicBlock bb2, GuardValue val
    ) {
      // TODO: instantiate guards library to get a better implementation of this
      this.hasValueBranchEdge(bb1, bb2, val)
    }
  }

  predicate guardDirectlyControlsBlock(Guard guard, BB::Cfg::BasicBlock bb, GuardValue branch) {
    guard.getOutcomeBlock(branch).dominates(bb)
  }

  predicate hasIncomingValue(AstNode node, ControlFlowNode when) {
    node = when.(Assignment).getTarget() // note: includes both plain and compound assignments
    or
    node = when.(UpdateExpr).getOperand() // x++
    or
    node = when.(Parameter)
    or
    node = when.(EnhancedForLoop).getLValue()
    or
    node = when.(VariableDeclarator).getBindingPattern()
    or
    node = when.(PropertyPattern).getValuePattern()
    or
    node = when.(ArrayPattern).getAnElement()
    or
    node = when.(ObjectPattern).getRest()
    or
    node = when.(ArrayPattern).getRest()
    or
    exists(VarDecl decl |
      decl = any(Function f).getIdentifier()
      or
      decl = any(ClassDefinition cls).getIdentifier()
    |
      when = decl and
      node = when
    )
    or
    node = any(ComprehensionBlock b).getIterator() and when = node
    or
    node = any(ImportDeclaration d).getASpecifier() and when = node
    or
    node = any(ImportSpecifier s).getLocal() and when = node
    // TODO: exports
    // TODO: TypeScript specific declarations
    // TODO: TypeScript namespace declarations are impure, or special-case for lazy-created namespace access?
  }

  private predicate hasBothIncomingAndCompletionValue(AstNode node) {
    node = any(CompoundAssignExpr e).getTarget()
    or
    node = any(UpdateExpr e).getOperand()
  }

  predicate hasCompletionValue(AstNode node, ControlFlowNode when) {
    node instanceof AST::ValueNode and
    when = node and
    (hasIncomingValue(node, _) implies hasBothIncomingAndCompletionValue(node))
  }

  predicate hasPostUpdatedValue(AstNode node, ControlFlowNode when) {
    exists(PropAccess prop |
      hasIncomingValue(prop, when) and
      node = prop.getBase()
    )
  }

  predicate isInterceptingExceptions(AstNode tryBlock) {
    exists(TryStmt try |
      exists(try.getACatchClause()) and
      tryBlock = try.getBody()
    )
  }

  private newtype TIndexedContainerKind =
    TArray() or
    TMap()

  class IndexedContainerKind extends TIndexedContainerKind {
    string toString() {
      this = TArray() and result = "Array"
      or
      this = TMap() and result = "Map"
    }

    predicate trackFlowIntoKeys() { this = TMap() }

    string getKeyToken() { this = TMap() and result = "MapKey" }

    string getValueToken() {
      this = TArray() and result = "ArrayElement"
      or
      this = TMap() and result = "MapValue"
    }

    predicate trackValuesAssociatedWithKey(Constant key) {
      this = TMap() and exists(key)
      or
      this = TArray() and key.asArrayIndex() = [0 .. 20]
    }
  }

  additional class ArrayContainerKind extends IndexedContainerKind, TArray { }

  additional class MapContainerKind extends IndexedContainerKind, TMap { }

  private newtype TLanguageContent =
    TPropertyName(string name) {
      name = any(Identifier id).getName() or name = any(Expr e).getStringValue()
    } or
    TPromiseValue() or
    TPromiseError() or
    TIteratorElement() or
    TIteratorError()

  class LanguageContent extends TLanguageContent {
    predicate supportsStrongUpdate() { this instanceof TPropertyName }

    string asPropertyName() { this = TPropertyName(result) }

    predicate isPromiseValue() { this = TPromiseValue() }

    predicate isPromiseError() { this = TPromiseError() }

    predicate hasModelToken(string head, string operand) {
      head = "Member" and
      operand = this.asPropertyName()
      or
      this = TPromiseValue() and head = "Awaited" and operand = "value"
      or
      this = TPromiseError() and head = "Awaited" and operand = "error"
      or
      this = TIteratorElement() and head = "IteratorElement" and operand = ""
      or
      this = TIteratorError() and head = "IteratorError" and operand = ""
    }

    string toString() {
      result = this.asPropertyName()
      or
      this = TPromiseValue() and result = "Promise.value"
      or
      this = TPromiseError() and result = "Promise.error"
      or
      this = TIteratorElement() and result = "IteratorElement"
      or
      this = TIteratorError() and result = "IteratorError"
    }

    Location getLocation() { none() }
  }

  private newtype TLanguageContentSet =
    TAnyProperty() or
    TAnyPromiseContent() or
    TShadowedFromBulkExport(TopLevel top) {
      exists(BulkReExportDeclaration decl | decl.getContainer() = top)
    }

  class LanguageContentSet extends TLanguageContentSet {
    Content getAReadContent() {
      this instanceof TAnyProperty and
      (
        exists(result.asLanguageContent().asPropertyName())
        or
        exists(result.asContainerSlot(any(ArrayContainerKind a)))
      )
      or
      this instanceof TAnyPromiseContent and
      (
        result.asLanguageContent().isPromiseValue()
        or
        result.asLanguageContent().isPromiseError()
      )
      or
      exists(TopLevel t, ExportNamedDeclaration decl, string name |
        this = TShadowedFromBulkExport(t) and
        decl.getContainer() = t and
        decl.exportsDirectlyAs(_, name) and
        result.asLanguageContent().asPropertyName() = name
      )
      or
      this instanceof TShadowedFromBulkExport and
      result.asLanguageContent().asPropertyName() = "default"
    }

    Content getAStoreContent() { none() }

    predicate hasModelToken(string head, string operand) {
      this = TAnyProperty() and head = "AnyMember" and operand = ""
    }

    Location getLocation() {
      exists(TopLevel top |
        this = TShadowedFromBulkExport(top) and
        result = top.getLocation()
      )
    }

    string toString() {
      this = TAnyProperty() and result = "anyProperty"
      or
      this = TAnyPromiseContent() and result = "anyPromiseContent"
      or
      this instanceof TShadowedFromBulkExport and
      result = "shadowedFromBulkExport"
    }

    predicate supportsStrongUpdate() { none() }
  }

  /** Provides access to contents. */
  additional module Contents {
    module ArrayContent = ArrayContentAccessor<ArrayContainerKind>;

    module MapContent = MapContentAccessor<MapContainerKind>;

    private class PropertyName extends string {
      PropertyName() {
        this = any(Identifier id).getName()
        or
        this = any(Expr e).getStringValue()
        or
        this = any(StringLiteralTypeExpr e).getValue()
      }
    }

    pragma[nomagic]
    private ContentSet arrayProperty(string name) {
      name = result.asContainerSlot(ArrayContent::kind()).asArrayIndex().toString()
    }

    pragma[nomagic]
    ContentSet property(string name) {
      // In JavaScript, array elements are semantically just properties whose name is a string containing the index.
      // Make sure numeric strings are mapped to their array element contents.
      result = arrayProperty(name)
      or
      not exists(arrayProperty(name)) and
      result.asSingleton().asLanguageContent().asPropertyName() = name
    }

    bindingset[name]
    pragma[inline_late]
    ContentSet propertyStrict(string name) { result = property(name) }

    ContentSet anyProperty() { result.asLanguageContentSet() = TAnyProperty() }

    ContentSet promiseValue() { result.asSingleton().asLanguageContent() = TPromiseValue() }

    ContentSet promiseError() { result.asSingleton().asLanguageContent() = TPromiseError() }

    ContentSet anyPromiseContent() { result.asLanguageContentSet() = TAnyPromiseContent() }

    ContentSet iteratorElement() { result.asSingleton().asLanguageContent() = TIteratorElement() }

    ContentSet iteratorError() { result.asSingleton().asLanguageContent() = TIteratorError() }

    /** Content-set matching the set of contents that are shadowed from bulk-export statements in `top`. */
    ContentSet shadowedFromBulkExport(TopLevel top) {
      result.asLanguageContentSet() = TShadowedFromBulkExport(top)
    }
  }

  import semmle.javascript.internal.unified.DataFlowSteps
  import semmle.javascript.internal.unified.Transforms

  Content setterParameter() { result.asArrayIndex(_) = 0 }
}

module Contents = UnifiedDataFlowInput::Contents;

module Transforms = UnifiedDataFlowInput::Transforms;

module DataFlow2 = DataFlowPublic;

extensible predicate aliasModel(string aliasName, string accessPath);

module ModelsAsData = MakeModelsAsData<aliasModel/2>;

class LocalVariable = JS::LocalVariable;

import UnifiedDataFlowInput
