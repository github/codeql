import python

FunctionObject redirect() {
    result = ModuleObject::named("django.shortcuts").attr("redirect")
}

ClassObject theDjangoHttpRedirectClass() {
    result = ModuleObject::named("django.http.response").attr("HttpResponseRedirectBase")
}
