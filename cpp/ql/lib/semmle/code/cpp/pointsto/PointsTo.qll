/**
 * Provides classes and predicates implementing a points-to analysis
 * based on Steensgaard's algorithm, extended to support fields.
 *
 * A pointer set can be represented in one of two ways: an expression, or
 * the combination of an expression and a label. In the former case,
 * the expression represents the values the expression might evaluate to.
 * In the latter case, the (expr, label) pair is called a "compound", and it
 * represents a field of the value with the name of the given label. The label
 * can be either a string or another element.
 *
 * The various "flow" predicates (`flow`, `flowToCompound`, etc.) represent
 * direct flow from a source set to a destination set. The various "pointer"
 * predicates (`pointer`, `pointerFromCompound`, etc.) indicate that one set
 * contains values pointing to the locations represented by the other set.
 *
 * The individual flow and pointer predicates only hold tuples describing
 * one step of flow; they do not include transitive closures. The
 * `pointstoinfo` predicate determines the transitively implied points-to
 * information by collapsing pointers into equivalence classes. These
 * equivalence classes are called "points-to sets".
 */

import semmle.code.cpp.commons.File
import semmle.code.cpp.exprs.Expr

/**
 * Holds if `actual` is the override of `resolved` for a value of type
 * `dynamic`.
 */
predicate resolve(Class dynamic, VirtualFunction resolved, VirtualFunction actual) {
  if resolved.getAnOverridingFunction*().getDeclaringType() = dynamic
  then
    actual = resolved.getAnOverridingFunction*() and
    dynamic = actual.getDeclaringType()
  else resolve(dynamic.getABaseClass(), resolved, actual)
}

/**
 * Holds if `e` is evaluated just for its location. This includes
 * expressions that are used in a reference expression (`&foo`),
 * expressions that are used on the left side of an assignment,
 * and some non-expression types such as `Initializer`.
 *
 * For expressions, this is similar to, but different than,
 * `e.(Expr).isLValue()`, which holds if `e` *has* an address.
 *
 * This relation pervasively influences the interpretation of
 * expressions throughout this module. An element evaluated for its
 * lvalue is treated as evaluating to its location, not its value.
 */
predicate lvalue(Element e) {
  exists(AssignExpr assign | assign.getLValue().getFullyConverted() = e)
  or
  exists(AddressOfExpr addof | e = addof.getOperand().getFullyConverted())
  or
  exists(FieldAccess fa |
    fa.getQualifier().getFullyConverted() = e and
    not pointerValue(e)
  )
  or
  exists(Call c |
    c.getQualifier().getFullyConverted() = e and
    not pointerValue(e)
  )
  or
  e.(Expr).getConversion() instanceof ArrayToPointerConversion
  or
  exists(ParenthesisExpr paren |
    exprconv(unresolveElement(e), unresolveElement(paren)) and lvalue(paren)
  )
  or
  exists(Cast c | lvalue(c) and e.(Expr).getConversion() = c)
  or
  exists(ReferenceToExpr toref | e.(Expr).getConversion() = toref)
  or
  // If f is a function-pointer, then the following two
  // calls are equivalent:  f()  and  (*f)()
  exists(PointerDereferenceExpr deref |
    e = deref and
    deref.getUnderlyingType() instanceof FunctionPointerType
  )
  or
  exists(Variable v |
    e = v.getInitializer() and
    v.getType().getUnderlyingType() instanceof Struct
  )
  or
  exists(Variable v |
    e = v.getInitializer() and
    v.getType().getUnderlyingType() instanceof ArrayType
  )
  or
  e instanceof AggregateLiteral
}

/**
 * Gets an access for the value of `p` on line `line`.
 */
private VariableAccess param_rvalue_access_line(Parameter p, int line) {
  p.getAnAccess() = result and
  not lvalue(result) and
  result.getLocation().getStartLine() = line
}

