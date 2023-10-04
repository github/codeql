---
category: deprecated
---
* In `SensitiveApi.qll`, `javaApiCallablePasswordParam`, `javaApiCallableUsernameParam`, `javaApiCallableCryptoKeyParam`, and `otherApiCallableCredentialParam` predicates have been deprecated. They have been replaced with a new class `CredentialsSinkNode` and its child classes `PasswordSink`, `UsernameSink`, and `CryptoKeySink`. The predicates have been changed to using the new classes, so there may be minor changes in results relying on these predicates.
