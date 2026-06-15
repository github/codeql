void fixed_lifetime_of_temp_not_extended() {
  auto&& v = get_vector();
  for(auto x : log_and_return_argument(v)) {
    use(x); // GOOD: The lifetime of the container returned by `get_vector()` has been extended to the lifetime of `v`.
  }
}
