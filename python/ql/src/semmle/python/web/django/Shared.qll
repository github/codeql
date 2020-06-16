import python

/** django.shortcuts.redirect */
FunctionValue redirect() { result = Value::named("django.shortcuts.redirect") }

ClassValue theDjangoHttpRedirectClass() {
    // version 1.x
    result = Value::named("django.http.response.HttpResponseRedirectBase")
    or
    // version 2.x
    result = Value::named("django.http.HttpResponseRedirectBase")
}
