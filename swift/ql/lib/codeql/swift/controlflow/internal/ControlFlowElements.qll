private import swift

cached
newtype TControlFlowElement =
  TAstElement(AstNode n) or
  TFuncDeclElement(Function func) { func.hasBody() } or
  TClosureElement(ClosureExpr clos) { isNormalAutoClosureOrExplicitClosure(clos) } or
  TPropertyGetterElement(Decl accessor, Expr ref) { isPropertyGetterElement(accessor, ref) } or
  TPropertySetterElement(Accessor accessor, AssignExpr assign) {
    isPropertySetterElement(accessor, assign)
  } or
  TPropertyObserverElement(Accessor observer, AssignExpr assign) {
    isPropertyObserverElement(observer, assign)
  } or
  TKeyPathElement(KeyPathExpr expr) or
  TNilCoalescingTestElement(NilCoalescingExpr expr)

predicate isLValue(Expr e) { any(AssignExpr assign).getDest() = e }

predicate isRValue(Expr e) { not isLValue(e) }

predicate ignoreAstElement(AstNode n) {
  isPropertyGetterElement(_, n)
  or
  isPropertySetterElement(_, n)
}

private Accessor getAnAccessor(Decl d) {
  result = d.(VarDecl).getAnAccessor() or
  result = d.(SubscriptDecl).getAnAccessor()
}

predicate isPropertyGetterElement(Accessor accessor, Expr ref) {
  hasDirectToImplementationOrOrdinarySemantics(ref) and
  isRValue(ref) and
  accessor.isGetter() and
  accessor = getAnAccessor([ref.(LookupExpr).getMember(), ref.(DeclRefExpr).getDecl()])
}

predicate isPropertyGetterElement(PropertyGetterElement pge, Accessor accessor, Expr ref) {
  pge = TPropertyGetterElement(accessor, ref)
}

predicate isNormalAutoClosureOrExplicitClosure(ClosureExpr clos) {
  // short-circuiting operators have a `BinaryExpr` as the parent of the `AutoClosureExpr`,
  // so we exclude them by checking for a `CallExpr`.
  clos instanceof AutoClosureExpr and
  exists(CallExpr call | call.getAnArgument().getExpr() = clos)
  or
  clos instanceof ExplicitClosureExpr
}

private predicate hasDirectToImplementationSemantics(Expr e) {
  e.(MemberRefExpr).hasDirectToImplementationSemantics()
  or
  e.(SubscriptExpr).hasDirectToImplementationSemantics()
  or
  e.(DeclRefExpr).hasDirectToImplementationSemantics()
}

private predicate hasOrdinarySemantics(Expr e) {
  e.(MemberRefExpr).hasOrdinarySemantics()
  or
  e.(SubscriptExpr).hasOrdinarySemantics()
  or
  e.(DeclRefExpr).hasOrdinarySemantics()
}

private predicate hasDirectToImplementationOrOrdinarySemantics(Expr e) {
  hasDirectToImplementationSemantics(e) or hasOrdinarySemantics(e)
}

private predicate isPropertySetterElement(Accessor accessor, AssignExpr assign) {
  exists(Expr lhs | lhs = assign.getDest() |
    hasDirectToImplementationOrOrdinarySemantics(lhs) and
    accessor.isSetter() and
    isLValue(lhs) and
    accessor = getAnAccessor([lhs.(LookupExpr).getMember(), lhs.(DeclRefExpr).getDecl()])
  )
}

predicate isPropertySetterElement(PropertySetterElement pse, Accessor accessor, AssignExpr assign) {
  pse = TPropertySetterElement(accessor, assign)
}

private predicate isPropertyObserverElement(Accessor observer, AssignExpr assign) {
  exists(Expr lhs | lhs = assign.getDest() |
    hasDirectToImplementationOrOrdinarySemantics(lhs) and
    observer.isPropertyObserver() and
    isLValue(lhs) and
    observer = getAnAccessor([lhs.(LookupExpr).getMember(), lhs.(DeclRefExpr).getDecl()])
  )
}

