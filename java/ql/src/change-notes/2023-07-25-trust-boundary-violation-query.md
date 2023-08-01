---
category: newQuery
---
* Added the `java/trust-boundary-violation` query to detect trust boundary violations between HTTP requests and the HTTP session. Also added the `trust-boundary-violation` sink kind for sinks which may cross a trust boundary, such as calls to the `HttpSession#setAttribute` method.

