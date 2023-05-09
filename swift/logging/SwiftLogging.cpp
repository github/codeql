#include "swift/logging/SwiftLogging.h"

#include <filesystem>
#include <stdlib.h>
#include <optional>

#define LEVEL_REGEX_PATTERN "trace|debug|info|warning|error|critical|no_logs"

BINLOG_ADAPT_ENUM(codeql::Log::Level, trace, debug, info, warning, error, critical, no_logs)

namespace codeql {

namespace {
using LevelRule = std::pair<std::regex, Log::Level>;
using LevelRules = std::vector<LevelRule>;

Log::Level getLevelFor(std::string_view name, const LevelRules& rules, Log::Level dflt) {
  for (auto it = rules.rbegin(); it != rules.rend(); ++it) {
    if (std::regex_match(std::begin(name), std::end(name), it->first)) {
      return it->second;
    }
  }
  return dflt;
}

const char* getEnvOr(const char* var, const char* dflt) {
  if (const char* ret = getenv(var)) {
    return ret;
  }
  return dflt;
}

std::string_view matchToView(std::csub_match m) {
  return {m.first, static_cast<size_t>(m.length())};
}

Log::Level stringToLevel(std::string_view v) {
  if (v == "trace") return Log::Level::trace;
  if (v == "debug") return Log::Level::debug;
  if (v == "info") return Log::Level::info;
  if (v == "warning") return Log::Level::warning;
  if (v == "error") return Log::Level::error;
  if (v == "critical") return Log::Level::critical;
  return Log::Level::no_logs;
}

Log::Level matchToLevel(std::csub_match m) {
  return stringToLevel(matchToView(m));
}

}  // namespace

std::vector<std::string> Log::collectLevelRulesAndReturnProblems(const char* envVar) {
  std::vector<std::string> problems;
  if (auto levels = getEnvOr(envVar, nullptr)) {
    // expect comma-separated <glob pattern>:<log severity>
    std::regex comma{","};
    std::regex levelAssignment{R"((?:([*./\w]+)|(?:out:(bin|text|console))):()" LEVEL_REGEX_PATTERN
                               ")"};
    std::cregex_token_iterator begin{levels, levels + strlen(levels), comma, -1};
    std::cregex_token_iterator end{};
    for (auto it = begin; it != end; ++it) {
      std::cmatch match;
      if (std::regex_match(it->first, it->second, match, levelAssignment)) {
        auto level = matchToLevel(match[3]);
        if (match[1].matched) {
          auto pattern = match[1].str();
          // replace all "*" with ".*" and all "." with "\.", turning the glob pattern into a regex
          std::string::size_type pos = 0;
          while ((pos = pattern.find_first_of("*.", pos)) != std::string::npos) {
            pattern.insert(pos, (pattern[pos] == '*') ? "." : "\\");
            pos += 2;
          }
          sourceRules.emplace_back(pattern, level);
        } else {
          auto out = matchToView(match[2]);
          if (out == "bin") {
            binary.level = level;
          } else if (out == "text") {
            text.level = level;
          } else if (out == "console") {
            console.level = level;
          }
        }
      } else {
        problems.emplace_back("Malformed log level rule: " + it->str());
      }
    }
  }
  return problems;
}

void Log::configure() {
  // as we are configuring logging right now, we collect problems and log them at the end
  auto problems = collectLevelRulesAndReturnProblems("CODEQL_EXTRACTOR_SWIFT_LOG_LEVELS");
  auto now = std::to_string(std::chrono::system_clock::now().time_since_epoch().count());
  if (text || binary) {
    std::filesystem::path logFile = getEnvOr("CODEQL_EXTRACTOR_SWIFT_LOG_DIR", "extractor-out/log");
    logFile /= "swift";
    logFile /= programName;
    logFile /= now;
    std::error_code ec;
    std::filesystem::create_directories(logFile.parent_path(), ec);
    if (!ec) {
      if (text) {
        logFile.replace_extension(".log");
        textFile.open(logFile);
        if (!textFile) {
          problems.emplace_back("Unable to open text log file " + logFile.string());
          text.level = Level::no_logs;
        }
      }
      if (binary) {
        logFile.replace_extension(".blog");
        binary.output.open(logFile, std::fstream::out | std::fstream::binary);
        if (!binary.output) {
          problems.emplace_back("Unable to open binary log file " + logFile.string());
          binary.level = Level::no_logs;
        }
      }
    } else {
      problems.emplace_back("Unable to create log directory " + logFile.parent_path().string() +
                            ": " + ec.message());
      binary.level = Level::no_logs;
      text.level = Level::no_logs;
    }
    if (diagnostics) {
      std::filesystem::path diagFile =
          getEnvOr("CODEQL_EXTRACTOR_SWIFT_DIAGNOSTIC_DIR", "extractor-out/diagnostics");
      diagFile /= programName;
      diagFile /= now;
      diagFile.replace_extension(".jsonl");
      std::error_code ec;
      std::filesystem::create_directories(diagFile.parent_path(), ec);
      if (!ec) {
        if (!diagnostics.output.open(diagFile)) {
          problems.emplace_back("Unable to open diagnostics json file " + diagFile.string());
          diagnostics.level = Level::no_logs;
        }
      } else {
        problems.emplace_back("Unable to create diagnostics directory " +
                              diagFile.parent_path().string() + ": " + ec.message());
        diagnostics.level = Level::no_logs;
      }
    }
  }
  for (const auto& problem : problems) {
    LOG_ERROR("{}", problem);
  }
  LOG_INFO("Logging configured (binary: {}, text: {}, console: {})", binary.level, text.level,
           console.level);
  flushImpl();
}

void Log::flushImpl() {
  session.consume(*this);
  if (text) {
    textFile.flush();
  }
  if (binary) {
    binary.output.flush();
  }
}

Log::LoggerConfiguration Log::getLoggerConfigurationImpl(std::string_view name) {
  LoggerConfiguration ret{session, std::string{programName}};
  ret.fullyQualifiedName += '/';
  ret.fullyQualifiedName += name;
  ret.level = std::min({binary.level, text.level, console.level});
  ret.level = getLevelFor(ret.fullyQualifiedName, sourceRules, ret.level);
  // avoid Logger constructor loop
  if (name != "logging") {
    LOG_DEBUG("Configuring logger {} with level {}", ret.fullyQualifiedName, ret.level);
  }
  return ret;
}

Log& Log::write(const char* buffer, std::streamsize size) {
  if (text) text.write(buffer, size);
  if (binary) binary.write(buffer, size);
  if (console) console.write(buffer, size);
  if (diagnostics) diagnostics.write(buffer, size);
  return *this;
}

Logger& Log::logger() {
  static Logger ret{getLoggerConfigurationImpl("logging")};
  return ret;
}

}  // namespace codeql