/**
 * Gets an access for the value of `p`.
 *
 * The choice is arbitrary, and it doesn't matter if this returns more
 * than one access, but we try to have few results to cut down the
 * number of flow edges.
 */
private VariableAccess pick_rvalue_access(Parameter p) {
  result = min(int line | | param_rvalue_access_line(p, line) order by line)
}

/**
 * Holds if there is an access for the value of `p`.
 *
 * Usually we can just add a flow edge from a function argument to a
 * value access of the corresponding parameter. If all accesses to the
 * parameter are lvalues, however, we have to add a pointer edge from
 * the parameter to the function argument. This is less precise, because
 * it can equate more points-to sets.
 */
private predicate has_rvalue_access(Parameter p) {
  exists(VariableAccess a | a = p.getAnAccess() | not lvalue(a))
}

/**
 * Holds if `e` has a pointer type.
 */
predicate pointerValue(Expr e) {
  exists(Type t |
    t = e.getType().getUnderlyingType() and
    (
      t instanceof PointerType or
      t instanceof ArrayType or
      t instanceof ReferenceType
    )
  )
}

private predicate pointerEntity(@element src, @element dest) {
  pointer(mkElement(src), mkElement(dest))
}

/**
 * The source is a pointer to the destination.
 */
predicate pointer(Element src, Element dest) {
  exists(Variable v |
    not lvalue(dest) and
    src = v and
    (dest = v.getAnAccess() or dest = v.getInitializer())
  )
  or
  exists(AssignExpr assign |
    not lvalue(assign) and
    src = assign.getLValue().getFullyConverted() and
    dest = assign
  )
  or
  exists(AssignExpr assign |
    src = assign.getLValue().getFullyConverted() and
    dest = assign.getRValue().getFullyConverted()
  )
  or
  exists(FunctionCall c, Function f, Parameter p, int i |
    p = f.getParameter(i) and
    not has_rvalue_access(p) and
    dest = c.getArgument(i).getFullyConverted() and
    not f.isVirtual() and
    src = p.getAnAccess() and
    c.getTarget() = f
  )
  or
  exists(PointerDereferenceExpr deref |
    not lvalue(deref) and
    src = deref.getOperand().getFullyConverted() and
    dest = deref
  )
  or
  exists(ArrayExpr ae |
    not lvalue(dest) and
    dest = ae and
    src = ae.getArrayBase().getFullyConverted() and
    pointerValue(src)
  )
  or
  exists(ArrayExpr ae |
    not lvalue(dest) and
    dest = ae and
    src = ae.getArrayOffset().getFullyConverted() and
    pointerValue(src)
  )
  or
  exists(ReferenceDereferenceExpr deref |
    not lvalue(deref) and
    dest = deref and
    exprconv(unresolveElement(src), unresolveElement(deref))
  )
  or
  exists(AggregateLiteral agg |
    not lvalue(dest) and
    agg.getType().getUnderlyingType() instanceof ArrayType and
    src = agg and
    dest = agg.getAChild().getFullyConverted()
  )
  or
  // field points to constructor field initializer
  exists(ConstructorFieldInit cfi |
    dest = cfi and
    src = cfi.getTarget() and
    not lvalue(dest)
  )
  //
  // add more cases here
  //
}

private predicate flowEntity(@element src, @element dest) { flow(mkElement(src), mkElement(dest)) }

/**
 * The value held in the source flows to the value held in the destination.
 */
