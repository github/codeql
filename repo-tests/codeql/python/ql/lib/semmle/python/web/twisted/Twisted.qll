import python
import semmle.python.dataflow.TaintTracking

private ClassValue theTwistedHttpRequestClass() {
  result = Value::named("twisted.web.http.Request")
}

private ClassValue theTwistedHttpResourceClass() {
  result = Value::named("twisted.web.resource.Resource")
}

ClassValue aTwistedRequestHandlerClass() { result.getABaseType+() = theTwistedHttpResourceClass() }

FunctionValue getTwistedRequestHandlerMethod(string name) {
  result = aTwistedRequestHandlerClass().declaredAttribute(name)
}

bindingset[name]
predicate isKnownRequestHandlerMethodName(string name) {
  name = "render" or
  name.matches("render_%")
}

/**
 * Holds if `node` is likely to refer to an instance of the twisted
 * `Request` class.
 */
predicate isTwistedRequestInstance(NameNode node) {
  node.pointsTo().getClass() = theTwistedHttpRequestClass()
  or
  /*
   * In points-to analysis cannot infer that a given object is an instance of
   * the `twisted.web.http.Request` class, we also include any parameter
   * called `request` that appears inside a subclass of a request handler
   * class, and the appropriate arguments of known request handler methods.
   */

  exists(Function func |
    func = node.getScope() and
    func.getEnclosingScope() = aTwistedRequestHandlerClass().getScope()
  |
    /* Any parameter called `request` */
    node.getId() = "request" and
    node.isParameter()
    or
    /* Any request parameter of a known request handler method */
    isKnownRequestHandlerMethodName(func.getName()) and
    node.getNode() = func.getArg(1)
  )
}
