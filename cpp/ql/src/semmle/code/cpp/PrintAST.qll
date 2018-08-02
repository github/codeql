import cpp

private newtype TPrintASTConfiguration = MkPrintASTConfiguration()

class PrintASTConfiguration extends TPrintASTConfiguration {
  string toString() {
    result = "PrintASTConfiguration"
  }

  predicate shouldPrintFunction(Function func) {
    any()
  }
}

private predicate shouldPrintFunction(Function func) {
  exists(PrintASTConfiguration config |
    config.shouldPrintFunction(func)
  )
}

private Locatable getAChild(Locatable parent) {
  result = getChild(parent, _)
}

private Function getEnclosingFunction(Locatable ast) {
  getAChild*(result) = ast
}

private int getEntryPointIndex(Function func) {
  if func instanceof Constructor then
    result = count(func.(Constructor).getAnInitializer())
  else
    result = 0
}

private Locatable getChild(Locatable parent, int childIndex) {
  exists(Function func, Stmt entryPoint |
    parent = func and
    result = entryPoint and
    entryPoint = func.getEntryPoint() and
    childIndex = getEntryPointIndex(func)
  ) or
  exists(Function func, Expr childExpr |
    parent = func and
    result = childExpr and
    (
      childExpr = func.(Constructor).getInitializer(childIndex) or
      childExpr = func.(Destructor).getDestruction(childIndex - 1)
    )
  ) or
  exists(Stmt parentStmt |
    parentStmt = parent and
    (
      parentStmt.getChild(childIndex).(Expr).getFullyConverted() = result or
      parentStmt.getChild(childIndex).(Stmt) = result
    )
  ) or
  exists(Expr parentExpr, Expr childExpr |
    parent = parentExpr and
    result = childExpr and
    childExpr = parentExpr.getChild(childIndex).getFullyConverted()
  ) or
  exists(Conversion parentConv, Expr childExpr |
    parent = parentConv and
    result = childExpr and
    childExpr = parentConv.getExpr() and
    childIndex = 0
  ) or
  exists(DeclStmt declStmt, DeclarationEntry childEntry |
    parent = declStmt and
    result = childEntry and
    childEntry = declStmt.getDeclarationEntry(childIndex)
  ) or
  exists(VariableDeclarationEntry declEntry, Initializer init |
    parent = declEntry and
    result = init and
    init = declEntry.getVariable().getInitializer() and
    childIndex = 0
  ) or
  exists(Initializer init, Expr expr |
    parent = init and
    result = expr and
    expr = init.getExpr().getFullyConverted() and
    childIndex = 0
  )
}

private string getTypeString(Locatable ast) {
  if ast instanceof Expr then (
    exists(Expr expr |
      expr = ast and
      result = expr.getValueCategoryString() + ": " + expr.getType().toString()
    )
  )
  else if ast instanceof DeclarationEntry then (
    result = ast.(DeclarationEntry).getType().toString()
  )
  else (
    result = ""
  )
}

private string getExtraInfoString(Locatable ast) {
  if ast instanceof Cast then (
    result = ast.(Cast).getSemanticConversionString()
  )
  else (
    result = ""
  )
}

private string getValueString(Locatable ast) {
  if exists(ast.(Expr).getValue()) then
    result = "=" + ast.(Expr).getValue()
  else
    result = ""
}

private Locatable getChildByRank(Locatable parent, int rankIndex) {
  result = rank[rankIndex + 1](Locatable child, int id |
    child = getChild(parent, id) |
    child order by id
  )
}

language[monotonicAggregates]
private int getDescendantCount(Locatable ast) {
  result = 1 + sum(Locatable child |
    child = getChildByRank(ast, _) |
    getDescendantCount(child)
  )
}

private Locatable getParent(Locatable ast) {
  ast = getAChild(result)
}

private int getUniqueId(Locatable ast) {
  shouldPrintFunction(getEnclosingFunction(ast)) and
  if not exists(getParent(ast)) then 
    result = 0
  else
    exists(Locatable parent |
      parent = getParent(ast) and
      if ast = getChildByRank(parent, 0) then
        result = 1 + getUniqueId(parent)
      else
        exists(int childIndex, Locatable previousChild |
          ast = getChildByRank(parent, childIndex) and
          previousChild = getChildByRank(parent, childIndex - 1) and
          result = getUniqueId(previousChild) +
            getDescendantCount(previousChild)
        )
    )
}

query predicate printAST(string functionLocation,
    string function, int nodeId, int parentId, int childIndex, string ast,
    string extra, string value, string type, string astLocation) {
  exists(Function func, Locatable astNode |
    shouldPrintFunction(func) and
    func = getEnclosingFunction(astNode) and
    nodeId = getUniqueId(astNode) and
    if nodeId = 0 then (
      parentId = -1 and
      childIndex = 0
    )
    else (
      exists(Locatable parent |
        astNode = getChild(parent, childIndex) and
        parentId = getUniqueId(parent)
      )
    ) and
    functionLocation = func.getLocation().toString() and
    function = func.getFullSignature() and
    ast = astNode.toString() and
    extra = getExtraInfoString(astNode) and
    value = getValueString(astNode) and
    type = getTypeString(astNode) and
    astLocation = astNode.getLocation().toString()
  )    
}
