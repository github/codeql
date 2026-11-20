#define TEST_STD_BACKED
#include "../optional/optional.h"
int source(); void sink(int);
void stdBacked() {
  bsl::optional<int> value(source());
  sink(*value); // $ ir
  bsl::optional<int> written(0);
  written.value() = source();
  sink(*written); // $ ir
  bsl::optional<int> copy(static_cast<const bsl::optional<int>&>(value));
  sink(copy.value()); // $ ir
  bsl::optional<int> placed;
  placed.emplace(source());
  sink(*placed); // $ ir
  sink(value.has_value());
}
