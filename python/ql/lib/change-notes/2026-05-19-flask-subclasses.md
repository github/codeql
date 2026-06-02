---
category: minorAnalysis
---
* `Flask::FlaskApp::instance()` will now also return instances of subclasses defined in the source tree. Previously, these were filtered out. `Flask::FlaskApp::classRef()` has been deprecated in favor of `Flask::FlaskApp::subclassRef()` since it already returned some subclasses.