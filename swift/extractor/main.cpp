#include <fstream>
#include <iomanip>
#include <stdlib.h>

int main() {
  if (auto trapDir = getenv("CODEQL_EXTRACTOR_SWIFT_TRAP_DIR")) {
    std::string file = trapDir;
    file += "/my_first.trap";
    if (std::ofstream out{file}) {
      out << "answer_to_life_the_universe_and_everything(42)\n";
    }
  }
  return 0;
}
