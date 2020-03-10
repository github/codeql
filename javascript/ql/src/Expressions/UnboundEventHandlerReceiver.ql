/**
 * @name Unbound event handler receiver
 * @description Invoking an event handler method as a function can cause a runtime error.
 * @kind problem
 * @problem.severity error
 * @id js/unbound-event-handler-receiver
 * @tags correctness
 * @precision high
 */

import javascript

/**
 * Holds if the receiver of `method` is bound.
 */
private predicate isBoundInMethod(MethodDeclaration method) {
  exists(DataFlow::ThisNode thiz, MethodDeclaration bindingMethod, string name |
    bindingMethod.getDeclaringClass() = method.getDeclaringClass() and
    not bindingMethod.isStatic() and
    thiz.getBinder().getAstNode() = bindingMethod.getBody() and
    name = method.getName()
  |
    // binding assignments: `this[x] = <expr>.bind(...)`
    exists(DataFlow::MethodCallNode bind, DataFlow::PropWrite w |
      not exists(w.getPropertyName()) or // unknown name, assume everything is bound
      w.getPropertyName() = name
    |
      w = thiz.getAPropertyWrite() and
      bind.getMethodName() = "bind" and
      bind.flowsTo(w.getRhs())
    )
    or
    // library binders
    exists(string mod |
      mod = "auto-bind" or
      mod = "react-autobind"
    |
      thiz.flowsTo(DataFlow::moduleImport(mod).getACall().getArgument(0))
    )
    or
    // heuristic reflective binders
    exists(DataFlow::CallNode binder, string calleeName |
      (
        binder.(DataFlow::MethodCallNode).getMethodName() = calleeName or
        binder.getCalleeNode().asExpr().(VarAccess).getVariable().getName() = calleeName
      ) and
      calleeName.regexpMatch("(?i).*bind.*") and
      thiz.flowsTo(binder.getAnArgument()) and
      // exclude the binding assignments
      not thiz.getAPropertySource() = binder
    |
      // `myBindAll(this)`
      binder.getNumArgument() = 1
      or
      // `myBindSome(this, [<name1>, <name2>])`
      exists(DataFlow::ArrayCreationNode names |
        names.flowsTo(binder.getAnArgument()) and
        names.getAnElement().mayHaveStringValue(name)
      )
      or
      // `myBindSome(this, <name1>, <name2>)`
      binder.getAnArgument().mayHaveStringValue(name)
    )
  )
  or
  exists(Expr decoration, string name |
    (
      decoration = method.getADecorator().getExpression()
      or
      decoration = method.getDeclaringType().(ClassDefinition).getADecorator().getExpression()
    ) and
    name.regexpMatch("(?i).*(bind|bound).*")
  |
    // `@autobind`
    decoration.(Identifier).getName() = name
    or
    // `@action.bound`
    decoration.(PropAccess).getPropertyName() = name
  )
}

/**
 * Gets an event handler attribute (onClick, onTouch, ...).
 */
private DOM::AttributeDefinition getAnEventHandlerAttribute() {
  exists(ReactComponent c, JSXNode rendered, string attributeName |
    c.getRenderMethod().getAReturnedExpr().flow().getALocalSource().asExpr() = rendered and
    result = rendered.getABodyElement*().(JSXElement).getAttributeByName(attributeName) and
    attributeName.regexpMatch("on[A-Z][a-zA-Z]+") // camelCased with 'on'-prefix
  )
}

from MethodDeclaration callback, DOM::AttributeDefinition attribute, ThisExpr unbound
where
  attribute = getAnEventHandlerAttribute() and
  attribute.getValueNode().analyze().getAValue().(AbstractFunction).getFunction() =
    callback.getBody() and
  unbound.getBinder() = callback.getBody() and
  not isBoundInMethod(callback)
select attribute,
  "The receiver of this event handler call is unbound, `$@` will be `undefined` in the call to $@",
  unbound, "this", callback, callback.getName()
