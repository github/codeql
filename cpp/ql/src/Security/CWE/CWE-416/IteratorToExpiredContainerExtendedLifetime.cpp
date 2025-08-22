#include <vector>

std::vector<int> get_vector();

void use(int);

void lifetime_of_temp_extended() {
  for(auto x : get_vector()) {
    use(x); // GOOD: The lifetime of the vector returned by `get_vector()` is extended until the end of the loop.
  }
}

// Writes the the values of `v` to an external log and returns it unchanged.
const std::vector<int>& log_and_return_argument(const std::vector<int>& v);

void lifetime_of_temp_not_extended() {
  for(auto x : log_and_return_argument(get_vector())) {
    use(x); // BAD: The lifetime of the vector returned by `get_vector()` is not extended, and the behavior is undefined.
  }
}
