---
category: minorAnalysis
---
* `new Response(x)` is no longer seen as a reflected XSS sink when no `content-type` header
  is set, since the content type defaults to `text/plain`.
