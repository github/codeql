#include "swift/logging/SwiftAssert.h"

const std::string_view codeql::programName = "test";
const std::string_view codeql::extractorName = "swift";

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

int main() {
  CODEQL_ASSERT(false, "Format the int {} and string {} if this assertion fails.", 1234,
                "myString");
}
