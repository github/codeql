#include "swift/logging/SwiftDiagnostics.h"

#include <binlog/Entries.hpp>
#include <nlohmann/json.hpp>
#include "absl/strings/str_join.h"
#include "absl/strings/str_cat.h"
#include "absl/strings/str_split.h"

namespace codeql {
void SwiftDiagnosticsSource::emit(std::ostream& out,
                                  std::string_view timestamp,
                                  std::string_view message) const {
  nlohmann::json entry = {
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
      {"timestamp", timestamp},
  };
  out << entry << '\n';
}

std::string SwiftDiagnosticsSource::sourceId() const {
  auto ret = absl::StrJoin({extractorName, programName, id}, "/");
  std::replace(ret.begin(), ret.end(), '_', '-');
  return ret;
}

void SwiftDiagnosticsDumper::write(const char* buffer, std::size_t bufferSize) {
  binlog::Range range{buffer, bufferSize};
  binlog::RangeEntryStream input{range};
  while (auto event = events.nextEvent(input)) {
    const auto& source = SwiftDiagnosticsSource::get(event->source->category);
    std::ostringstream oss;
    timestampedMessagePrinter.printEvent(oss, *event, events.writerProp(), events.clockSync());
    // TODO(C++20) use oss.view() directly
    auto data = oss.str();
    std::string_view view = data;
    using ViewPair = std::pair<std::string_view, std::string_view>;
    auto [timestamp, message] = ViewPair(absl::StrSplit(view, absl::MaxSplits(' ', 1)));
    source.emit(output, timestamp, message);
  }
}
}  // namespace codeql
