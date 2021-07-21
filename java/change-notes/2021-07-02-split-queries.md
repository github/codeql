lgtm,codescanning
* Library `semmle.code.java.security.Random` is split into `RandomQuery`, for use by randomness-related queries, and `RandomValueSource`, for use by libraries wishing to augment the built-in set of random value sources. Any code importing `Random` will need changing to import one or other of these.
