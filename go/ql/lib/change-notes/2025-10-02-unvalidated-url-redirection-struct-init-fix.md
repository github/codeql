---
category: minorAnalysis
---
* For the query `go/unvalidated-url-redirection`, when untrusted data is assigned to the `Host` field of a `url.URL` struct, we consider the whole struct untrusted. We now also include the case when this happens during struct initialization, for example `&url.URL{Host: untrustedData}`.
