import python
import semmle.python.regex
import semmle.python.web.Http

// TODO: Since django uses `path = partial(...)`, our analysis doesn't understand this is
// a FunctionValue, so we can't use `FunctionValue.getArgumentForCall`
// https://github.com/django/django/blob/master/django/urls/conf.py#L76
abstract deprecated class DjangoRoute extends CallNode {
  DjangoViewHandler getViewHandler() {
    result = view_handler_from_view_arg(this.getArg(1))
    or
    result = view_handler_from_view_arg(this.getArgByName("view"))
  }

  abstract string getANamedArgument();

  /**
   * Get the number of positional arguments that will be passed to the view.
   * Will only return a result if there are no named arguments.
   */
  abstract int getNumPositionalArguments();
}

/**
 * For function based views -- also see `DjangoClassBasedViewHandler`
 * https://docs.djangoproject.com/en/1.11/topics/http/views/
 * https://docs.djangoproject.com/en/3.0/topics/http/views/
 */
deprecated class DjangoViewHandler extends PythonFunctionValue {
  /** Gets the index of the 'request' argument */
  int getRequestArgIndex() { result = 0 }
}

/**
 * Class based views
 * https://docs.djangoproject.com/en/1.11/topics/class-based-views/
 * https://docs.djangoproject.com/en/3.0/topics/class-based-views/
 */
deprecated private class DjangoViewClass extends ClassValue {
  DjangoViewClass() {
    Value::named("django.views.generic.View") = this.getASuperType()
    or
    Value::named("django.views.View") = this.getASuperType()
  }
}

deprecated class DjangoClassBasedViewHandler extends DjangoViewHandler {
  DjangoClassBasedViewHandler() { exists(DjangoViewClass cls | cls.lookup(httpVerbLower()) = this) }

  override int getRequestArgIndex() {
    // due to `self` being the first parameter
    result = 1
  }
}

/**
 * Gets the function that will handle requests when `view_arg` is used as the view argument to a
 * django route. That is, this methods handles Class-based Views and its `as_view()` function.
 */
deprecated private DjangoViewHandler view_handler_from_view_arg(ControlFlowNode view_arg) {
  // Function-based view
  result = view_arg.pointsTo()
  or
  // Class-based view
  exists(ClassValue cls |
    cls = view_arg.(CallNode).getFunction().(AttrNode).getObject("as_view").pointsTo() and
    result = cls.lookup(httpVerbLower())
  )
}

// We need this "dummy" class, since otherwise the regex argument would not be considered
// a regex (RegexString is abstract)
deprecated class DjangoRouteRegex extends RegexString {
  DjangoRouteRegex() { exists(DjangoRegexRoute route | route.getRouteArg() = this.getAFlowNode()) }
}

deprecated class DjangoRegexRoute extends DjangoRoute {
  ControlFlowNode route;

  DjangoRegexRoute() {
    exists(FunctionValue route_maker |
      // Django 1.x: https://docs.djangoproject.com/en/1.11/ref/urls/#django.conf.urls.url
      Value::named("django.conf.urls.url") = route_maker and
      route_maker.getArgumentForCall(this, 0) = route
    )
    or
    // Django 2.x and 3.x: https://docs.djangoproject.com/en/3.0/ref/urls/#re-path
    this = Value::named("django.urls.re_path").getACall() and
    (
      route = this.getArg(0)
      or
      route = this.getArgByName("route")
    )
  }

  ControlFlowNode getRouteArg() { result = route }

  override string getANamedArgument() {
    exists(DjangoRouteRegex regex | regex.getAFlowNode() = route |
      result = regex.getGroupName(_, _)
    )
  }

  override int getNumPositionalArguments() {
    not exists(this.getANamedArgument()) and
    exists(DjangoRouteRegex regex | regex.getAFlowNode() = route |
      result = count(regex.getGroupNumber(_, _))
    )
  }
}

deprecated class DjangoPathRoute extends DjangoRoute {
  ControlFlowNode route;

  DjangoPathRoute() {
    // Django 2.x and 3.x: https://docs.djangoproject.com/en/3.0/ref/urls/#path
    this = Value::named("django.urls.path").getACall() and
    (
      route = this.getArg(0)
      or
      route = this.getArgByName("route")
    )
  }

  override string getANamedArgument() {
    // regexp taken from django:
    // https://github.com/django/django/blob/7d1bf29977bb368d7c28e7c6eb146db3b3009ae7/django/urls/resolvers.py#L199
    exists(StrConst route_str, string match |
      route_str = route.getNode() and
      match = route_str.getText().regexpFind("<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>", _, _) and
      result = match.regexpCapture("<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>", 2)
    )
  }

  override int getNumPositionalArguments() { none() }
}
