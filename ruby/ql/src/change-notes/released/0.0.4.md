## 0.0.4

### New Queries

* A new query (`rb/request-forgery`) has been added. The query finds HTTP requests made with user-controlled URLs.
* A new query (`rb/csrf-protection-disabled`) has been added. The query finds cases where cross-site forgery protection is explictly disabled.

### Query Metadata Changes

* The precision of "Hard-coded credentials" (`rb/hardcoded-credentials`) has been decreased from "high" to "medium". This query will no longer be run and displayed by default on Code Scanning and LGTM.