predicate flow(Element src, Element dest) {
  exists(Variable v |
    lvalue(dest) and
    src = v and
    (dest = v.getAnAccess() or dest = v.getInitializer())
  )
  or
  exists(FunctionAccess fa | src = fa.getTarget() and dest = fa)
  or
  exists(AssignExpr assign |
    lvalue(assign) and
    src = assign.getLValue().getFullyConverted() and
    dest = assign
  )
  or
  exists(AddressOfExpr addof |
    dest = addof and
    src = addof.getOperand().getFullyConverted()
  )
  or
  exists(FunctionCall c, Function f, int i |
    not lvalue(dest) and
    src = c.getArgument(i).getFullyConverted() and
    not f.isVirtual() and
    dest = pick_rvalue_access(f.getParameter(i)) and
    c.getTarget() = f
  )
  or
  exists(FunctionCall c, Function f, int i |
    src = c.getArgument(i).getFullyConverted() and
    not f.isVirtual() and
    c.getTarget() = f and
    i >= f.getNumberOfParameters() and
    varArgRead(f, dest)
  )
  or
  exists(FunctionCall c, Function f, ReturnStmt r |
    c.getTarget() = f and
    not f.isVirtual() and
    r.getEnclosingFunction() = f and
    src = r.getExpr().getFullyConverted() and
    dest = c
  )
  or
  exists(PointerDereferenceExpr deref |
    lvalue(deref) and
    src = deref.getAChild().getFullyConverted() and
    dest = deref
  )
  or
  exists(Variable v |
    dest = v.getInitializer() and
    src = v.getInitializer().getExpr().getFullyConverted()
  )
  or
  exists(ArrayExpr ae |
    lvalue(dest) and
    dest = ae and
    src = ae.getArrayBase().getFullyConverted() and
    pointerValue(src)
  )
  or
  exists(ArrayExpr ae |
    lvalue(dest) and
    dest = ae and
    src = ae.getArrayOffset().getFullyConverted() and
    pointerValue(src)
  )
  or
  exists(Expr arg, BinaryArithmeticOperation binop |
    dest = binop and
    src = arg and
    pointerValue(binop) and
    pointerValue(arg) and
    (
      arg = binop.getLeftOperand().getFullyConverted() or
      arg = binop.getRightOperand().getFullyConverted()
    )
  )
  or
  exists(Cast c | src = c.getExpr() and dest = c)
  or
  exists(ReferenceToExpr toref |
    exprconv(unresolveElement(src), unresolveElement(toref)) and dest = toref
  )
  or
  exists(ReferenceDereferenceExpr deref |
    lvalue(deref) and
    dest = deref and
    exprconv(unresolveElement(src), unresolveElement(deref))
  )
  or
  exists(ArrayToPointerConversion conv |
    exprconv(unresolveElement(src), unresolveElement(conv)) and dest = conv
  )
  or
  exists(ParenthesisExpr paren |
    // these can appear on the LHS of an assignment
    exprconv(unresolveElement(src), unresolveElement(paren)) and dest = paren
    or
    exprconv(unresolveElement(dest), unresolveElement(paren)) and src = paren
  )
  or
  exists(ConditionalExpr cond |
    dest = cond and
    (
      src = cond.getThen().getFullyConverted() or
      src = cond.getElse().getFullyConverted()
    )
  )
  or
  exists(IncrementOperation inc |
    dest = inc and
    src = inc.getOperand().getFullyConverted()
  )
  or
  exists(IncrementOperation dec |
    dest = dec and
    src = dec.getOperand().getFullyConverted()
  )
  or
  exists(CommaExpr comma |
    dest = comma and
    src = comma.getRightOperand().getFullyConverted()
  )
  or
  exists(ParenthesisExpr paren |
    dest = paren and exprconv(unresolveElement(src), unresolveElement(paren))
  )
  or
  // "vtable" for new-expressions
  exists(NewExpr new | src = new and dest = new.getAllocatedType())
  or
  // "vtable" for class-typed variables
  exists(Variable v, Class c | v.getType().getUnderlyingType() = c and src = v and dest = c)
  or
  exists(AggregateLiteral agg |
    lvalue(dest) and
    agg.getType().getUnderlyingType() instanceof ArrayType and
    src = agg and
    dest = agg.getAChild().getFullyConverted()
  )
  or
  // contained expr -> constructor field initializer
  exists(ConstructorFieldInit cfi |
    src = cfi.getExpr().getFullyConverted() and
    dest = cfi
  )
  //
  // add more cases here
  //
}

