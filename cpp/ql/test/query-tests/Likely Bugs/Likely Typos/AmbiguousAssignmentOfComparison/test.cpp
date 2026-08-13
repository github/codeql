int get_value();
int get_other_value();
void *get_pointer();
bool identity(bool value);

int direct_if() {
  int value;
  if ((value = get_value() < 0)) // $ Alert // BAD
    return value;
  return 0;
}

int direct_while() {
  int value;
  while ((value = get_value() != 0)) // $ Alert // BAD
    return value;
  return 0;
}

int without_outer_parentheses() {
  int value;
  if (value = get_value() < 0) // $ Alert // BAD
    return value;
  return 0;
}

int for_condition() {
  int value;
  for (; (value = get_other_value() <= 0);) // $ Alert // BAD
    return value;
  return 0;
}

int logical_and() {
  int value;
  if ((value = get_value() < 0) && get_other_value()) // $ Alert // BAD
    return value;
  return 0;
}

int ternary_condition() {
  int value;
  return (value = get_value() > 0) ? value : 0; // $ Alert // BAD
}

int pointer_comparison() {
  int value;
  if ((value = get_pointer() == 0)) // $ Alert // BAD
    return value;
  return 0;
}

int parenthesized_operand_only() {
  int value;
  if ((value = (get_value()) < 0)) // $ Alert // BAD
    return value;
  return 0;
}

int do_while_condition() {
  int value = 0;
  do {
    value++;
  } while ((value = get_value() < 0)); // $ Alert // BAD
  return value;
}

int logical_or() {
  int value;
  if (get_other_value() || (value = get_value() > 0)) // $ Alert // BAD
    return value;
  return 0;
}

int nested_comparison() {
  int value;
  if ((value = get_value() < 0) == 1) // $ Alert // BAD
    return value;
  return 0;
}

int compound_shift() {
  int value = 1;
  if ((value <<= get_other_value() > 0)) // $ Alert // BAD
    return value;
  return 0;
}

int under_logical_not() {
  int value;
  if (!(value = get_value() < 0)) // $ Alert // BAD
    return value;
  return 0;
}

#define CHECK_VALUE(VALUE) \
  if (((VALUE) = get_value() < 0)) return (VALUE)

int macro_condition() {
  int value;
  CHECK_VALUE(value); // $ Alert // BAD
  return 0;
}

int explicit_assign_then_compare() {
  int value;
  if ((value = get_value()) < 0) // GOOD
    return value;
  return 0;
}

int explicit_compare_then_assign() {
  int value;
  if ((value = (get_value() < 0))) // GOOD
    return value;
  return 0;
}

int parenthesized_simple_assignment() {
  int value;
  if ((value = get_value())) // GOOD
    return value;
  return 0;
}

int assignment_outside_condition() {
  int value;
  value = get_value() < 0; // GOOD: The assignment is not part of a condition.
  return value;
}

int plain_comparison() {
  int value = get_value();
  if (value < 0) // GOOD
    return value;
  return 0;
}

int explicit_compare_then_assign_without_outer_parentheses() {
  int value;
  if (value = (get_value() < 0)) // GOOD
    return value;
  return 0;
}

int explicit_assign_then_compare_in_for() {
  int value;
  for (; (value = get_other_value()) >= 0;) // GOOD
    return value;
  return 0;
}

int two_explicit_assignments() {
  int left, right;
  if ((left = get_value()) < 0 && (right = get_other_value()) < 0) // GOOD
    return left + right;
  return 0;
}

int explicit_comparison_then_compound_assign() {
  int value = 0;
  if ((value += (get_value() < 0))) // GOOD
    return value;
  return 0;
}

int compound_assignment_without_comparison() {
  int value = ~0;
  if ((value &= get_value())) // GOOD
    return value;
  return 0;
}

int switch_expression() {
  int value;
  switch (value = get_value() < 0) { // GOOD: This query only covers branching conditions.
  case 0:
    return value;
  default:
    return 0;
  }
}

#define EXPLICIT_CHECK(VALUE) \
  if (((VALUE) = get_value()) < 0) return (VALUE)

int explicit_macro_condition() {
  int value;
  EXPLICIT_CHECK(value); // GOOD
  return 0;
}

template <typename T>
int never_instantiated_template(T input) {
  int value;
  if ((value = input < 0)) // GOOD: Uninstantiated template code is excluded.
    return value;
  return 0;
}

int unevaluated_assignment() {
  int value;
  if (sizeof(value = get_value() < 0)) // GOOD: The assignment is unevaluated.
    return value;
  return 0;
}

int constant_assignment() {
  int value;
  if ((value = 0)) // GOOD: The right-hand side is not a comparison.
    return value;
  return 0;
}

int explicit_compound_shift_then_compare() {
  int value = 1;
  if ((value <<= get_other_value()) > 0) // GOOD
    return value;
  return 0;
}

int boolean_result_assignment() {
  bool negative;
  if ((negative = get_value() < 0)) // GOOD: Assigning a comparison result to a Boolean is natural.
    return negative;
  return 0;
}

int boolean_result_compound_assignment() {
  bool seen = false;
  if ((seen |= get_value() < 0)) // GOOD: Accumulating a comparison result in a Boolean is natural.
    return seen;
  return 0;
}

int explicit_static_cast_of_comparison() {
  int value;
  if ((value = static_cast<int>(get_value() < 0))) // GOOD: The cast explicitly groups the comparison.
    return value;
  return 0;
}

int explicit_functional_cast_of_comparison() {
  int value;
  if ((value = int(get_value() < 0))) // GOOD: The cast explicitly groups the comparison.
    return value;
  return 0;
}

template <typename T>
int instantiated_template_body(T input) {
  int value;
  if ((value = input < 0)) // $ Alert // BAD
    return value;
  return 0;
}

int instantiate_template() {
  return instantiated_template_body<int>(get_value());
}

struct Comparable {
  int value;
};

bool operator<(Comparable left, int right) {
  return left.value < right;
}

int overloaded_comparison() {
  Comparable input = {get_value()};
  int value;
  if ((value = input < 0)) // $ MISSING: Alert // BAD [NOT DETECTED]: overloaded operators are outside this query's scope.
    return value;
  return 0;
}

int assignment_as_call_argument() {
  int value;
  if (identity(value = get_value() < 0)) // $ Alert // BAD: The ambiguous syntax is still in a condition.
    return value;
  return 0;
}

int discarded_assignment_in_comma_expression() {
  int value;
  if ((value = get_value() < 0, get_other_value())) // $ Alert // BAD: Still ambiguous syntax in a condition.
    return value;
  return 0;
}

int assignment_in_lambda_body() {
  int value;
  if ([&]() {
        value = get_value() < 0; // GOOD: The lambda body is not the surrounding condition.
        return true;
      }())
    return value;
  return 0;
}
