import javascript

query predicate test_middleweare(
  ExpressValidator::MiddlewareInstance middleware, string param_type, string param
) {
  param = middleware.getSafeParameterName() and
  param_type = middleware.getValidatorType()
}
