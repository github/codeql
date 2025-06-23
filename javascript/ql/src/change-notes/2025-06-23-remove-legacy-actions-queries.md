---
category: minorAnalysis
---
* Removed three queries from the JS qlpack, which have been superseded by newer queries that are part of the Actions qlpack:
  * `js/actions/pull-request-target` has been superseded by `actions/untrusted-checkout/{medium,high,critical}`
  * `js/actions/actions-artifact-leak` has been supersded by `actions/secrets-in-artifacts`
  * `js/actions/command-injection` has been superseded by `actions/command-injection/{medium,critical}`
