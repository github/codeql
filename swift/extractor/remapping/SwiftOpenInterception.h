#pragma once

#include <string>
#include <unordered_map>

namespace codeql {

void initInterception(const std::string& dir);
void remapArtifacts(const std::unordered_map<std::string, std::string>& mapping);

}  // namespace codeql
