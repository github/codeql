import python

FunctionObject redirect() {
    result = any(ModuleObject m | m.getName() = "django.shortcuts").attr("redirect")
}

ClassObject theDjangoHttpRedirectClass() {
    result = any(ModuleObject m | m.getName() = "django.http.response").attr("HttpResponseRedirectBase")
}
