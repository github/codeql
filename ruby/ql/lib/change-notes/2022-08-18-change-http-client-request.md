---
category: breaking
---
* Changed the `HTTP::Client::Request` concept from using `MethodCall` as base class, to using `DataFlow::Node` as base class. Any class that extend `HTTP::Client::Request::Range` must be changed, but if you only uses the member predicates of `HTTP::Client::Request` no changes are required.
