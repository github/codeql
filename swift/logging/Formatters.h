#pragma once

// Provides formatters for standard library types to be used with fmtlib.
// TODO: Patch fmtlib to support using `fmt/std.h` without RTTI
//       (https://github.com/fmtlib/fmt/issues/3170).

#include <filesystem>
#include <fmt/format.h>
#include <string_view>

namespace fmt {
FMT_FORMAT_AS(std::filesystem::path, std::string);
}

template <>
struct fmt::formatter<std::error_code> : fmt::formatter<std::string> {
  auto format(const std::error_code& e, format_context& ctx) const {
    return fmt::formatter<std::string>::format(e.message(), ctx);
  }
};
