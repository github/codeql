#pragma once

#include <string>
#include <unordered_map>

namespace codeql {

void initRemapping(const std::string& dir);
void finalizeRemapping(const std::unordered_map<std::string, std::string>& mapping);

}  // namespace codeql
