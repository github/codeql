class LambdaExpr extends @lambdaexpr {
  string toString() { none() }
}

from LambdaExpr lambda, string default_capture, boolean has_explicit_return_type
where lambdas(lambda, default_capture, has_explicit_return_type, _)
select lambda, default_capture, has_explicit_return_type
