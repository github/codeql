---
category: minorAnalysis
---
* Improved _Reflected server-side cross-site scripting_ (`py/reflective-xss`) query to not alert on data passed to `flask.jsonify`. Since these HTTP responses are returned with mime-type `application/json`, they do not pose a security risk for XSS.
