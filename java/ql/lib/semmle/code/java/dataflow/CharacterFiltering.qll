/**
 * Provides support for identifying callables that copy characters from an input string while
 * possibly dropping or replacing some characters.
 */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.DataFlow

private predicate isStringLike(Type type) {
  type.(RefType).getASupertype*().hasQualifiedName("java.lang", "CharSequence")
}

private predicate isReader(Type type) {
  type.(RefType).getASupertype*().hasQualifiedName("java.io", "Reader")
}

private predicate isCharacterOutput(Type type) {
  type.(Array).getElementType().(PrimitiveType).hasName("char")
  or
  type.(RefType).getASupertype*().hasQualifiedName("java.lang", "Appendable")
  or
  type.(RefType).getASupertype*().hasQualifiedName("java.io", "Writer")
}

private predicate occursInLoop(Expr expr, LoopStmt loop) {
  expr.getEnclosingStmt().getEnclosingStmt*() = loop
}

/**
 * Holds if `read` is a character or code point read from `input` during `loop`.
 */
private predicate readsCharacter(Parameter input, LoopStmt loop, Expr read) {
  exists(MethodCall call, VarAccess inputAccess |
    inputAccess.getVariable() = input and
    DataFlow::localExprFlow(inputAccess, call.getQualifier()) and
    call.getMethod().hasName("charAt") and
    read = call and
    occursInLoop(call, loop)
  )
  or
  exists(MethodCall call, VarAccess inputAccess |
    inputAccess.getVariable() = input and
    DataFlow::localExprFlow(inputAccess, call.getArgument(0)) and
    call.getMethod().hasQualifiedName("java.lang", "Character", "codePointAt") and
    read = call and
    occursInLoop(call, loop)
  )
  or
  exists(EnhancedForStmt forStmt, MethodCall toCharArray, VarAccess inputAccess |
    loop = forStmt and
    forStmt.getExpr() = toCharArray and
    toCharArray.getMethod().hasName("toCharArray") and
    inputAccess.getVariable() = input and
    DataFlow::localExprFlow(inputAccess, toCharArray.getQualifier()) and
    read = forStmt.getVariable().getVariable().getAnAccess() and
    occursInLoop(read, loop)
  )
  or
  exists(
    LocalVariableDecl reader, ClassInstanceExpr readerInit, Expr constructorArgument,
    VarAccess inputAccess, MethodCall readCall
  |
    reader.getType() = readerInit.getType() and
    isReader(reader.getType()) and
    reader.getInitializer() = readerInit and
    constructorArgument = readerInit.getAnArgument() and
    inputAccess.getVariable() = input and
    DataFlow::localExprFlow(inputAccess, constructorArgument) and
    readCall.getQualifier() = reader.getAnAccess() and
    readCall.getMethod().hasName("read") and
    read = readCall and
    occursInLoop(readCall, loop)
  )
}

/**
 * Holds if a character value can flow from `source` to `sink`.
 *
 * This is deliberately separate from normal taint tracking: character conversion is used only as
 * evidence for inferring a string-level summary.
 */
private predicate characterFlowStep(DataFlow::Node source, DataFlow::Node sink) {
  DataFlow::localFlowStep(source, sink)
  or
  exists(MethodCall conversion |
    conversion.getMethod().hasQualifiedName("java.lang", "Character", ["toChars", "toString"]) and
    source.asExpr() = conversion.getArgument(0) and
    sink.asExpr() = conversion
  )
}

private predicate characterFlows(Expr source, Expr sink) {
  characterFlowStep*(DataFlow::exprNode(source), DataFlow::exprNode(sink))
}

/**
 * Holds if `output` receives a character derived from `read` during `loop`.
 */
private predicate writesCharacter(LoopStmt loop, Expr read, Variable output) {
  exists(MethodCall write, Expr value |
    occursInLoop(write, loop) and
    write.getMethod().hasName(["append", "write"]) and
    write.getQualifier() = output.getAnAccess() and
    isCharacterOutput(output.getType()) and
    value = write.getArgument(0) and
    characterFlows(read, value)
  )
  or
  exists(AssignExpr write, ArrayAccess element |
    occursInLoop(write, loop) and
    write.getDest() = element and
    element.getArray() = output.getAnAccess() and
    isCharacterOutput(output.getType()) and
    characterFlows(read, write.getSource())
  )
  or
  exists(AssignAddExpr append |
    occursInLoop(append, loop) and
    append.getDest() = output.getAnAccess() and
    output.getType() instanceof TypeString and
    characterFlows(read, append.getSource())
  )
}

private predicate returnsOutput(Method method, Variable output) {
  exists(ReturnStmt returnStmt |
    returnStmt.getEnclosingCallable() = method and
    returnStmt.getExpr().getAChildExpr*() = output.getAnAccess()
  )
}

private predicate characterFilteringOutput(
  Method method, int inputPosition, LocalScopeVariable output
) {
  exists(Parameter input, LoopStmt loop, Expr read |
    input = method.getParameter(inputPosition) and
    isStringLike(input.getType()) and
    loop.getEnclosingCallable() = method and
    output.getCallable() = method
  |
    readsCharacter(input, loop, read) and
    writesCharacter(loop, read, output)
  )
}

/**
 * Holds if a call to a character-filtering method copies data from `input` to `output`.
 */
predicate characterFilteringCallStep(DataFlow::Node input, DataFlow::Node output) {
  exists(MethodCall call, int inputPosition, LocalScopeVariable filteredOutput |
    characterFilteringOutput(call.getMethod(), inputPosition, filteredOutput) and
    input.asExpr() = call.getArgument(inputPosition)
  |
    returnsOutput(call.getMethod(), filteredOutput) and output.asExpr() = call
    or
    exists(int outputPosition |
      filteredOutput = call.getMethod().getParameter(outputPosition) and
      output.asExpr() = call.getArgument(outputPosition)
    )
  )
}
