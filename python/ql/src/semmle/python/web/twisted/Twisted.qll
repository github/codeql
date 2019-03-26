import python

import semmle.python.security.TaintTracking

private ClassObject theTwistedHttpRequestClass() {
    result = ModuleObject::named("twisted.web.http").attr("Request")
}

private ClassObject theTwistedHttpResourceClass() {
    result = ModuleObject::named("twisted.web.resource").attr("Resource")
}

ClassObject aTwistedRequestHandlerClass() {
    result.getASuperType() = theTwistedHttpResourceClass()
}

FunctionObject getTwistedRequestHandlerMethod(string name) {
    result = aTwistedRequestHandlerClass().declaredAttribute(name)
}

bindingset[name]
predicate isKnownRequestHandlerMethodName(string name) {
    name = "render" or
    name.matches("render_%")
}

/** Holds if `node` is likely to refer to an instance of the twisted
 * `Request` class.
 */
predicate isTwistedRequestInstance(NameNode node) {
    node.refersTo(_, theTwistedHttpRequestClass(), _)
    or
    /* In points-to analysis cannot infer that a given object is an instance of
     * the `twisted.web.http.Request` class, we also include any parameter
     * called `request` that appears inside a subclass of a request handler
     * class, and the appropriate arguments of known request handler methods.
     */
    exists(Function func | func = node.getScope() |
        func.getEnclosingScope().(Class).getClassObject() = aTwistedRequestHandlerClass()
    ) and
    (
    /* Any parameter called `request` */
    node.getId() = "request" and
    node.isParameter()
    or
    /* Any request parameter of a known request handler method */
    exists(FunctionObject func | node.getScope() = func.getFunction() | 
        isKnownRequestHandlerMethodName(func.getName()) and
        node.getNode() = func.getFunction().getArg(1)
        )
    )
}
