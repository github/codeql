---
category: minorAnalysis
---
* Added an option to `EnvironmentCheck` to become specified by a MaD model, otherwise it will continue as the default it previously was. Without adding models to `actions/ql/lib/ext/config/deployment_environment.yml` the behavior of every query will be unchanged. When models are added queries using `ControlCheck` may find more results in cases where an enironment is no longer a sufficient sanitizer.