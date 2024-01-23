---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `HTTP`, `CSRF`, ``, `` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getAUse` and `getARhs` predicates from `API::Node`, use `getASource` and `getASink` instead.
* Deleted the deprecated `disablesCertificateValidation` predicate from the `Http` module.
* Deleted the deprecated `ParamsCall`, `CookiesCall`, and `ActionControllerControllerClass` classes from `ActionController.qll`, use the simarly named classes from `codeql.ruby.frameworks.Rails::Rails` instead.
* Deleted the deprecated `HtmlSafeCall`, `HtmlEscapeCall`, `RenderCall`, and `RenderToCall` classes from `ActionView.qll`, use the simarly named classes from `codeql.ruby.frameworks.Rails::Rails` instead.
* Deleted the deprecated `HtmlSafeCall` class from `Rails.qll`.
* Deleted the deprecated `codeql/ruby/security/BadTagFilterQuery.qll`, `codeql/ruby/security/OverlyLargeRangeQuery.qll`, `codeql/ruby/security/regexp/ExponentialBackTracking.qll`, `codeql/ruby/security/regexp/NfaUtils.qll`, `codeql/ruby/security/regexp/RegexpMatching.qll`, and `codeql/ruby/security/regexp/SuperlinearBackTracking.qll` files.
* Deleted the deprecated `localSourceStoreStep` predicate from `TypeTracker.qll`, use `flowsToStoreStep` instead.