// Try to find the expression corresponding to the return value
// of va_arg(...,...) - which is a macro.
predicate varArgRead(Function f, Expr e) {
  exists(Macro m, MacroInvocation mi |
    m.getHead().matches("va\\_arg(%") and
    mi.getMacro() = m and
    e = mi.getAGeneratedElement() and
    not e.getParent() = mi.getAGeneratedElement() and
    e.getEnclosingFunction() = f
  )
}

/**
 * There is a flow from src to the compound (destParent, destLabel).
 */
predicate flowToCompound(Element destParent, string destLabel, Element src) {
  exists(ExprCall call, int i |
    src = call.getArgument(i).getFullyConverted() and
    destParent = call.getExpr().getFullyConverted() and
    if i < call.getType().(FunctionPointerType).getNumberOfParameters()
    then destLabel = "+arg" + i.toString()
    else destLabel = "+vararg"
  )
  or
  exists(Function f, ReturnStmt ret |
    f = ret.getEnclosingFunction() and
    src = ret.getExpr().getFullyConverted() and
    destLabel = "+ret" and
    destParent = f
  )
  or
  exists(AggregateLiteral agg, Struct s, int i |
    destParent = agg and
    lvalue(src) and
    aggregateLiteralChild(agg, s, i, src) and
    destLabel = s.getCanonicalMember(i).getName()
  )
  or
  exists(FunctionCall c, Function f |
    c.getTarget() = f and
    not f.isVirtual() and
    src = c.getQualifier().getFullyConverted() and
    destParent = f and
    destLabel = "+this"
  )
  or
  exists(ConstructorCall c, Function f, Variable v |
    c.getTarget() = f and
    not f.isVirtual() and
    v.getAnAssignedValue() = c and
    src = v and
    destParent = f and
    destLabel = "+this"
  )
  or
  exists(NewExpr ne, ConstructorCall c, Function f |
    c.getTarget() = f and
    not f.isVirtual() and
    ne.getInitializer() = c and
    src = ne and
    destParent = f and
    destLabel = "+this"
  )
  // in C, &s == &s.firstfield
  //  exists(FieldAccess fa, Field f |
  //    parent = fa.getQualifier().getFullyConverted() and src = parent and
  //    f = fa.getTarget() and not exists(f.previous()) and
  //    label = f.getName()
  //  )
  //
  // add more cases here
  //
}

/**
 * There is a flow from the compound (parent, label) to dest.
 */
predicate flowFromCompound(Element parent, string label, Element dest) {
  exists(ExprCall call |
    dest = call and label = "+ret" and parent = call.getExpr().getFullyConverted()
  )
  or
  exists(Function f, int i |
    dest = f.getParameter(i).getAnAccess() and
    label = "+arg" + i.toString() and
    parent = f
  )
  or
  exists(Function f | parent = f and label = "+vararg" and varArgRead(f, dest))
  or
  exists(FieldAccess fa |
    dest = fa and
    parent = fa.getQualifier().getFullyConverted() and
    label = fa.getTarget().getName() and
    lvalue(dest)
  )
  or
  exists(ThisExpr thisexpr |
    dest = thisexpr and
    label = "+this" and
    parent = thisexpr.getEnclosingFunction()
  )
  //
  // add more cases here
  //
}

/**
 * The values stored in src point to the compounds (destParent, destLabel).
 */
predicate pointerToCompound(Element destParent, string destLabel, Element src) {
  none()
  //
  // add more cases here
  //
}

/**
 * The type of agg is s, and the expression initializing the ith member
 * of s is child.
 */
pragma[noopt]
predicate aggregateLiteralChild(AggregateLiteral agg, Struct s, int i, Expr child) {
  // s = agg.getType().getUnderlyingType()
  exists(Type t |
    t = agg.getType() and
    agg instanceof AggregateLiteral and
    s = t.getUnderlyingType() and
    s instanceof Struct
  ) and
  exists(Expr beforeConversion |
    beforeConversion = agg.getChild(i) and
    child = beforeConversion.getFullyConverted()
  )
}

