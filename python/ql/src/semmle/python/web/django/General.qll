import python
import semmle.python.regex
import semmle.python.web.Http

predicate django_route(CallNode call, ControlFlowNode regex, FunctionValue view) {
    exists(FunctionValue url |
        Value::named("django.conf.urls.url") = url and
        url.getArgumentForCall(call, 0) = regex and
        url.getArgumentForCall(call, 1).pointsTo(view)
    )
}

class DjangoRouteRegex extends RegexString {
    DjangoRouteRegex() { django_route(_, this.getAFlowNode(), _) }
}

class DjangoRoute extends CallNode {
    DjangoRoute() { django_route(this, _, _) }

    FunctionValue getViewFunction() { django_route(this, _, result) }

    string getNamedArgument() {
        exists(DjangoRouteRegex regex |
            django_route(this, regex.getAFlowNode(), _) and
            regex.getGroupName(_, _) = result
        )
    }

    /**
      * Get the number of positional arguments that will be passed to the view.
      * Will only return a result if there are no named arguments.
      */
    int getNumPositionalArguments() {
        exists(DjangoRouteRegex regex |
            django_route(this, regex.getAFlowNode(), _) and
            not exists(string s | s = regex.getGroupName(_, _)) and
            result = count(regex.getGroupNumber(_, _))
        )
    }
}
