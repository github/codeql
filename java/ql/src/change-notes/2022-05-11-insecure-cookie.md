---
category: minorAnalysis
---
* Query `java/insecure-cookie` now tolerates setting a cookie's secure flag to `request.isSecure()`. This means servlets that intentionally accept unencrypted connections will no longer raise an alert.
