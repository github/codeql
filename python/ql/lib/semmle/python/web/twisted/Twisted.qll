import python
import semmle.python.dataflow.TaintTracking

deprecated private ClassValue theTwistedHttpRequestClass() {
  result = Value::named("twisted.web.http.Request")
}

deprecated private ClassValue theTwistedHttpResourceClass() {
  result = Value::named("twisted.web.resource.Resource")
}

deprecated ClassValue aTwistedRequestHandlerClass() {
  result.getABaseType+() = theTwistedHttpResourceClass()
}

deprecated FunctionValue getTwistedRequestHandlerMethod(string name) {
  result = aTwistedRequestHandlerClass().declaredAttribute(name)
}

bindingset[name]
deprecated predicate isKnownRequestHandlerMethodName(string name) {
  name = "render" or
  name.matches("render_%")
}

/**
 * Holds if `node` is likely to refer to an instance of the twisted
 * `Request` class.
 */
deprecated predicate isTwistedRequestInstance(NameNode node) {
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
