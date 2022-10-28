#pragma once

#include <string>
#include <unordered_map>
#include <filesystem>

#include "swift/extractor/infra/file/PathHash.h"

namespace codeql {

void initRemapping(const std::filesystem::path& dir);
void finalizeRemapping(
    const std::unordered_map<std::filesystem::path, std::filesystem::path>& mapping);

}  // namespace codeql
