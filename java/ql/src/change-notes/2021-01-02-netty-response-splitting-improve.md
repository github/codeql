---
category: breaking
---
* Add more classes to Netty request/response splitting. Change identification to `java/netty-http-request-or-response-splitting`.
  Identify request splitting differently from response splitting in query results.
  Support addional classes:
  * `io.netty.handler.codec.http.CombinedHttpHeaders`
  * `io.netty.handler.codec.http.DefaultHttpRequest`
  * `io.netty.handler.codec.http.DefaultFullHttpRequest`
