import python

/** A Class that is a Django Response (subclass of `django.http.HttpResponse`). */
class DjangoResponse extends ClassValue {
    DjangoResponse() {
        exists(ClassValue base |
            // version 1.x
            base = Value::named("django.http.response.HttpResponse")
            or
            // version 2.x and 3.x
            // https://docs.djangoproject.com/en/2.2/ref/request-response/#httpresponse-objects
            base = Value::named("django.http.HttpResponse")
        |
            this.getASuperType() = base
        )
    }
}

/** A Class that is a Django Redirect Response (subclass of `django.http.HttpResponseRedirectBase`). */
class DjangoRedirectResponse extends DjangoResponse {
    DjangoRedirectResponse() {
        exists(ClassValue base |
            // version 1.x
            base = Value::named("django.http.response.HttpResponseRedirectBase")
            or
            // version 2.x and 3.x
            base = Value::named("django.http.HttpResponseRedirectBase")
        |
            this.getASuperType() = base
        )
    }
}

/** A Class that is a Django Response, and is vulnerable to XSS. */
class DjangoXSSVulnResponse extends DjangoResponse {
    DjangoXSSVulnResponse() {
        not this instanceof DjangoRedirectResponse
    }
}
