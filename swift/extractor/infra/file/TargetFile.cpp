#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/infra/file/FsLogger.h"
#include "swift/logging/SwiftLogging.h"
#include "swift/logging/SwiftAssert.h"

#include <cassert>
#include <cstdio>
#include <cerrno>
#include <system_error>
#include <filesystem>

namespace fs = std::filesystem;

namespace codeql {

using namespace fs_logger;

namespace {
std::error_code currentErrorCode() {
  return {errno, std::system_category()};
}

void ensureParentDir(const fs::path& path) {
  auto parent = path.parent_path();
  std::error_code ec;
  fs::create_directories(parent, ec);
  CODEQL_ASSERT(!ec, "Unable to create directory {} ({})", parent, ec);
}

fs::path initPath(const std::filesystem::path& target, const std::filesystem::path& dir) {
  fs::path ret{dir};
  CODEQL_ASSERT(!target.empty());
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
    checkOutput("open");
    return true;
  }
  CODEQL_ASSERT(errno == EEXIST, "Unable to open {} for writing ({})", targetPath,
                currentErrorCode());
  // else the file already exists and we just lost the race
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
    CODEQL_ASSERT(!ec, "Unable to rename {} -> {} ({})", workingPath, targetPath, ec);
  }
}

void TargetFile::checkOutput(const char* action) {
  CODEQL_ASSERT(out, "Unable to {} {} ({})", action, workingPath, currentErrorCode());
}
}  // namespace codeql
