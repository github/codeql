---
category: minorAnalysis
---
* The `job.workflow_ref`, `job.workflow_sha`, `job.workflow_repository` and `job.workflow_file_path` context properties are no longer treated as untrusted input in a reusable workflow with no known caller, which removes `actions/untrusted-checkout/medium` false positives on a reusable workflow that checks out its own source.
