---
category: minorAnalysis
---
* A "Missing cross-site request forgery token validation" query for AspNetCore (`cs/web/missing-token-validation-aspnetcore`) was added as an `experimental` query.
  * Unlike the existing "Missing cross-site request forgery token validation" query (`cs/web/missing-token-validation`), this query adds support for AspNetCore
  * The new query also does not tolerate situations where no CSRF token validation is present, so will produce many more (legitimate) results than the existing query. For this reason alone, it has been published as `experimental`.
