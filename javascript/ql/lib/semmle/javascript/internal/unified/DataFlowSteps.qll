overlay[local]
module;

private import minimal.minimal
private import JSUnified
private import DataFlowBuilder
private import Contents
private import UnifiedDataFlowInput

pragma[nomagic]
private predicate isForLoopVariable(Variable v) {
  v.getADeclarationStatement() = any(ForStmt stmt).getInit()
  or
  // Handle the somewhat rare case: `for (v; ...; ++v) { ... }`
  v.getADeclaration() = any(ForStmt stmt).getInit()
}

private predicate isLikelyArrayIndex(Expr e) {
  // Note: This is written like this to mimick the original behavior. Consider making this more precise.
  isForLoopVariable(e.(VarAccess).getVariable())
  or
  e.(PropAccess).getPropertyName() = "length"
}

private ContentSet getContentSetFromNode(AstNode node) {
  result = property(node.(Label).getName())
  or
  result = property(node.(Expr).getStringValue())
  or
  result = property(node.(Expr).getIntValue().toString())
  or
  isLikelyArrayIndex(node) and
  result = ArrayContent::anyElement()
}

private class InheritsCall extends CallExpr {
  InheritsCall() { this.getCalleeName() = "inherits" and this.getNumArgument() = 2 }
}

private class ExtendLikeCall extends CallExpr {
  ExtendLikeCall() { this.getCalleeName() = ["extend", "merge", "mixin"] }
}

predicate synthesizeNode(AstNode node, string tag, ControlFlowNode cfgNode) {
  node instanceof NewExpr and
  tag = ["allocation-site", "prototype"] and
  cfgNode = node
  or
  exists(ClassDefinition cls |
    node = cls and
    tag = "super-prototype" and
    cfgNode = cls.getSuperClass()
  )
  or
  (
    node = any(ImportDeclaration d).getImportedPathExpr() or
    node = any(ReExportDeclaration d).getImportedPathExpr() or
    node = any(DynamicImportExpr d).getImportedPathExpr()
  ) and
  tag = "imported-module" and
  cfgNode = node
  or
  exists(InheritsCall call |
    node = call.getAnArgument() and
    cfgNode = call and
    tag = "inherit-prototype"
  )
  or
  node instanceof JsxElement and
  tag = "jsx-props" and
  cfgNode = node
}

Node getSuperPrototypeOf(ClassDefinition node) { result.isSyntheticNode(node, "super-prototype") }

private Function toFunction(AstNode node) {
  result = node
  or
  result = node.(ClassDefinition).getConstructor().getBody()
}

Node getPrototypeOf(AstNode node) {
  result.isNamespaceObject(NamespaceObject::prototype(toFunction(node)))
}

private class StepJS extends Step {
  pragma[nomagic]
  predicate readProperty(string name) { this.read(property(name)) }

  pragma[nomagic]
  predicate storeProperty(string name) { this.store(property(name)) }
}

class DataFlowStepsImpl extends DataFlowSteps {
  override predicate step(Node node1, Step step, Node node2) { stepJs(node1, step, node2) }
}

