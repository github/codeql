---
category: fix
---
* The `cs/web/missing-token-validation` ("Missing cross-site request forgery token validation") query now recognizes antiforgery attributes on base controller classes, fixing false positives when `[ValidateAntiForgeryToken]` or `[AutoValidateAntiforgeryToken]` is applied to a parent class.
