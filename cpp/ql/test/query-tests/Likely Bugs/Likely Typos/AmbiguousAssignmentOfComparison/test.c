int read_value(void);
int read_other_value(void);

int c_direct_condition(void) {
  int value;
  if ((value = read_value() < 0)) // $ Alert // BAD
    return value;
  return 0;
}

int c_logical_condition(void) {
  int value;
  if (read_other_value() && (value = read_value() >= 0)) // $ Alert // BAD
    return value;
  return 0;
}

int c_compound_divide(void) {
  int value = 8;
  if ((value /= read_value() != 0)) // $ Alert // BAD
    return value;
  return 0;
}

int c_compound_remainder(void) {
  int value = 8;
  if ((value %= read_value() != 0)) // $ Alert // BAD
    return value;
  return 0;
}

int c_compound_bitwise_or(void) {
  int value = 0;
  if ((value |= read_value() > 0)) // $ Alert // BAD
    return value;
  return 0;
}

int c_compound_right_shift(void) {
  int value = 8;
  if ((value >>= read_value() > 0)) // $ Alert // BAD
    return value;
  return 0;
}

#define C_AMBIGUOUS_CHECK(VALUE) \
  if (((VALUE) = read_value() < 0)) return (VALUE)

int c_macro_condition(void) {
  int value;
  C_AMBIGUOUS_CHECK(value); // $ Alert // BAD
  return 0;
}

int c_explicit_assign_then_compare(void) {
  int value;
  if ((value = read_value()) < 0) // GOOD
    return value;
  return 0;
}

int c_explicit_compare_then_assign(void) {
  int value;
  if ((value = (read_value() < 0))) // GOOD
    return value;
  return 0;
}

int c_explicit_cast_of_comparison(void) {
  int value;
  if ((value = (int)(read_value() < 0))) // GOOD: The cast explicitly groups the comparison.
    return value;
  return 0;
}

int c_boolean_result_assignment(void) {
  _Bool negative;
  if ((negative = read_value() < 0)) // GOOD: Assigning a comparison result to a Boolean is natural.
    return negative;
  return 0;
}

int c_switch_expression(void) {
  int value;
  switch (value = read_value() < 0) { // GOOD: This query only covers branching conditions.
  case 0:
    return value;
  default:
    return 0;
  }
}
