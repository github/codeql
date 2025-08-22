#include "Diagnostics.h"

#include <fmt/format.h>
#include <fmt/chrono.h>

#include "absl/strings/str_join.h"
#include "absl/strings/str_cat.h"

namespace codeql {

namespace {
std::string_view severityToString(Diagnostic::Severity severity) {
  using S = Diagnostic::Severity;
  switch (severity) {
    case S::note:
      return "note";
    case S::warning:
      return "warning";
    case S::error:
      return "error";
    default:
      return "unknown";
  }
}
}  // namespace

nlohmann::json Diagnostic::json(const std::chrono::system_clock::time_point& timestamp,
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
           {"statusPage", has(Visibility::statusPage)},
           {"cliSummaryTable", has(Visibility::cliSummaryTable)},
           {"telemetry", has(Visibility::telemetry)},
       }},
      {"severity", severityToString(severity)},
      {"markdownMessage", absl::StrCat(message, "\n\n", action)},
      {"timestamp", fmt::format("{:%FT%T%z}", timestamp)},
  };
  if (location) {
    ret["location"] = location->json();
  }
  return ret;
}

std::string Diagnostic::abbreviation() const {
  if (location) {
    return absl::StrCat(id, "@", location->str());
  }
  return std::string{id};
}

bool Diagnostic::has(Visibility v) const {
  return (visibility & v) != Visibility::none;
}

nlohmann::json DiagnosticsLocation::json() const {
  nlohmann::json ret{{"file", file}};
  if (startLine) ret["startLine"] = startLine;
  if (startColumn) ret["startColumn"] = startColumn;
  if (endLine) ret["endLine"] = endLine;
  if (endColumn) ret["endColumn"] = endColumn;
  return ret;
}

std::string DiagnosticsLocation::str() const {
  return absl::StrJoin(std::tuple{file, startLine, startColumn, endLine, endColumn}, ":");
}
}  // namespace codeql
