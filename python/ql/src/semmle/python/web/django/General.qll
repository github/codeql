import python
import semmle.python.regex
import semmle.python.web.Http

// TODO: Since django uses `path = partial(...)`, our analysis doesn't understand this is
// a FunctionValue, so we can't use `FunctionValue.getArgumentForCall`
// https://github.com/django/django/blob/master/django/urls/conf.py#L76

private predicate django_regex_route(CallNode call, ControlFlowNode regex, FunctionValue view) {
    exists(Value route_maker |
        (
            // Django 1.x
            Value::named("django.conf.urls.url") = route_maker and
            route_maker.(FunctionValue).getArgumentForCall(call, 0) = regex and
            route_maker.(FunctionValue).getArgumentForCall(call, 1).pointsTo(view)
        )
        or
        (
            // Django 2.x and 3.x: https://docs.djangoproject.com/en/3.0/ref/urls/#re-path
            Value::named("django.urls.re_path") = route_maker and
            route_maker.getACall() = call and
            (
                call.getArg(0) = regex
                or
                call.getArgByName("route") = regex

            ) and
            (
                call.getArg(1).pointsTo(view)
                or
                call.getArgByName("view").pointsTo(view)
            )
        )
    )
}

class DjangoRouteRegex extends RegexString {
    DjangoRouteRegex() { django_regex_route(_, this.getAFlowNode(), _) }
}

abstract class DjangoRoute extends CallNode {

    abstract FunctionValue getViewFunction();

    abstract string getANamedArgument();

    /**
     * Get the number of positional arguments that will be passed to the view.
     * Will only return a result if there are no named arguments.
     */
    abstract int getNumPositionalArguments();
}

class DjangoRegexRoute extends DjangoRoute {
    DjangoRegexRoute() { django_regex_route(this, _, _) }

    override FunctionValue getViewFunction() { django_regex_route(this, _, result) }

    override string getANamedArgument() {
        exists(DjangoRouteRegex regex |
            django_regex_route(this, regex.getAFlowNode(), _) and
            regex.getGroupName(_, _) = result
        )
    }

    override int getNumPositionalArguments() {
        exists(DjangoRouteRegex regex |
            not exists(this.getANamedArgument()) and
            django_regex_route(this, regex.getAFlowNode(), _) and
            result = count(regex.getGroupNumber(_, _))
        )
    }
}

class DjangoPathRoute extends DjangoRoute {

    ControlFlowNode route;
    FunctionValue view;

    DjangoPathRoute() {
        // Django 2.x and 3.x: https://docs.djangoproject.com/en/3.0/ref/urls/#path
        this = Value::named("django.urls.path").getACall() and
        (
            route = this.getArg(0)
            or
            route = this.getArgByName("route")

        ) and
        (
            this.getArg(1).pointsTo(view)
            or
            this.getArgByName("view").pointsTo(view)
        )
    }

    override FunctionValue getViewFunction() { result = view }

    override string getANamedArgument() {
        // regexp taken from django:
        // https://github.com/django/django/blob/7d1bf29977bb368d7c28e7c6eb146db3b3009ae7/django/urls/resolvers.py#L199
        exists(StrConst route_str, string match |
            route_str = route.getNode() and
            match = route_str.getText().regexpFind("<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>", _, _) and
            result = match.regexpCapture("<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>", 2)
        )
    }

    override int getNumPositionalArguments() {
        none()
    }
}