pragma[inline]
predicate stepJs(Node node1, StepJS step, Node node2) {
  exists(ParExpr e |
    node1.isValueOf(e.getExpression()) and
    step.value() and
    node2.isValueOf(e)
    // TODO: eliminate parentheses in extractos
  )
  or
  exists(ArrayExpr e |
    exists(int i, Expr element |
      element = e.getElement(i) and
      node1.isValueOf(element) and
      (
        if i > e.getFirstSpreadIndex()
        then step.store(ArrayContent::anyElement())
        else
          if i = e.getFirstSpreadIndex()
          then step.transform(Transforms::shiftArrayElements(i))
          else step.store(ArrayContent::elementAt(i))
      ) and
      node2.isValueOf(e)
    )
    or
    exists(SpreadElement spread | spread = e.getAnElement() |
      node1.isValueOf(spread.getOperand()) and
      (step.read(ArrayContent::anyElement()) or step.taint()) and
      node2.isValueOf(spread)
    )
  )
  or
  exists(ObjectExpr e |
    node1.isNamespaceObject(NamespaceObject::allocationSite(e)) and
    step.value() and
    node2.isValueOf(e)
    or
    exists(Property prop | prop = e.getAProperty() |
      prop instanceof ValueProperty and
      node1.isValueOf(prop.getInit()) and
      step.storeProperty(prop.getName()) and
      node2.isValueOf(e)
      or
      prop instanceof SpreadProperty and
      node1.isValueOf(prop.getInit().(SpreadElement).getOperand()) and
      (step.withContent(anyProperty()) or step.taint()) and
      node2.isValueOf(e)
      or
      prop instanceof PropertyGetter and
      node1.isValueOf(prop.getInit()) and
      step.storeAsGetter(getContentSetFromNode(prop.getNameExpr())) and
      node2.isValueOf(e)
      or
      prop instanceof PropertySetter and
      node1.isValueOf(prop.getInit()) and
      step.storeAsSetter(getContentSetFromNode(prop.getNameExpr())) and
      node2.isValueOf(e)
    )
  )
  or
  exists(ObjectPattern e |
    exists(PropertyPattern prop | prop = e.getAPropertyPattern() |
      node1.isIncomingValue(e) and
      step.readProperty(prop.getName()) and
      node2.isIncomingValue(prop.getValuePattern())
      or
      node1.isValueOf(prop.getDefault()) and
      step.value() and
      node2.isIncomingValue(prop.getValuePattern())
    )
    or
    node1.isIncomingValue(e) and
    step.value() and
    node2.isIncomingValue(e.getRest())
  )
  or
  exists(ArrayPattern e |
    exists(int i |
      node1.isIncomingValue(e) and
      step.read(ArrayContent::elementAt(i)) and
      node2.isIncomingValue(e.getElement(i))
      or
      node1.isValueOf(e.getDefault(i)) and
      step.value() and
      node2.isIncomingValue(e.getElement(i))
    )
    or
    node1.isIncomingValue(e) and
    step.transform(Transforms::shiftArrayElements(-e.getSize())) and
    node2.isIncomingValue(e.getRest())
  )
  or
  exists(Function e |
    node1.isCallable(e) and
    step.value() and
    (
      if e instanceof FunctionDeclStmt
      then node2.isIncomingValue(e.getIdentifier())
      else node2.isValueOf(e)
    )
    or
    // For named function expressions (`return function blah() { ... }`), the function name is in scope
    // within the function itself.
    e instanceof FunctionExpr and
    node1.isCallableSelfReferenceParameter(e) and
    step.value() and
    node2.isIncomingValue(e.getIdentifier())
    or
    e instanceof FunctionDeclStmt and
    node1.isIncomingValue(e.getIdentifier()) and
    step.value() and
    node2.isValueOf(e)
    or
    node1.isNamespaceObject(NamespaceObject::allocationSite(e)) and
    step.value() and
    node2.isCallableSelfReferenceParameter(e) // TODO: tell the framework that the namespace and callable are the same thing
  )
  or
  exists(SeqExpr e |
    node1.isValueOf(e.getLastOperand()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(ConditionalExpr e |
    node1.isValueOf(e.getABranch()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(InvokeExpr e, Call call | call.asOrdinaryCall() = e |
    exists(int i |
      node1.isValueOf(e.getArgument(i)) and
      not i = e.getFirstSpreadIndex() and
      (
        if i > e.getFirstSpreadIndex()
        then step.store(ArrayContent::anyElement())
        else step.store(ArrayContent::elementAt(i))
      ) and
      node2.isArgumentObject(call)
      or
      i = e.getFirstSpreadIndex() and
      node1.isValueOf(e.getArgument(i).(SpreadElement).getOperand()) and
      step.transform(Transforms::shiftArrayElements(i)) and
      node2.isArgumentObject(call)
    )
    or
    exists(SpreadElement spread | spread = e.getAnArgument() |
      node1.isValueOf(spread.getOperand()) and
      (step.read(ArrayContent::anyElement()) or step.taint()) and
      node2.isValueOf(spread)
    )
    or
    node1.isValueOf(e.getCallee()) and
    step.value() and
    node2.isCallTarget(call)
    or
    node1.isValueOf(e.(CallExpr).getReceiver()) and
    step.value() and
    node2.isReceiverArgument(call)
    or
    node1.isReturnValueFromCall(call) and
    step.value() and
    node2.isValueOf(e)
    or
    node1.isExceptionThrownFromCall(call) and // TODO: can this be moved into the framework?
    step.value() and
    node2.isExceptionTargetFromContext(e)
    or
    e instanceof NewExpr and
    (
      node1.isValueOf(e.getCallee()) and
      step.instantiate() and
      node2.isSyntheticNode(e, "allocation-site")
      or
      node1.isSyntheticNode(e, "allocation-site") and
      step.value() and
      node2.isReceiverArgument(call)
      or
      (node1.isReceiverArgument(call) or node1.isPostUpdatedReceiverArgument(call)) and
      step.value() and
      node2.isValueOf(e)
    )
    or
    e instanceof SuperCall and // `super()` call in a constructor
    (
      node1.isVariableRead(e.getContainer().getScope().getVariable("this")) and
      step.value() and
      node2.isReceiverArgument(call)
      or
      exists(ClassDefinition cls |
        e.(SuperCall).getBinder() = cls.getConstructor().getBody() and
        node1.isValueOf(cls.getSuperClass()) and
        step.value() and
        node2.isCallTarget(call)
      )
    )
  )
  or
  exists(MethodCallExpr e, Call reflectiveCall | reflectiveCall.asReflectiveCall() = e |
    node1.isValueOf(e.getReceiver()) and
    step.value() and
    node2.isCallTarget(reflectiveCall)
    or
    node1.isValueOf(e.getArgument(0)) and
    step.value() and
    node2.isReceiverArgument(reflectiveCall)
    or
    e.getMethodName() = "call" and
    exists(int i |
      i >= 1 and
      node1.isValueOf(e.getArgument(i)) and
      step.store(ArrayContent::elementAt(i - 1)) and
      node2.isArgumentObject(reflectiveCall)
    )
    or
    e.getMethodName() = "apply" and
    node1.isValueOf(e.getArgument(1)) and
    step.transform(Transforms::toArray()) and
    node2.isArgumentObject(reflectiveCall)
    or
    // Forward out nodes to the outer call
    exists(Call ordinaryCall | ordinaryCall.asOrdinaryCall() = e |
      node1.isReturnValueFromCall(reflectiveCall) and
      step.value() and
      node2.isReturnValueFromCall(ordinaryCall)
      or
      node1.isExceptionThrownFromCall(reflectiveCall) and
      step.value() and
      node2.isExceptionThrownFromCall(ordinaryCall)
    )
  )
  or
  exists(PropAccess prop |
    // TODO: also handle optional prop access `x?.f`
    node1.isValueOf(prop.getBase()) and
    (
      step.read(getContentSetFromNode(prop.getPropertyNameExpr()))
      or
      not exists(getContentSetFromNode(prop.getPropertyNameExpr())) and
      step.read(ArrayContent::anyElement())
    ) and
    node2.isValueOf(prop)
    or
    node1.isIncomingValue(prop) and
    step.store(getContentSetFromNode(prop.getPropertyNameExpr())) and
    node2.isPostUpdatedValue(prop.getBase())
  )
  or
  exists(VarRef e |
    node1.isIncomingValue(e) and
    step.value() and
    node2.isVariableWrite(e.getVariable())
    or
    node1.isVariableRead(e.getVariable()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(ThisExpr e |
    node1.isVariableRead(e.getBindingContainer().getScope().getVariable("this")) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(AddExpr e |
    node1.isValueOf(e.getAnOperand()) and
    step.taint() and
    node2.isValueOf(e)
  )
  or
  exists(LogAndExpr e |
    node1.isValueOf(e.getRightOperand()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(LogOrExpr e |
    node1.isValueOf(e.getAnOperand()) and
    step.value() and // TODO: add step.ifTruthy() for flow out of left operand?
    node2.isValueOf(e)
  )
  or
  exists(NullishCoalescingExpr e |
    node1.isValueOf(e.getAnOperand()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(Assignment e |
    // Whatever gets assigned to the LHS is also returned by the assignment
    node1.isIncomingValue(e.getLhs()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(AssignExpr e |
    // plain assignment
    node1.isValueOf(e.getRhs()) and
    step.value() and
    node2.isIncomingValue(e.getLhs())
  )
  or
  exists(AssignAddExpr e |
    node1.isValueOf([e.getLhs(), e.getRhs()]) and
    step.taint() and
    node2.isIncomingValue(e.getLhs())
  )
  or
  exists(AssignLogOrExpr e |
    node1.isValueOf([e.getLhs(), e.getRhs()]) and
    step.value() and
    node2.isIncomingValue(e.getLhs())
  )
  or
  exists(AssignLogAndExpr e |
    node1.isValueOf(e.getRhs()) and
    step.value() and
    node2.isIncomingValue(e.getLhs())
    or
    // If the LHS is already truthy, then that's the return value of the expression
    // (the assignment does not take place in this case)
    node1.isValueOf(e.getLhs()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(AssignNullishCoalescingExpr e |
    node1.isValueOf([e.getLhs(), e.getRhs()]) and
    step.value() and
    node2.isIncomingValue(e.getLhs())
  )
  or
  exists(YieldExpr e |
    node1.isValueOf(e.getOperand()) and
    (if e.isDelegating() then step.transform(Transforms::readIterableContents()) else step.value()) and
    node2.isInnerReturnValue(e.getContainer())
  )
  or
  exists(ForOfComprehensionBlock e |
    node1.isValueOf(e.getDomain()) and
    step.transform(Transforms::readIterableContents()) and
    node2.isIncomingValue(e.getIterator())
  )
  or
  exists(ForInComprehensionBlock e |
    node1.isValueOf(e.getDomain()) and
    step.taint() and
    node2.isIncomingValue(e.getIterator())
  )
  or
  exists(ArrayComprehensionExpr e |
    node1.isValueOf(e.getBody()) and
    step.store(ArrayContent::anyElement()) and
    node2.isValueOf(e)
  )
  or
  exists(GeneratorExpr e |
    node1.isValueOf(e.getBody()) and
    step.store(Contents::iteratorElement()) and
    node2.isValueOf(e)
  )
  or
  exists(LegacyLetExpr e |
    node1.isValueOf(e.getBody()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(ImmediatelyInvokedFunctionExpr e |
    exists(e) and
    // TODO: should we optimise for this case in language-specific code?
    none()
  )
  or
  exists(AwaitExpr e |
    node1.isValueOf(e.getOperand()) and
    step.transform(Transforms::awaitValue()) and
    node2.isValueOf(e)
    or
    node1.isValueOf(e.getOperand()) and
    step.read(Contents::promiseError()) and
    node2.isExceptionTargetFromContext(e)
  )
  or
  exists(FunctionSentExpr e |
    // Not implemented yet (also not in baseline)
    exists(e) and none()
  )
  or
  exists(FunctionBindExpr e |
    // Partial invocation not handled here
    exists(e) and none()
  )
  or
  exists(DynamicImportExpr e |
    node1.isSyntheticNode(e.getImportedPathExpr(), "imported-module") and
    step.store(Contents::promiseValue()) and
    node2.isValueOf(e)
  )
  or
  exists(OptionalUse e | exists(e) and none()) // TODO: add filtered steps so this can also be used for nullness/type analysis?
  or
  exists(ImportMetaExpr e |
    node1.isUnknown() and
    step.value() and
    node2.isValueOf(e)
  )
  or
  // exists(Templating::TemplatePlaceholderTag tag |
  //   node1.isValueOf(tag.getInnerTopLevel().getExpression()) and
  //   step.value() and // TODO: mark safe for jump?
  //   node2.isValueOf(tag.getEnclosingExpr())
  // )
  // or
  exists(Function f |
    node1.isValueOf(f.getAReturnedExpr()) and
    step.value() and
    node2.isInnerReturnValue(f)
    or
    f.isAsync() and
    not f.isGenerator() and
    (
      node1.isInnerReturnValue(f) and
      step.transform(Transforms::toPromise()) and
      node2.isReturnValue(f)
      or
      node1.isInnerExceptionalReturnValue(f) and
      step.store(Contents::promiseError()) and
      node2.isReturnValue(f)
    )
    or
    f.isGenerator() and
    not f.isAsync() and
    (
      node1.isInnerReturnValue(f) and
      step.store(Contents::iteratorElement()) and
      node2.isReturnValue(f)
      or
      node1.isInnerExceptionalReturnValue(f) and
      step.store(Contents::iteratorError()) and
      node2.isReturnValue(f)
    )
    or
    f.isGenerator() and
    f.isAsync() and
    (
      node1.isInnerReturnValue(f) and
      step.transform(Transforms::toAsyncIteratorElement()) and
      node2.isReturnValue(f)
      or
      node1.isInnerExceptionalReturnValue(f) and
      step.store(Contents::iteratorError()) and
      node2.isReturnValue(f)
    )
    or
    node1.isParameterObject(f) and
    (
      exists(int i |
        step.read(ArrayContent::elementAt(i)) and
        node2.isIncomingValue(f.getParameter(i)) and
        not f.getParameter(i).isRestParameter()
      )
      or
      f.usesArgumentsObject() and
      step.withContent(ArrayContent::anyElement()) and
      node2.isVariableWrite(f.getArgumentsVariable())
      or
      exists(Parameter rest |
        rest = f.getRestParameter() and
        step.transform(Transforms::shiftArrayElements(-rest.getIndex())) and
        node2.isIncomingValue(rest)
      )
    )
    or
    node1.isReceiverParameter(f) and
    step.value() and
    node2.isVariableWrite(f.getScope().getVariable("this"))
    or
    node1 = getPrototypeOf(f) and
    step.storeProperty("prototype") and
    node2.isNamespaceObject(NamespaceObject::allocationSite(f))
    or
    // To handle assignments to .prototype, read the new value back into the prototype node
    node2.isNamespaceObject(NamespaceObject::allocationSite(f)) and
    step.readProperty("prototype") and
    node1 = getPrototypeOf(f)
    or
    node1.isNamespaceObject(NamespaceObject::allocationSite(f)) and
    step.value() and
    (
      if f instanceof FunctionDeclStmt
      then node2.isIncomingValue(f.getIdentifier())
      else node2.isValueOf(f)
    )
  )
  or
  exists(ThrowStmt e |
    node1.isValueOf(e.getExpr()) and
    step.value() and
    node2.isExceptionTargetFromContext(e)
  )
  or
  exists(TryStmt e |
    node1.isInterceptedException(e.getBody()) and
    step.value() and
    // Note: standard JS only allow at most one catch clause, but some old dialects support more
    // Just propagate to all catch clauses
    node2.isIncomingValue(e.getACatchClause().getAParameter())
  )
  or
  exists(ForInStmt stmt |
    node1.isValueOf(stmt.getIterationDomain()) and
    step.taint() and
    node2.isIncomingValue(stmt.getLValue())
  )
  or
  exists(ForOfStmt stmt |
    node1.isValueOf(stmt.getIterationDomain()) and
    (
      if stmt.isAwait()
      then step.transform(Transforms::readAsyncIterableContents())
      else step.transform(Transforms::readIterableContents())
    ) and
    node2.isIncomingValue(stmt.getLValue())
    or
    node1.isValueOf(stmt.getIterationDomain()) and
    step.read(Contents::iteratorError()) and
    node2.isExceptionTargetFromContext(stmt)
  )
  or
  exists(ForEachStmt stmt |
    // Note: this is a `for each` statement from legacy JS dialects. Not standard JS.
    node1.isValueOf(stmt.getIterationDomain()) and
    step.transform(Transforms::readIterableContents()) and
    node2.isIncomingValue(stmt.getLValue())
  )
  or
  exists(VariableDeclarator decl |
    node1.isValueOf(decl.getInit()) and
    step.value() and
    node2.isIncomingValue(decl.getBindingPattern())
  )
  or
  exists(ImportDeclaration imprt |
    node1.isSyntheticNode(imprt.getImportedPathExpr(), "imported-module") and
    step.value() and
    node2.isIncomingValue(imprt.getASpecifier())
  )
  or
  exists(NamedImportSpecifier e |
    node1.isIncomingValue(e) and
    step.readProperty(e.getImportedName()) and
    node2.isIncomingValue(e.getLocal()) // TODO: imported locals don't act as true local variables; their reads are syntactic sugar for property reads and can change value from read to read
  )
  or
  exists(ImportNamespaceSpecifier e |
    node1.isIncomingValue(e) and
    step.value() and
    node2.isIncomingValue(e.getLocal())
  )
  or
  exists(ImportDefaultSpecifier e |
    node1.isIncomingValue(e) and
    step.readProperty("default") and // TODO: handle non-standard 'default' semantics
    node2.isIncomingValue(e.getLocal())
  )
  or
  exists(FieldDeclaration e |
    node1.isValueOf(e.getInit()) and
    step.store(getContentSetFromNode(e.getNameExpr())) and
    (
      if e.isStatic()
      then node2.isVariableRead(e.getDeclaringClass().getVariable())
      else
        node2
            .isVariableRead(e.getDeclaringClass()
                  .getConstructor()
                  .getBody()
                  .getScope()
                  .getVariable("this"))
    )
  )
  or
  exists(MethodDeclaration method, ContentSet contents |
    not method instanceof ConstructorDeclaration
  |
    node1.isValueOf(method.getInit()) and
    contents = getContentSetFromNode(method.getNameExpr()) and
    (
      if method instanceof SetterMethodDeclaration
      then step.storeAsSetter(contents)
      else
        if method instanceof GetterMethodDeclaration
        then step.storeAsGetter(contents)
        else step.store(contents)
    ) and
    if method.isStatic()
    then node2.isVariableRead(method.getDeclaringClass().getVariable())
    else node2 = getPrototypeOf(method.getDeclaringClass())
  )
  or
  // Note: "class declarations" in JavaScript are syntactic sugar for plain functions and properties. This just models the desugaring.
  exists(ClassDefinition cls |
    node1.isValueOf(cls.getConstructor().getBody()) and
    step.value() and
    (
      node2.isIncomingValue(cls.getIdentifier())
      or
      not exists(cls.getIdentifier()) and
      node2.isVariableWrite(cls.getVariable())
    )
    or
    // To ensure static members are assigned before 'cls' returns, model the return as a read of the class variable
    node1.isVariableRead(cls.getVariable()) and
    step.value() and
    node2.isValueOf(cls)
    or
    node1.isValueOf(cls.getSuperClass()) and
    step.storeBaseObject() and
    node2.isValueOf(cls.getConstructor().getBody())
    or
    node1.isValueOf(cls.getSuperClass()) and
    step.readProperty("prototype") and
    node2 = getSuperPrototypeOf(cls)
    or
    node1 = getSuperPrototypeOf(cls) and
    step.storeBaseObject() and
    node2 = getPrototypeOf(cls)
  )
  or
  exists(TopLevel top |
    node1.isNamespaceObject(NamespaceObject::moduleExportsObject(top)) and
    step.storeProperty("exports") and
    node2.isNamespaceObject(NamespaceObject::moduleObject(top))
    or
    // To simply handling of `module.exports = {...}` assignments,
    // make stored values flow back into the canonical exports-object node.
    node1.isNamespaceObject(NamespaceObject::moduleObject(top)) and
    step.readProperty("exports") and
    node2.isNamespaceObject(NamespaceObject::moduleExportsObject(top))
    or
    node1.isNamespaceObject(NamespaceObject::moduleObject(top)) and
    step.value() and
    node2.isVariableWrite(top.getScope().getVariable("module"))
    or
    node1.isNamespaceObject(NamespaceObject::moduleExportsObject(top)) and
    step.value() and
    node2.isVariableWrite(top.getScope().getVariable("exports"))
    or
    // Implement "default" interop for compatibility with various compilers/bundlers
    // If a module does not explicitly have a "default" export, use the entire module as the default export.
    not exists(ExportDefaultDeclaration decl | decl.getTopLevel() = top) and
    node1.isNamespaceObject(NamespaceObject::moduleExportsObject(top)) and
    step.storeProperty("default") and
    node2 = node1
    or
    // Conversely, a module that solely consists of a default export should also be importable
    // as a namespace
    exists(ExportDefaultDeclaration decl |
      decl = unique(ExportDeclaration d | d.getTopLevel() = top) and
      node1.isValueOf(decl.getOperand()) and
      step.storeProperty("exports") and
      node2.isNamespaceObject(NamespaceObject::moduleObject(top))
    )
  )
  or
  exists(ExportNamedDeclaration decl, Variable v, string name |
    decl.exportsDirectlyAs(v, name) and
    node1.isIncomingValue(v.getAReference()) and
    step.storeProperty(name) and
    node2.isNamespaceObject(NamespaceObject::moduleExportsObject(decl.getContainer()))
  )
  or
  exists(ExportDefaultDeclaration decl |
    node1.isValueOf(decl.getOperand()) and
    step.storeProperty("default") and
    node2.isNamespaceObject(NamespaceObject::moduleExportsObject(decl.getContainer()))
  )
  or
  exists(SelectiveReExportDeclaration reExport, ExportSpecifier spec |
    spec = reExport.getASpecifier()
  |
    node1.isSyntheticNode(reExport.getImportedPathExpr(), "imported-module") and
    (
      // export { x as y } from '..'
      step.readProperty(spec.getLocalName())
      or
      // export * as y from '..'
      spec instanceof ExportNamespaceSpecifier and
      step.value()
    ) and
    node2.isValueOf(spec)
    or
    node1.isValueOf(spec) and
    step.storeProperty(spec.getExportedName()) and
    node2.isNamespaceObject(NamespaceObject::moduleExportsObject(reExport.getContainer()))
  )
  or
  exists(BulkReExportDeclaration reExport, TopLevel top | top = reExport.getContainer() |
    node1.isSyntheticNode(reExport.getImportedPathExpr(), "imported-module") and
    step.withoutContent(Contents::shadowedFromBulkExport(top)) and
    node2.isNamespaceObject(NamespaceObject::moduleExportsObject(top))
  )
  or
  exists(InheritsCall call |
    // inherits(Class, SuperClass) should result in the storeBase step:
    //
    //   SuperClass.prototype --> Class.prototype
    //
    // We use some synthetic nodes to load both the prototypes
    exists(Expr arg | arg = call.getAnArgument() |
      node1.isValueOf(arg) and
      step.readProperty("prototype") and
      node2.isSyntheticNode(arg, "inherit-prototype")
    )
    or
    node1.isSyntheticNode(call.getArgument(1), "inherit-prototype") and
    step.storeBaseObject() and
    node2.isSyntheticNode(call.getArgument(0), "inherit-prototype")
  )
  or
  exists(ExtendLikeCall call |
    node1.isValueOf(call.getArgument(any(int i | i >= 1))) and
    step.storeBaseObject() and
    node2.isValueOf(call.getArgument(0))
    or
    node1.isValueOf(call.getArgument(0)) and
    step.value() and
    node2.isValueOf(call)
  )
  or
  exists(FieldParameter param, Function f |
    param = f.getAParameter() and
    node1.isIncomingValue(param) and
    step.storeProperty(param.getName()) and
    node2.isVariableRead(f.getScope().getVariable("this"))
  )
  or
  exists(TypeAssertion e |
    node1.isValueOf(e.getExpression()) and
    step.value() and
    node2.isValueOf(e)
  )
  or
  exists(JsxElement e, Call call | call.asJsxCall() = e |
    node1.isValueOf(e.getNameExpr()) and
    step.value() and
    node2.isCallTarget(call)
    or
    node1.isSyntheticNode(e, "jsx-props") and
    step.store(ArrayContent::elementAt(0)) and
    node2.isArgumentObject(call)
    or
    exists(JsxAttribute attr |
      attr = e.getAnAttribute() and
      node1.isValueOf(attr.getValue()) and
      step.storeProperty(attr.getName()) and
      node2.isSyntheticNode(e, "jsx-props")
    )
  )
}
