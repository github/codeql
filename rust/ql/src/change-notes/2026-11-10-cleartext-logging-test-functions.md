---
category: minorAnalysis
---
* The `rust/cleartext-logging` query no longer reports results in test functions, such as those with a `#[test]` or `#[tokio::test]` attribute, whose assertion messages and output go to the test runner rather than an application's log.
