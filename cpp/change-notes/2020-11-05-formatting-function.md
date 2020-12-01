lgtm,codescanning
* `FormattingFunction.getOutputParameterIndex` now has a parameter identifying whether the output at that index is a buffer or a stream.
* `FormattingFunction` now has a predicate `isOutputGlobal` indicating when the output is to a global stream.
* The `primitiveVariadicFormatter` and `variadicFormatter` predicates have more parameters exposing information about the function.
