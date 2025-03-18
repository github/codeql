---
category: minorAnalysis
---
* `LoggerCall::getAMessageComponent` no longer returns arguments to logger calls which correspond to the verb `%T` in a format specifier. This will remove false positives in "Log entries created from user input" (`go/log-injection`) and "Clear-text logging of sensitive information" (`go/clear-text-logging`), and it may lead to more results in "Use of constant `state` value in OAuth 2.0 URL" (`go/constant-oauth2-state`).
