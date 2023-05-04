#pragma once

#include <binlog/EventStream.hpp>
#include <binlog/PrettyPrinter.hpp>
#include <string>
#include <vector>
#include <unordered_map>
#include <cassert>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <mutex>

namespace codeql {

extern const std::string_view programName;

// Models a diagnostic source for Swift, holding static information that goes out into a diagnostic
// These are internally stored into a map on id's. A specific error log can use binlog's category
// as id, which will then be used to recover the diagnostic source while dumping.
struct SwiftDiagnosticsSource {
  std::string_view id;
  std::string_view name;
  static constexpr std::string_view extractorName = "swift";
  std::string_view action;
  std::string_view helpLinks;  // space separated if more than 1. Not a vector to allow constexpr

  // for the moment, we only output errors, so no need to store the severity

  // registers a diagnostics source for later retrieval with get, if not done yet
  template <const SwiftDiagnosticsSource* Spec>
  static void inscribe() {
    static std::once_flag once;
    std::call_once(once, [] {
      auto [it, inserted] = map().emplace(Spec->id, Spec);
      assert(inserted);
    });
  }

  // gets a previously inscribed SwiftDiagnosticsSource for the given id. Will abort if none exists
  static const SwiftDiagnosticsSource& get(const std::string& id) { return *map().at(id); }

  // emit a JSON diagnostics for this source with the given timestamp and message to out
  // A plaintextMessage is used that includes both the message and the action to take. Dots are
  // appended to both. The id is used to construct the source id in the form
  // `swift/<prog name>/<id with '-' replacing '_'>`
  void emit(std::ostream& out, std::string_view timestamp, std::string_view message) const;

 private:
  std::string sourceId() const;
  using Map = std::unordered_map<std::string, const SwiftDiagnosticsSource*>;

  static Map& map() {
    static Map ret;
    return ret;
  }
};

// An output modeling binlog's output stream concept that intercepts binlog entries and translates
// them to appropriate diagnostics JSON entries
class SwiftDiagnosticsDumper {
 public:
  // opens path for writing out JSON entries. Returns whether the operation was successful.
  bool open(const std::filesystem::path& path) {
    output.open(path);
    return output.good();
  }

  // write out binlog entries as corresponding JSON diagnostics entries. Expects all entries to have
  // a category equal to an id of a previously created SwiftDiagnosticSource.
  void write(const char* buffer, std::size_t bufferSize);

 private:
  binlog::EventStream events;
  std::ofstream output;
  binlog::PrettyPrinter timestampedMessagePrinter{"%u %m", "%Y-%m-%dT%H:%M:%S.%NZ"};
};

}  // namespace codeql

namespace codeql_diagnostics {
constexpr codeql::SwiftDiagnosticsSource internal_error{
    "internal_error",
    "Internal error",
    "Contact us about this issue",
};
}  // namespace codeql_diagnostics
