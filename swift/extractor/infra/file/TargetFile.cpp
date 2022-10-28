#include "swift/extractor/infra/file/TargetFile.h"

#include <iostream>
#include <cassert>
#include <cstdio>
#include <cerrno>
#include <system_error>
#include <filesystem>

namespace fs = std::filesystem;

namespace codeql {
namespace {
[[noreturn]] void error(const char* action, const fs::path& arg, std::error_code ec) {
  std::cerr << "Unable to " << action << ": " << arg << " (" << ec.message() << ")\n";
  std::abort();
}

[[noreturn]] void error(const char* action, const fs::path& arg) {
  error(action, arg, {errno, std::system_category()});
}

void check(const char* action, const fs::path& arg, std::error_code ec) {
  if (ec) {
    error(action, arg, ec);
  }
}

void ensureParentDir(const fs::path& path) {
  auto parent = path.parent_path();
  std::error_code ec;
  fs::create_directories(parent, ec);
  check("create directory", parent, ec);
}

fs::path initPath(const std::filesystem::path& target, const std::filesystem::path& dir) {
  fs::path ret{dir};
  assert(!target.empty() && "target must be a non-empty path");
  ret /= target.relative_path();
  ensureParentDir(ret);
  return ret;
}
}  // namespace

TargetFile::TargetFile(const std::filesystem::path& target,
                       const std::filesystem::path& targetDir,
                       const std::filesystem::path& workingDir)
    : workingPath{initPath(target, workingDir)}, targetPath{initPath(target, targetDir)} {}

bool TargetFile::init() {
  errno = 0;
  // since C++17 "x" mode opens with O_EXCL (fails if file already exists)
  if (auto f = std::fopen(targetPath.c_str(), "wx")) {
    std::fclose(f);
    out.open(workingPath);
    checkOutput("open file for writing");
    return true;
  }
  if (errno != EEXIST) {
    error("open file for writing", targetPath);
  }
  // else we just lost the race
  return false;
}

std::optional<TargetFile> TargetFile::create(const std::filesystem::path& target,
                                             const std::filesystem::path& targetDir,
                                             const std::filesystem::path& workingDir) {
  TargetFile ret{target, targetDir, workingDir};
  if (ret.init()) return ret;
  return std::nullopt;
}

void TargetFile::commit() {
  if (out.is_open()) {
    out.close();
    std::error_code ec;
    fs::rename(workingPath, targetPath, ec);
    check("rename file", targetPath, ec);
  }
}

void TargetFile::checkOutput(const char* action) {
  if (!out) {
    error(action, workingPath);
  }
}
}  // namespace codeql
