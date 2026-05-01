---
category: minorAnalysis
---
* The `java/sensitive-log` query now excludes additional common variable naming patterns that do not hold sensitive data, reducing false positives. This includes pagination/iteration tokens (`nextToken`, `pageToken`, `continuationToken`), token metadata (`tokenType`, `tokenEndpoint`, `tokenCount`), and secret metadata (`secretName`, `secretId`, `secretVersion`).
