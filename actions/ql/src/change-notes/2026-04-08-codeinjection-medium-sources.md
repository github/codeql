---
category: minorAnalysis
---
* Added source type to `actions/code-injection/medium` such that now `github.head_ref` is found as source even on event `pull_request` (not just `pull_request_target`). This will result in the query finding more results.