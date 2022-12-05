#pragma once

#include <string>
#include <unordered_map>
#include <filesystem>
#include <memory>

#include "swift/extractor/infra/file/PathHash.h"

namespace codeql {

int openReal(const std::filesystem::path& path);

class FileInterceptor;

std::shared_ptr<FileInterceptor> setupFileInterception(std::filesystem::path workingDir);

std::filesystem::path redirect(const std::filesystem::path& target);
}  // namespace codeql
