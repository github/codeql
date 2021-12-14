import python

/** DEPRECATED: Use `Value::named("django.shortcuts.redirect")` instead. */
deprecated FunctionValue redirect() { result = Value::named("django.shortcuts.redirect") }

/** DEPRECATED: Use `DjangoRedirectResponseClass` instead. */
deprecated ClassValue theDjangoHttpRedirectClass() {
  // version 1.x
  result = Value::named("django.http.response.HttpResponseRedirectBase")
  or
  // version 2.x
  result = Value::named("django.http.HttpResponseRedirectBase")
}

/** A class that is a Django Redirect Response (subclass of `django.http.HttpResponseRedirectBase`). */
class DjangoRedirectResponseClass extends ClassValue {
  DjangoRedirectResponseClass() {
    exists(ClassValue redirect_base |
      // version 1.x
      redirect_base = Value::named("django.http.response.HttpResponseRedirectBase")
      or
      // version 2.x and 3.x
      redirect_base = Value::named("django.http.HttpResponseRedirectBase")
    |
      this.getASuperType() = redirect_base
    )
  }
}

/**
 * A class that is a Django Response, which can contain content.
 * A subclass of `django.http.HttpResponse` that is not a `DjangoRedirectResponseClass`.
 */
class DjangoContentResponseClass extends ClassValue {
  ClassValue base;

  DjangoContentResponseClass() {
    (
      // version 1.x
      base = Value::named("django.http.response.HttpResponse")
      or
      // version 2.x and 3.x
      // https://docs.djangoproject.com/en/2.2/ref/request-response/#httpresponse-objects
      base = Value::named("django.http.HttpResponse")
    ) and
    this.getASuperType() = base
  }

  // The reason these two methods are defined in this class (and not in the Sink
  // definition that uses this class), is that if we were to add support for
  // `django.http.response.HttpResponseNotAllowed` it would make much more sense to add
  // the custom logic in this class (or subclass), than to handle all of it in the sink
  // definition.
  /** Gets the `content` argument of a `call` to the constructor */
  ControlFlowNode getContentArg(CallNode call) { none() }

  /** Gets the `content_type` argument of a `call` to the constructor */
  ControlFlowNode getContentTypeArg(CallNode call) { none() }
}

/** A class that is a Django Response, and is vulnerable to XSS. */
class DjangoXSSVulnerableResponseClass extends DjangoContentResponseClass {
  DjangoXSSVulnerableResponseClass() {
    // We want to avoid FPs on subclasses that are not exposed to XSS, for example `JsonResponse`.
    // The easiest way is to disregard any subclass that has a special `__init__` method.
    // It's not guaranteed to remove all FPs, or not to generate FNs, but compared to our
    // previous implementation that would treat 0-th argument to _any_ subclass as a sink,
    // this gets us much closer to reality.
    this.lookup("__init__") = base.lookup("__init__") and
    not this instanceof DjangoRedirectResponseClass
  }

  override ControlFlowNode getContentArg(CallNode call) {
    result = call.getArg(0)
    or
    result = call.getArgByName("content")
  }

  override ControlFlowNode getContentTypeArg(CallNode call) {
    result = call.getArg(1)
    or
    result = call.getArgByName("content_type")
  }
}
