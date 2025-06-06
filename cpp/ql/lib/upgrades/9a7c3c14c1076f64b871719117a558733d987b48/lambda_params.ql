class LambdaExpr extends @lambdaexpr {
  string toString() { none() }
}

from
  LambdaExpr lambda, string default_capture, boolean has_explicit_return_type,
  boolean has_explicit_parameter_list
where lambdas(lambda, default_capture, has_explicit_return_type, has_explicit_parameter_list)
select lambda, default_capture, has_explicit_return_type, has_explicit_parameter_list, false
