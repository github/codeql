lgtm,codescanning
* Improved modeling of `django` to recognize request handlers functions that are decorated (for example with `django.views.decorators.http.require_GET`). This leads to more sources of remote user input (`RemoteFlowSource`), since we correctly identify the first parameter as being passed a django request.
* Improved modeling of django View classes. We now consider any class using in a routing setup with `<class>.as_view()` as django view class. This leads to more sources of remote user input (`RemoteFlowSource`), since we correctly identify the first parameter as being passed a django request.
* Improved modeling of `django`, so for View classes we now model `self.request`, `self.args`, and `self.kwargs` as sources of remote user input (`RemoteFlowSource`).
