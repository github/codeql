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
  exists (DataFlow::ThisNode thiz, MethodDeclaration bindingMethod |
    bindingMethod.getDeclaringClass() = method.getDeclaringClass() and
    not bindingMethod.isStatic() and
    thiz.getBinder().getAstNode() = bindingMethod.getBody() |
    // require("auto-bind")(this)
    thiz.flowsTo(DataFlow::moduleImport("auto-bind").getACall().getArgument(0))
    or
    exists (string name |
      name = method.getName() |
      exists (DataFlow::Node rhs, DataFlow::MethodCallNode bind |
        // this.<methodName> = <expr>.bind(...)
        thiz.hasPropertyWrite(name, rhs) and
        bind.flowsTo(rhs) and
        bind.getMethodName() = "bind"
      )
      or
      exists (DataFlow::MethodCallNode bindAll |
        bindAll.getMethodName() = "bindAll" and
        thiz.flowsTo(bindAll.getArgument(0)) |
        // _.bindAll(this, <name1>)
        bindAll.getArgument(1).mayHaveStringValue(name)
        or
        // _.bindAll(this, [<name1>, <name2>])
        exists (DataFlow::ArrayLiteralNode names |
          names.flowsTo(bindAll.getArgument(1)) and
          names.getAnElement().mayHaveStringValue(name)
        )
      )
    )
  )
  or
  exists (Expr decoration, string name |
    decoration = method.getADecorator().getExpression() and
    name.regexpMatch("(?i).*(bind|bound).*") |
    // @autobind
    decoration.(Identifier).getName() = name or
    // @action.bound
    decoration.(PropAccess).getPropertyName() = name
  )
}

/**
 * Gets an event handler attribute (onClick, onTouch, ...).
 */
private DOM::AttributeDefinition getAnEventHandlerAttribute() {
  exists (ReactComponent c, JSXNode rendered, string attributeName |
    c.getRenderMethod().getAReturnedExpr().flow().getALocalSource().asExpr() = rendered and
    result = rendered.getABodyElement*().(JSXElement).getAttributeByName(attributeName) and
    attributeName.regexpMatch("on[A-Z][a-zA-Z]+") // camelCased with 'on'-prefix
  )
}

from MethodDeclaration callback, DOM::AttributeDefinition attribute, ThisExpr unbound
where
      attribute = getAnEventHandlerAttribute() and
      attribute.getValueNode().analyze().getAValue().(AbstractFunction).getFunction() = callback.getBody() and
      unbound.getBinder() = callback.getBody() and
      not isBoundInMethod(callback)
select attribute, "The receiver of this event handler call is unbound, `$@` will be `undefined` in the call to $@", unbound, "this", callback, callback.getName()
