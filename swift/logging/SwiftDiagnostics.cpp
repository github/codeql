#include "swift/logging/SwiftDiagnostics.h"

#include <binlog/Entries.hpp>
#include "absl/strings/str_join.h"
#include "absl/strings/str_cat.h"
#include "absl/strings/str_split.h"
#include "swift/logging/SwiftAssert.h"

namespace codeql {

nlohmann::json SwiftDiagnostic::json(const std::chrono::system_clock::time_point& timestamp,
                                     std::string_view message) const {
  nlohmann::json ret{
      {"source",
       {
           {"id", absl::StrJoin({extractorName, programName, id}, "/")},
           {"name", name},
           {"extractorName", extractorName},
       }},
      {"visibility",
       {
           {"statusPage", true},
           {"cliSummaryTable", true},
           {"telemetry", true},
       }},
      {"severity", "error"},
      {"helpLinks", std::vector<std::string_view>(absl::StrSplit(helpLinks, ' '))},
      {"plaintextMessage", absl::StrCat(message, ".\n\n", action, ".")},
      {"timestamp", fmt::format("{:%FT%T%z}", timestamp)},
  };
  if (location) {
    ret["location"] = location->json();
  }
  return ret;
}

std::string SwiftDiagnostic::abbreviation() const {
  if (location) {
    return absl::StrCat(id, "@", location->str());
  }
  return std::string{id};
}

nlohmann::json SwiftDiagnosticsLocation::json() const {
  nlohmann::json ret{{"file", file}};
  if (startLine) ret["startLine"] = startLine;
  if (startColumn) ret["startColumn"] = startColumn;
  if (endLine) ret["endLine"] = endLine;
  if (endColumn) ret["endColumn"] = endColumn;
  return ret;
}

std::string SwiftDiagnosticsLocation::str() const {
  return absl::StrJoin(std::tuple{file, startLine, startColumn, endLine, endColumn}, ":");
}
}  // namespace codeql
