## 1.1.11

### Minor Analysis Improvements

* False positives in "Log entries created from user input" (`go/log-injection`) and "Clear-text logging of sensitive information" (`go/clear-text-logging`) which involved the verb `%T` in a format specifier have been fixed. As a result, some users may also see more alerts from the "Use of constant `state` value in OAuth 2.0 URL" (`go/constant-oauth2-state`) query.
