---
category: minorAnalysis
---
* Captured subclass relationships ahead-of-time for most popular PyPI packages so we are able to resolve subclass relationships even without having the packages installed. For example we have captured that `flask_restful.Resource` is a subclass of `flask.views.MethodView`, so our Flask modeling will still consider a function named `post` on a `class Foo(flask_restful.Resource):` as a HTTP request handler.
