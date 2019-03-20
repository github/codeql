import python

import semmle.python.security.TaintTracking

private ClassObject theTurboGearsControllerClass() {
    result = ModuleObject::named("tg").attr("TGController")
}


ClassObject aTurboGearsControllerClass() {
    result.getASuperType() = theTurboGearsControllerClass()
}


class TurboGearsControllerMethod extends Function {

    ControlFlowNode decorator;

    TurboGearsControllerMethod() {
        aTurboGearsControllerClass().getPyClass() = this.getScope() and
        decorator = this.getADecorator().getAFlowNode() and
        /* Is decorated with @expose() or @expose(path) */
        (
            decorator.(CallNode).getFunction().(NameNode).getId() = "expose"
            or
            decorator.refersTo(_, ModuleObject::named("tg").attr("expose"), _)
        )
    }

    private ControlFlowNode templateName() {
        result = decorator.(CallNode).getArg(0)
    }

    predicate isTemplated() {
        exists(templateName())
    }

    string getTemplateName() {
        exists(StringObject str |
            templateName().refersTo(str) and
            result = str.getText()
        )
    }

    Dict getValidationDict() {
        exists(Call call, Object dict |
            call = this.getADecorator() and
            call.getFunc().(Name).getId() = "validate" and
            call.getArg(0).refersTo(dict) and
            result = dict.getOrigin()
        )
    }

}

