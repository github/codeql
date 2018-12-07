/**
 * Provides a `backEdge` predicate, which can be useful when looking for
 * cycles in the control flow graph.
 *
 * The implementation works by traversing the abstract syntax tree and
 * assigning "entry" and "exit" indices to every element (corresponding
 * roughly to pre- and post-order numberings).  We then choose an index for
 * every element: usually the exit index, but for some nodes types, such as
 * `ReturnStmt`, the results are better if we use the entry index instead.
 * We then classify an edge as a back-edge if the index of the destination
 * is less than or equal to the index of the source.
 */

import cpp

/**
 * Holds if there is a parent-child relationship between `parent` and
 * `child`. For some nodes, we tinker with the order of the children to get
 * indices that correspond better to the normal control flow order. For
 * example, we want the condition of a DoStmt to get a higher index the
 * loop body.
 */
private predicate parents(Element parent, int i, Element child) {
  if parent instanceof ForStmt then (
    exists (ForStmt loop
    | loop = parent
    | (child = loop.getInitialization() and i = 0) or
      (child = loop.getCondition() and i = 1) or
      (child = loop.getStmt() and i = 2) or
      (child = loop.getUpdate() and i = 3))
  ) else if parent instanceof DoStmt then (
    exists (DoStmt loop
    | loop = parent
    | (child = loop.getStmt() and i = 0) or
      (child = loop.getCondition() and i = 1))
  ) else if parent instanceof AssignExpr then (
    exists (Assignment assign
    | assign = parent
    | (child = assign.getRValue() and i = 0) or
      (child = assign.getLValue() and i = 1))
  ) else if parent instanceof FunctionCall then (
    exists (FunctionCall call
    | call = parent
    | child = call.getArgument(i) or
      (child = call.getQualifier() and i = call.getNumChild() - 1))
  ) else if parent instanceof ExprCall then (
    exists (ExprCall call
    | call = parent
    | child = call.getArgument(i) or
      (child = call.getExpr() and i = call.getNumChild() - 1))
  ) else (
    exprparents(child,i,parent) or
    stmtparents(child,i,parent) or
    stmt_decl_bind(parent,i,child) or
    (initialisers(child,parent,_,_) and i = 0)
  )
}

/**
 * Sometimes, there's a child with index -1. This is inconvenient, so we
 * use `rank` to assigned the children zero-based indices.
 */
private Element getElementChild(Element element, int childIdx) {
  result =
    rank[childIdx+1](Element child, int i
    | // There are some elements that have both kinds of children
      // (expressions and statements), but their indices never overlap.
      // For example, a `for` loop has two expr children and two stmt
      // children, but the indices of the statements are 0 and 3 and the
      // indices of the expressions are 1 and 2. However, it does sometimes
      // happen that the same element is listed multiple times with
      // different indices. For example, in the expression `a?:b` `a` has
      // index 0 and 1.
      i = min (int j | parents(element, j, child) | j)
    | child order by i)
}

/**
 * Gets the total number of nodes in the abstract syntax tree for this
 * expression.
 */
language[monotonicAggregates]
private int elementSize(Element element) {
  result =
    2 + // Add 1 for the entry index and 1 for the exit index.
    sum (Element child
    | child = getElementChild(element, _)
    | elementSize(child))
}

private int elementEntryIndex(Element element) {
  if element = any(Function f).getEntryPoint() then
    result = 0
  else if element = getElementChild(_,0) then
    exists (Element parent
    | element = getElementChild(parent, 0) and
      // Add 1 so that every node has a unique entry index.
      result = 1 + elementEntryIndex(parent))
  else
    exists (Element parent, int i, Element prevChild
    | element = getElementChild(parent,i) and
      prevChild = getElementChild(parent,i-1) and
      // Add 1 so that the entry and exit indices are disjoint.
      result = 1 + elementExitIndex(prevChild))
}

private int elementExitIndex(Element element) {
  result = elementEntryIndex(element) + elementSize(element) - 1
}

/**
 * Gets the index for the element, which will be used to determine which
 * edges are back-edges.
 */
private int elementIndex(Element element) {
  if (element instanceof Block or
      element instanceof IfStmt or
      element instanceof ForStmt or
      element instanceof WhileStmt or
      element instanceof DoStmt or
      element instanceof ReturnStmt or
      element instanceof SwitchStmt or
      element instanceof ConditionalExpr or
      element instanceof BinaryLogicalOperation or
      element instanceof ExprStmt or
      element instanceof VlaDimensionStmt or
      element instanceof AsmStmt or
      element instanceof DeclStmt or
      element instanceof Initializer)
    then result = elementEntryIndex(element)
    else result = elementExitIndex(element)
}

/** Holds if there is a back-edge from `src` to `dst`. */
cached predicate backEdge(ControlFlowNode src, ControlFlowNode dst) {
  dst = src.getASuccessor() and
  elementIndex(dst) <= elementIndex(src)
}
