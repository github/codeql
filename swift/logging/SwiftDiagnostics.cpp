#include "swift/logging/SwiftDiagnostics.h"

#include <binlog/Entries.hpp>
#include "absl/strings/str_join.h"
#include "absl/strings/str_cat.h"
#include "absl/strings/str_split.h"
#include "swift/logging/SwiftAssert.h"

namespace codeql {

nlohmann::json SwiftDiagnosticsSource::json(const std::chrono::system_clock::time_point& timestamp,
                                            std::string_view message) const {
  return {
      {"source",
       {
           {"id", sourceId()},
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
}

std::string SwiftDiagnosticsSource::sourceId() const {
  return absl::StrJoin({extractorName, programName, id}, "/");
}

nlohmann::json SwiftDiagnosticsSourceWithLocation::json(
    const std::chrono::system_clock::time_point& timestamp,
    std::string_view message) const {
  auto ret = source.json(timestamp, message);
  auto& location = ret["location"] = {{"file", file}};
  if (startLine) location["startLine"] = startLine;
  if (startColumn) location["startColumn"] = startColumn;
  if (endLine) location["endLine"] = endLine;
  if (endColumn) location["endColumn"] = endColumn;
  return ret;
}

std::string SwiftDiagnosticsSourceWithLocation::str() const {
  return absl::StrCat(source.id, "@", file, ":", startLine, ":", startColumn, ":", endLine, ":",
                      endColumn);
}
}  // namespace codeql
