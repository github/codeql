lgtm,codescanning
* Improved modeling of `django` to recognize request handlers functions that are decorated (for example with `django.views.decorators.http.require_GET`). This leads to more sources of remote user input (`RemoteFlowSource`), since we correctly identify the first parameter as being passed a django request.
