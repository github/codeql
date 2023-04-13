---
category: minorAnalysis
---
* Improved the queries for injection vulnerabilities in GitHub Actions workflows (`js/actions/command-injection` and `js/actions/pull-request-target`) and the associated library `semmle.javascript.Actions`. These now support steps defined in composite actions, in addition to steps defined in Actions workflow files.