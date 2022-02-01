lgtm,codescanning
* Added modeling of flask blueprints (`flask.Blueprint`), specifically request handlers defined with such blueprints. This can result in new sources of remote user input (`RemoteFlowSource`) -- since we're now able to detect routed parameters -- and new XSS sinks from the responses of these request handlers.
