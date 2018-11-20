import python

FunctionObject redirect() {
    result = any(ModuleObject m | m.getName() = "django.shortcuts").getAttribute("redirect")
}

ClassObject theDjangoHttpRedirectClass() {
    result = any(ModuleObject m | m.getName() = "django.http.response").getAttribute("HttpResponseRedirectBase")
}
