---
category: newQuery
---
* Added two new experimental query, `rb/jwt-empty-secret-or-algorithm`, to detect when application uses an empty secreat or weak algorithm. And `rb/jwt-missing-verification`, when the application does not verify the JWT payload.