lgtm,codescanning
* Added modeling of flask class based view handlers (subclasses of `flask.views.View` and `flask.views.MethodView`). This means we're now able to detect routed parameters for request handler defined on these classes, as sources of remote user input (`RemoteFlowSource`).
