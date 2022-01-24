lgtm,codescanning
* The query `java/unknown-javadoc-parameter` now raises alerts for type parameters of generic classes that are documented but don't exist (perhaps due to using the wrong syntax, e.g. `@param T` instead of `@param <T>`).
