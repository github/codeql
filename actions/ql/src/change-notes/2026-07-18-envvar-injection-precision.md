---
category: minorAnalysis
---
* The `actions/envvar-injection/critical` query now requires the untrusted source and privileged context to originate from the same trigger event. The environment variable injection queries also no longer treat pull request head labels as injection-capable because they cannot contain newlines.
