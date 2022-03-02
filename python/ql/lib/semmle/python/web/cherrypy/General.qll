import python
import semmle.python.web.Http

deprecated module CherryPy {
  FunctionValue expose() { result = Value::named("cherrypy.expose") }
}

deprecated class CherryPyExposedFunction extends Function {
  CherryPyExposedFunction() {
    this.getADecorator().pointsTo(CherryPy::expose())
    or
    this.getADecorator().(Call).getFunc().pointsTo(CherryPy::expose())
  }
}

deprecated class CherryPyRoute extends CallNode {
  CherryPyRoute() {
    /* cherrypy.quickstart(root, script_name, config) */
    Value::named("cherrypy.quickstart").(FunctionValue).getACall() = this
    or
    /* cherrypy.tree.mount(root, script_name, config) */
    this.getFunction().(AttrNode).getObject("mount").pointsTo(Value::named("cherrypy.tree"))
  }

  ClassValue getAppClass() {
    this.getArg(0).pointsTo().getClass() = result
    or
    this.getArgByName("root").pointsTo().getClass() = result
  }

  string getPath() {
    exists(Value path | path = Value::forString(result) |
      this.getArg(1).pointsTo(path)
      or
      this.getArgByName("script_name").pointsTo(path)
    )
  }

  ClassValue getConfig() {
    this.getArg(2).pointsTo().getClass() = result
    or
    this.getArgByName("config").pointsTo().getClass() = result
  }
}
