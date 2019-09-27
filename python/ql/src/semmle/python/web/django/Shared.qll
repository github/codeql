import python

/** django.shortcuts.redirect */
FunctionValue redirect() {
    result = Value::named("django.shortcuts.redirect")
}

ClassValue theDjangoHttpRedirectClass() {
    result = Value::named("django.http.response.HttpResponseRedirectBase")
}
