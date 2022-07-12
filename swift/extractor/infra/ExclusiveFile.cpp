#include "swift/extractor/infra/ExclusiveFile.h"

#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

namespace codeql {
namespace {
[[noreturn]] void unrecoverableError(const char* action,
                                     const std::string& arg,
                                     std::error_code ec) {
  std::cerr << "Unable to " << action << ": " << arg << " (" << ec.message() << ")\n";
  std::abort();
}

[[noreturn]] void unrecoverableError(const char* action, const std::string& arg) {
  unrecoverableError(action, arg, {errno, std::system_category()});
}

void ensureParent(const std::string& path) {
  auto parent = llvm::sys::path::parent_path(path);
  if (auto ec = llvm::sys::fs::create_directories(parent)) {
    unrecoverableError("create directory", parent.str(), ec);
  }
}

}  // namespace

ExclusiveFile::ExclusiveFile(std::string working, std::string target)
    : workingPath{std::move(working)}, targetPath{std::move(target)} {
  namespace fs = llvm::sys::fs;
  int fd = -1;
  ensureParent(workingPath);
  ensureParent(targetPath);
  if (auto ec = fs::openFileForWrite(targetPath, fd, fs::CD_CreateNew, fs::OF_Text)) {
    if (ec == std::errc::file_exists) {
      // we lost the race, do nothing (owned() will return false)
      return;
    }
    unrecoverableError("open file for writing", targetPath, ec);
  }
  fs::closeFile(fd);
  errno = 0;
  out.open(workingPath);
  checkOutput("open file for writing");
}

bool ExclusiveFile::owned() const {
  return out && out.is_open();
}

void ExclusiveFile::commit() {
  assert(owned());
  namespace fs = llvm::sys::fs;
  if (out.is_open()) {
    out.close();
    if (auto ec = fs::rename(workingPath, targetPath)) {
      unrecoverableError("rename file", targetPath, ec);
    }
  }
}

void ExclusiveFile::checkOutput(const char* action) {
  if (!out) {
    unrecoverableError(action, workingPath);
  }
}

}  // namespace codeql
