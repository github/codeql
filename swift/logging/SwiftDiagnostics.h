#pragma once

#include <binlog/binlog.hpp>
#include <string>
#include <vector>
#include <unordered_map>
#include <cassert>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <mutex>
#include <fmt/format.h>
#include <fmt/chrono.h>
#include <nlohmann/json.hpp>

namespace codeql {

extern const std::string_view programName;

struct SwiftDiagnosticsSource;

struct SwiftDiagnosticsSourceWithLocation {
  const SwiftDiagnosticsSource& source;
  std::string_view file;
  unsigned startLine;
  unsigned startColumn;
  unsigned endLine;
  unsigned endColumn;

  // see SwiftDiagnosticsSource::json
  nlohmann::json json(const std::chrono::system_clock::time_point& timestamp,
                      std::string_view message) const;

  std::string str() const;
};

// Models a diagnostic source for Swift, holding static information that goes out into a diagnostic
// These are internally stored into a map on id's. A specific error log can use binlog's category
// as id, which will then be used to recover the diagnostic source while dumping.
struct SwiftDiagnosticsSource {
  std::string_view id;
  std::string_view name;
  static constexpr std::string_view extractorName = "swift";
  std::string_view action;
  // space separated if more than 1. Not a vector to allow constexpr
  // TODO(C++20) with vector going constexpr this can be turned to `std::vector<std::string_view>`
  std::string_view helpLinks;

  // for the moment, we only output errors, so no need to store the severity

  // create a JSON diagnostics for this source with the given timestamp and message to out
  // A plaintextMessage is used that includes both the message and the action to take. Dots are
  // appended to both. The id is used to construct the source id in the form
  // `swift/<prog name>/<id>`
  nlohmann::json json(const std::chrono::system_clock::time_point& timestamp,
                      std::string_view message) const;

  SwiftDiagnosticsSourceWithLocation withLocation(std::string_view file,
                                                  unsigned startLine = 0,
                                                  unsigned startColumn = 0,
                                                  unsigned endLine = 0,
                                                  unsigned endColumn = 0) const {
    return {*this, file, startLine, startColumn, endLine, endColumn};
  }

 private:
  std::string sourceId() const;
};

class SwiftDiagnosticsDumper {
 public:
  // opens path for writing out JSON entries. Returns whether the operation was successful.
  bool open(const std::filesystem::path& path) {
    output.open(path);
    return output.good();
  }

  void flush() { output.flush(); }

  template <typename Source>
  void write(const Source& source,
             const std::chrono::system_clock::time_point& timestamp,
             std::string_view message) {
    if (output) {
      output << source.json(timestamp, message) << '\n';
    }
  }

  bool good() const { return output.good(); }
  explicit operator bool() const { return good(); }

 private:
  std::ofstream output;
};

constexpr codeql::SwiftDiagnosticsSource internalError{
    "internal-error",
    "Internal error",
    "Contact us about this issue",
};
}  // namespace codeql

namespace mserialize {
// log diagnostic sources using just their id, using binlog/mserialize internal plumbing
template <>
struct CustomTag<codeql::SwiftDiagnosticsSource, void> : detail::BuiltinTag<std::string> {
  using T = codeql::SwiftDiagnosticsSource;
};

template <>
struct CustomSerializer<codeql::SwiftDiagnosticsSource, void> {
  template <typename OutputStream>
  static void serialize(const codeql::SwiftDiagnosticsSource& source, OutputStream& out) {
    mserialize::serialize(source.id, out);
  }

  static size_t serialized_size(const codeql::SwiftDiagnosticsSource& source) {
    return mserialize::serialized_size(source.id);
  }
};

template <>
struct CustomTag<codeql::SwiftDiagnosticsSourceWithLocation, void>
    : detail::BuiltinTag<std::string> {
  using T = codeql::SwiftDiagnosticsSourceWithLocation;
};

template <>
struct CustomSerializer<codeql::SwiftDiagnosticsSourceWithLocation, void> {
  template <typename OutputStream>
  static void serialize(const codeql::SwiftDiagnosticsSourceWithLocation& source,
                        OutputStream& out) {
    mserialize::serialize(source.str(), out);
  }

  static size_t serialized_size(const codeql::SwiftDiagnosticsSourceWithLocation& source) {
    return mserialize::serialized_size(source.str());
  }
};

}  // namespace mserialize