/**
 * The compound (parent, label) holds pointers to dest.
 */
predicate pointerFromCompound(Element parent, string label, Element dest) {
  exists(FieldAccess fa |
    dest = fa and
    parent = fa.getQualifier().getFullyConverted() and
    label = fa.getTarget().getName() and
    not lvalue(dest)
  )
  or
  exists(AggregateLiteral agg, Struct s, int i |
    parent = agg and
    not lvalue(dest) and
    aggregateLiteralChild(agg, s, i, dest) and
    label = s.getCanonicalMember(i).getName()
  )
  //
  // add more cases here
  //
}

predicate virtualArg(Expr receiver, VirtualFunction called, string arglabel, Expr arg) {
  exists(FunctionCall c, int i |
    receiver = c.getQualifier().getFullyConverted() and
    called = c.getTarget() and
    called.isVirtual() and
    arg = c.getArgument(i) and
    i >= 0 and
    if i < called.getNumberOfParameters()
    then arglabel = "+arg" + i.toString()
    else arglabel = "+vararg"
  )
}

predicate virtualThis(Expr receiver, VirtualFunction called, string thislabel, Expr thisexpr) {
  exists(FunctionCall c |
    receiver = c.getQualifier().getFullyConverted() and
    called = c.getTarget() and
    thislabel = "+this" and
    called.isVirtual() and
    thisexpr = receiver
  )
}

predicate virtualRet(Expr receiver, VirtualFunction called, string retlabel, FunctionCall c) {
  receiver = c.getQualifier().getFullyConverted() and
  called = c.getTarget() and
  called.isVirtual() and
  retlabel = "+ret"
}

private predicate compoundEdgeEntity(
  @element parent, @element element, string label, @element other, int kind
) {
  compoundEdge(mkElement(parent), mkElement(element), label, mkElement(other), kind)
}

/**
 * This relation combines all pointer and flow relations that
 * go to or from a compound set.
 *
 * The "kind" of each tuple determines what relation the other
 * four elements of the tuple indicate:
 *
 *   0 - flow from <parent,label> to other
 *   1 - flow from other to <parent,label>
 *   2 - pointer from <parent,label> to other
 *   3 - pointer from other to <parent,label>
 *
 *   4 - flow from <parent,element> to other
 *   5 - flow from other to <parent,element>
 *   6 - flow from <parent,element> to other
 *   7 - flow from other to <parent,element>
 *
 *   8 - flow from <<parent,element>,label> to other
 *   9 - flow from other to <<parent,element>,label>
 *  10 - pointer from <<parent,element>,label> to other
 *  11 - pointer from other to <<parent,element>,label>
 */
predicate compoundEdge(Element parent, Element element, string label, Element other, int kind) {
  flowFromCompound(parent, label, other) and element = parent and kind = 0
  or
  flowToCompound(parent, label, other) and element = parent and kind = 1
  or
  pointerFromCompound(parent, label, other) and element = parent and kind = 2
  or
  pointerToCompound(parent, label, other) and element = parent and kind = 3
  or
  resolve(parent, element, other) and label = "" and kind = 5
  or
  virtualRet(parent, element, label, other) and kind = 8
  or
  virtualArg(parent, element, label, other) and kind = 9
  or
  virtualThis(parent, element, label, other) and kind = 9
}

/**
 * A summary of the points-to information for the program, computed by
 * collapsing the various flow and pointer relations using the Java
 * class PointsToCalculator. This relation combines several kinds of information;
 * the different kinds are filtered out by several relations further
 * in the file: pointstosets, setflow, children, childrenByElement,
 * parentSetFor.
 *
 * The information represented by each tuple in the relation depends on
 * the "label" element.
 *
 * If the label is the empty string, then the tuple describes membership of
 * element "elem" in points-to set "ptset", and that children of the element
 * are children of set "parent".
 *
 * If the label is "--flow--", then the tuple describes flow from the "parent"
 * points-to set to the "ptset" points-to set.
 *
 * If the label is "--element--", then the tuple declares that the set "ptset" is
 * a child of "parent", where the label of the child is "elem".
 *
 * In any other case, the tuple declares that set "ptset" is a child of
 * "parent", where the label is "label".
 */
