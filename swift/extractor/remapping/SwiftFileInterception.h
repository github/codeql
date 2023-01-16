#pragma once

#include <string>
#include <unordered_map>
#include <filesystem>
#include <memory>

#include "swift/extractor/config/SwiftExtractorConfiguration.h"

namespace codeql {

std::optional<std::string> getHashOfRealFile(const std::filesystem::path& path);

class FileInterceptor;

std::shared_ptr<FileInterceptor> setupFileInterception(
    const SwiftExtractorConfiguration& configuration);

std::filesystem::path redirect(const std::filesystem::path& target);
}  // namespace codeql
