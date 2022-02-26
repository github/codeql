---
category: queryMetadata
---
* The `js/request-forgery` query previously flagged both server-side and client-side request forgery,
  but these are now handled by two different queries:
  * `js/request-forgery` is now specific to server-side request forgery. Its precision has been raised to
    `high` and is now shown by default (it was previously in the `security-extended` suite).
  * `js/client-side-request-forgery` is specific to client-side request forgery. This is technically a new query
    but simply flags a subset of what the old query did.
    This has precision `medium` and is part of the `security-extended` suite.
