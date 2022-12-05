#pragma once

#include <filesystem>

namespace codeql {
std::filesystem::path getCodeQLPath(std::string_view path);
}
