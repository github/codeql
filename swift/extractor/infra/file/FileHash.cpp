#include "swift/extractor/infra/file/FileHash.h"
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <fcntl.h>
#include <picosha2.h>

namespace codeql {
std::string hashFile(const std::filesystem::path& file) {
  // using `open` instead of `std::ifstream` to reuse `hashFile(int)` below
  if (auto fd = ::open(file.c_str(), O_RDONLY); fd >= 0) {
    return hashFile(fd);
  }
  return "";
}

std::string hashFile(int fd) {
  auto hasher = picosha2::hash256_one_by_one();
  constexpr size_t bufferSize = 16 * 1024;
  char buffer[bufferSize];
  ssize_t bytesRead = 0;
  while ((bytesRead = ::read(fd, buffer, bufferSize)) > 0) {
    hasher.process(buffer, buffer + bytesRead);
  }
  ::close(fd);
  if (bytesRead < 0) {
    return "";
  }
  hasher.finish();
  return get_hash_hex_string(hasher);
}
}  // namespace codeql
