class Element extends @element {
  string toString() { none() }
}

from Element i, string value
where
  integer_literal_exprs(i, value) and
  not exists(Element interpolated |
    interpolated_string_literal_expr_interpolation_count_exprs(interpolated, i)
    or
    interpolated_string_literal_expr_literal_capacity_exprs(interpolated, i)
  )
select i, value
