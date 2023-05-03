#include "swift/log/SwiftDiagnostics.h"

#include <date/date.h>
#include <binlog/Entries.hpp>
#include <nlohmann/json.hpp>

namespace codeql {
SwiftDiagnosticsSource::SwiftDiagnosticsSource(std::string_view internalId,
                                               std::string&& name,
                                               std::vector<std::string>&& helpLinks,
                                               std::string&& action)
    : name{std::move(name)}, helpLinks{std::move(helpLinks)}, action{std::move(action)} {
  id = extractorName;
  id += '/';
  id += programName;
  id += '/';
  std::transform(internalId.begin(), internalId.end(), std::back_inserter(id),
                 [](char c) { return c == '_' ? '-' : c; });
}

void SwiftDiagnosticsSource::create(std::string_view id,
                                    std::string name,
                                    std::vector<std::string> helpLinks,
                                    std::string action) {
  auto [it, inserted] = map().emplace(
      id, SwiftDiagnosticsSource{id, std::move(name), std::move(helpLinks), std::move(action)});
  assert(inserted);
}

void SwiftDiagnosticsSource::emit(std::ostream& out,
                                  std::string_view timestamp,
                                  std::string_view message) const {
  nlohmann::json entry;
  auto& source = entry["source"];
  source["id"] = id;
  source["name"] = name;
  source["extractorName"] = extractorName;

  auto& visibility = entry["visibility"];
  visibility["statusPage"] = true;
  visibility["cliSummaryTable"] = true;
  visibility["telemetry"] = true;

  entry["severity"] = "error";
  entry["helpLinks"] = helpLinks;
  std::string plaintextMessage{message};
  plaintextMessage += ".\n\n";
  plaintextMessage += action;
  plaintextMessage += '.';
  entry["plaintextMessage"] = plaintextMessage;

  entry["timestamp"] = timestamp;

  out << entry << '\n';
}

void SwiftDiagnosticsDumper::write(const char* buffer, std::size_t bufferSize) {
  binlog::Range range{buffer, bufferSize};
  binlog::RangeEntryStream input{range};
  while (auto event = events.nextEvent(input)) {
    const auto& source = SwiftDiagnosticsSource::get(event->source->category);
    std::ostringstream oss;
    timestampedMessagePrinter.printEvent(oss, *event, events.writerProp(), events.clockSync());
    auto data = oss.str();
    std::string_view view = data;
    auto sep = view.find(' ');
    assert(sep != std::string::npos);
    auto timestamp = view.substr(0, sep);
    auto message = view.substr(sep + 1);
    source.emit(output, timestamp, message);
  }
}
}  // namespace codeql
