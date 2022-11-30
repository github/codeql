#include <iostream>
#include <filesystem>

namespace codeql {
// Returns the hash of the file contents. Returns empty string on errors.
std::string hashFile(const std::filesystem::path& file);

// Returns the hash of the file descriptor contents. Closes the file descriptor.
// Returns empty string on errors.
std::string hashFile(int fd);
}  // namespace codeql
