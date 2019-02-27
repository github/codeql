import python
import semmle.python.web.Http

module CherryPy {

    FunctionObject expose() {
        result = ModuleObject::named("cherrypy").attr("expose")
    }

}

class CherryPyExposedFunction extends Function {

    CherryPyExposedFunction() {
        this.getADecorator().refersTo(CherryPy::expose())
        or
        this.getADecorator().(Call).getFunc().refersTo(CherryPy::expose())
    }

}

class CherryPyRoute extends CallNode {

    CherryPyRoute() {
        /* cherrypy.quickstart(root, script_name, config) */
        ModuleObject::named("cherrypy").attr("quickstart").(FunctionObject).getACall() = this
        or
        /* cherrypy.tree.mount(root, script_name, config) */
        this.getFunction().(AttrNode).getObject("mount").refersTo(ModuleObject::named("cherrypy").attr("tree"))
    }

    ClassObject getAppClass() {
        this.getArg(0).refersTo(_, result, _)
        or
        this.getArgByName("root").refersTo(_, result, _)
    }

    string getPath() {
        exists(StringObject path |
            result = path.getText() 
            |
            this.getArg(1).refersTo(path)
            or
            this.getArgByName("script_name").refersTo(path)
        )
    }

    Object getConfig() {
        this.getArg(2).refersTo(_, result, _)
        or
        this.getArgByName("config").refersTo(_, result, _)
    }

}


