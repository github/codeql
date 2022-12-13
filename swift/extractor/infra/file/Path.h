#pragma once

#include <filesystem>

namespace codeql {
std::filesystem::path resolvePath(std::string_view path);
}
