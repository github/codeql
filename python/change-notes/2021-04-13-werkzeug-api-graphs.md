lgtm,codescanning
* The Werkzeug model has been changed to use API graphs. When defining new models for classes based
  on the `MultiDict` and `FileStorage` classes in `werkzeug.datastructures`, the relevant extension
  points are now the two `InstanceSourceApiNode` classes in the `semmle.python.frameworks.Werkzeug`
  module, instead of `InstanceSource`. The latter classes have now been deprecated.