predicate isPropertyObserverElement(
  PropertyObserverElement poe, Accessor accessor, AssignExpr assign
) {
  poe = TPropertyObserverElement(accessor, assign)
}

class ControlFlowElement extends TControlFlowElement {
  string toString() { none() } // overridden in subclasses

  AstNode asAstNode() { none() }

  Location getLocation() { none() } // overridden in subclasses
}

class AstElement extends ControlFlowElement, TAstElement {
  AstNode n;

  AstElement() { this = TAstElement(n) }

  override string toString() { result = n.toString() }

  override AstNode asAstNode() { result = n }

  override Location getLocation() { result = n.getLocation() }
}

class PropertyGetterElement extends ControlFlowElement, TPropertyGetterElement {
  Accessor accessor;
  Expr ref;

  PropertyGetterElement() { this = TPropertyGetterElement(accessor, ref) }

  override string toString() { result = "getter for " + ref.toString() }

  override Location getLocation() { result = ref.getLocation() }

  Expr getRef() { result = ref }

  Accessor getAccessor() { result = accessor }

  Expr getBase() { result = ref.(LookupExpr).getBase() }
}

class PropertySetterElement extends ControlFlowElement, TPropertySetterElement {
  Accessor accessor;
  AssignExpr assign;

  PropertySetterElement() { this = TPropertySetterElement(accessor, assign) }

  override string toString() { result = "setter for " + assign }

  override Location getLocation() { result = assign.getLocation() }

  Accessor getAccessor() { result = accessor }

  AssignExpr getAssignExpr() { result = assign }

  Expr getBase() { result = assign.getDest().(LookupExpr).getBase() }
}

class PropertyObserverElement extends ControlFlowElement, TPropertyObserverElement {
  Accessor observer;
  AssignExpr assign;

  PropertyObserverElement() { this = TPropertyObserverElement(observer, assign) }

  override string toString() {
    this.isWillSet() and
    result = "willSet observer for " + assign.toString()
    or
    this.isDidSet() and
    result = "didSet observer for " + assign.toString()
  }

  override Location getLocation() { result = assign.getLocation() }

  Accessor getObserver() { result = observer }

  predicate isWillSet() { observer.isWillSet() }

  predicate isDidSet() { observer.isDidSet() }

  AssignExpr getAssignExpr() { result = assign }

  Expr getBase() { result = assign.getDest().(LookupExpr).getBase() }
}

class FuncDeclElement extends ControlFlowElement, TFuncDeclElement {
  Function func;

  FuncDeclElement() { this = TFuncDeclElement(func) }

  override string toString() { result = func.toString() }

  override Location getLocation() { result = func.getLocation() }

  Function getAst() { result = func }
}

class KeyPathElement extends ControlFlowElement, TKeyPathElement {
  KeyPathExpr expr;

  KeyPathElement() { this = TKeyPathElement(expr) }

  override Location getLocation() { result = expr.getLocation() }

  KeyPathExpr getAst() { result = expr }

  override string toString() { result = expr.toString() }
}

/**
 * A control flow element representing a closure in its role as a control flow
 * scope.
 */
class ClosureElement extends ControlFlowElement, TClosureElement {
  ClosureExpr expr;

  ClosureElement() { this = TClosureElement(expr) }

  override Location getLocation() { result = expr.getLocation() }

  ClosureExpr getAst() { result = expr }

  override string toString() { result = expr.toString() }
}

class NilCoalescingElement extends ControlFlowElement, TNilCoalescingTestElement {
  NilCoalescingExpr expr;

  NilCoalescingElement() { this = TNilCoalescingTestElement(expr) }

  override Location getLocation() { result = expr.getLocation() }

  NilCoalescingExpr getAst() { result = expr }

  override string toString() { result = "emptiness test for " + expr.toString() }
}
