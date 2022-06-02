lgtm,codescanning
* Improved recongition of sanitizer functions for the `go/zipslip` query. This may reduce false-positives (but also perhaps false-negatives) when application code attempts to check a zip header entry does not contain an illegal path traversal attempt.
