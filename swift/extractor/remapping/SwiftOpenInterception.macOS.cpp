#include "swift/extractor/remapping/SwiftOpenInterception.h"

#include <fishhook.h>

#include <fcntl.h>
#include <unistd.h>
#include <filesystem>

#include "swift/extractor/infra/file/FileHash.h"

namespace fs = std::filesystem;

namespace codeql {

static fs::path scratchDir;
static bool interceptionEnabled = false;

static int (*original_open)(const char*, int, ...) = nullptr;

static std::string originalHashFile(const fs::path& filename) {
  int fd = original_open(filename.c_str(), O_RDONLY);
  if (fd == -1) {
    return {};
  }

  return hashFile(fd);
}

static int codeql_open(const char* path, int oflag, ...) {
  va_list ap = {0};
  mode_t mode = 0;
  if ((oflag & O_CREAT) != 0) {
    // mode only applies to O_CREAT
    va_start(ap, oflag);
    mode = va_arg(ap, int);
    va_end(ap);
  }

  fs::path newPath(path);

  if (interceptionEnabled && fs::exists(newPath)) {
    // TODO: check file magic instead
    if (newPath.extension() == ".swiftmodule") {
      auto hash = originalHashFile(newPath);
      auto hashed = scratchDir / hash;
      if (!hash.empty() && fs::exists(hashed)) {
        newPath = hashed;
      }
    }
  }

  return original_open(newPath.c_str(), oflag, mode);
}

void finalizeRemapping(
    const std::unordered_map<std::filesystem::path, std::filesystem::path>& mapping) {
  for (auto& [original, patched] : mapping) {
    // TODO: Check file magic instead
    if (original.extension() != ".swiftmodule") {
      continue;
    }
    auto hash = originalHashFile(original);
    auto hashed = scratchDir / hash;
    if (!hash.empty() && fs::exists(patched)) {
      std::error_code ec;
      fs::create_symlink(/* target */ patched, /* symlink */ hashed, ec);
      if (ec) {
        std::cerr << "Cannot remap file '" << patched << "' -> '" << hashed << "': " << ec.message()
                  << "\n";
      }
    }
  }
  interceptionEnabled = false;
}

void initRemapping(const std::filesystem::path& dir) {
  scratchDir = dir;

  struct rebinding binding[] = {
      {"open", reinterpret_cast<void*>(codeql_open), reinterpret_cast<void**>(&original_open)}};
  rebind_symbols(binding, 1);
  interceptionEnabled = true;
}

}  // namespace codeql
