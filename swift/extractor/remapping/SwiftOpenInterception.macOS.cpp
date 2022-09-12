#include "swift/extractor/remapping/SwiftOpenInterception.h"
#include <fishhook.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>
#include <fcntl.h>
#include <unistd.h>

namespace codeql {

static std::string scratchDir;

static int (*original_open)(const char*, int, ...) = nullptr;

static std::string fileHash(const std::string& filename) {
  int fd = original_open(filename.c_str(), O_RDONLY);
  if (fd == -1) {
    return {};
  }
  auto maybeMD5 = llvm::sys::fs::md5_contents(fd);
  close(fd);
  if (!maybeMD5) {
    return {};
  }
  return maybeMD5->digest().str().str();
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

  std::string newPath(path);

  if (llvm::sys::fs::exists(newPath)) {
    // TODO: check file magic instead
    if (llvm::StringRef(newPath).endswith(".swiftmodule")) {
      auto hash = fileHash(newPath);
      auto hashed = scratchDir + "/" + hash;
      if (!hash.empty() && llvm::sys::fs::exists(hashed)) {
        newPath = hashed;
      }
    }
  }

  return original_open(newPath.c_str(), oflag, mode);
}

void remapArtifacts(const std::unordered_map<std::string, std::string>& mapping) {
  for (auto& [original, patched] : mapping) {
    // TODO: Check file magic instead
    if (!llvm::StringRef(original).endswith(".swiftmodule")) {
      continue;
    }
    auto hash = fileHash(original);
    auto hashed = scratchDir + "/" + hash;
    if (!hash.empty() && llvm::sys::fs::exists(patched)) {
      if (std::error_code ec = llvm::sys::fs::create_link(/* from */ patched, /* to */ hashed)) {
        llvm::errs() << "Cannot remap file '" << patched << "' -> '" << hashed
                     << "': " << ec.message() << "\n";
      }
    }
  }
}

void initInterception(const std::string& dir) {
  scratchDir = dir;

  struct rebinding binding[] = {
      {"open", reinterpret_cast<void*>(codeql_open), reinterpret_cast<void**>(&original_open)}};
  rebind_symbols(binding, 1);
}

}  // namespace codeql