cached
predicate pointstoinfo(int parent, @element elem, string label, int ptset) =
  collapse(flowEntity/2, pointerEntity/2, compoundEdgeEntity/5, locationEntity/1)(parent, elem,
    label, ptset)

/**
 * Which elements are in which points-to sets.
 */
cached
predicate pointstosets(int ptset, @element elem) { pointstoinfo(_, elem, "", ptset) }

/**
 * The points-to set src flows to the points-to set dest.
 * This relation is not transitively closed.
 */
predicate setflow(int src, int dest) { pointstoinfo(src, _, "--flow--", dest) }

/**
 * The points-to set parentset, when dereferenced using the
 * given label, gives values in the points-to set childset.
 */
predicate children(int parentset, string label, int childset) {
  pointstoinfo(parentset, _, label, childset) and
  label != "" and
  label != "--element--" and
  label != "--flow--"
}

/**
 * The same as children(), except that the label is an element.
 */
predicate childrenByElement(int parentset, Element label, int childset) {
  pointstoinfo(parentset, unresolveElement(label), "--element--", childset)
}

/**
 * The ID of the parent set for the given expression. Children
 * of the given element should be looked up with children() and
 * childrenByElement() using this ID.
 */
pragma[noopt]
predicate parentSetFor(int cset, @element expr) {
  exists(string s | s = "" and pointstoinfo(cset, expr, s, _))
}

private predicate locationEntity(@element location) { location(mkElement(location)) }

/**
 * Things that are elements of points-to sets.
 */
predicate location(Element location) {
  location instanceof Variable or
  location instanceof Function or
  isAllocationExpr(location) or
  fopenCall(location) or
  allocateDescriptorCall(location)
}

/**
 * A call to the Unix system function socket(2).
 */
predicate allocateDescriptorCall(FunctionCall fc) {
  exists(string name |
    name = "socket" and
    fc.getTarget().hasGlobalName(name)
  )
}

/**
 * A points-to set that contains at least one interesting element, or
 * flows to one that does.
 */
private int interestingSet() {
  exists(PointsToExpr e |
    e.interesting() and
    pointstosets(result, unresolveElement(e))
  )
  or
  setflow(result, interestingSet())
}

/**
 * The elements that are either in the given points-to set, or
 * which flow into it from another set.  The results are restricted
 * to sets which are interesting.
 */
cached
predicate setlocations(int set, @element location) {
  set = interestingSet() and
  (
    location(mkElement(location)) and pointstosets(set, location)
    or
    exists(int middle | setlocations(middle, location) and setflow(middle, set))
  )
}

class PointsToExpr extends Expr {
  /**
   * This predicate is empty by default. It should be overridden and defined to
   * include just those expressions for which points-to information is desired.
   */
  predicate interesting() { none() }

  pragma[noopt]
  Element pointsTo() {
    this.interesting() and
    exists(int set, @element thisEntity, @element resultEntity |
      thisEntity = underlyingElement(this) and
      pointstosets(set, thisEntity) and
      setlocations(set, resultEntity) and
      resultEntity = localUnresolveElement(result)
    )
  }

  float confidence() { result = 1.0 / count(this.pointsTo()) }
}

// This is used above in a `pragma[noopt]` context, which prevents its
// customary inlining. We materialise it explicitly here.
private @element localUnresolveElement(Element e) { result = unresolveElement(e) }

/**
 * Holds if anything points to an element, that is, is equivalent to:
 * ```
 *   exists(PointsToExpr e | e.pointsTo() = elem)
 * ```
 */
predicate anythingPointsTo(Element elem) {
  location(elem) and pointstosets(interestingSet(), unresolveElement(elem))
}
