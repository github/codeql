#pragma once

#include <fstream>
#include <iostream>
#include <regex>
#include <vector>

#include <binlog/binlog.hpp>
#include <binlog/TextOutputStream.hpp>
#include <binlog/EventFilter.hpp>

// Logging macros. These will call `logger()` to get a Logger instance, picking up any `logger`
// defined in the current scope. A default `codeql::logger()` is provided, otherwise domain-specific
// loggers can be added as class fields called `logger` (as `Logger::operator()()` returns itself).
// Domain specific loggers are set up with a name that appears in the log and can be used to filter
// debug levels (see `Logger`). If working in the global namespace, the default logger can be used
// by defining `auto& logger = codeql::logger();`
#define LOG_CRITICAL(...) LOG_IMPL(codeql::Log::Level::critical, __VA_ARGS__)
#define LOG_ERROR(...) LOG_IMPL(codeql::Log::Level::error, __VA_ARGS__)
#define LOG_WARNING(...) LOG_IMPL(codeql::Log::Level::warning, __VA_ARGS__)
#define LOG_INFO(...) LOG_IMPL(codeql::Log::Level::info, __VA_ARGS__)
#define LOG_DEBUG(...) LOG_IMPL(codeql::Log::Level::debug, __VA_ARGS__)
#define LOG_TRACE(...) LOG_IMPL(codeql::Log::Level::trace, __VA_ARGS__)

// avoid calling into binlog's original macros
#undef BINLOG_CRITICAL
#undef BINLOG_CRITICAL_W
#undef BINLOG_CRITICAL_C
#undef BINLOG_CRITICAL_WC
#undef BINLOG_ERROR
#undef BINLOG_ERROR_W
#undef BINLOG_ERROR_C
#undef BINLOG_ERROR_WC
#undef BINLOG_WARNING
#undef BINLOG_WARNING_W
#undef BINLOG_WARNING_C
#undef BINLOG_WARNING_WC
#undef BINLOG_INFO
#undef BINLOG_INFO_W
#undef BINLOG_INFO_C
#undef BINLOG_INFO_WC
#undef BINLOG_DEBUG
#undef BINLOG_DEBUG_W
#undef BINLOG_DEBUG_C
#undef BINLOG_DEBUG_WC
#undef BINLOG_TRACE
#undef BINLOG_TRACE_W
#undef BINLOG_TRACE_C
#undef BINLOG_TRACE_WC

// only do the actual logging if the picked up `Logger` instance is configured to handle the
// provided log level
#define LOG_IMPL(severity, ...)                                                        \
  do {                                                                                 \
    if (auto& _logger = logger(); severity >= _logger.level()) {                       \
      BINLOG_CREATE_SOURCE_AND_EVENT(_logger.writer(), severity, , binlog::clockNow(), \
                                     __VA_ARGS__);                                     \
    }                                                                                  \
  } while (false)

namespace codeql {

// This class is responsible for the global log state (outputs, log level rules, flushing)
// State is stored in the singleton `Log::instance()`.
// Before using logging, `Log::configure("<name>")` should be used (e.g.
// `Log::configure("extractor")`). Then, `Log::flush()` should be regularly called.
class Log {
 public:
  using Level = binlog::Severity;

 private:
  // Output filtered according to a configured log level
  template <typename Output>
  struct FilteredOutput {
    binlog::Severity level;
    Output output;
    binlog::EventFilter filter{
        [this](const binlog::EventSource& src) { return src.severity >= level; }};

    template <typename... Args>
    FilteredOutput(Level level, Args&&... args)
        : level{level}, output{std::forward<Args>(args)...} {}

    FilteredOutput& write(const char* buffer, std::streamsize size) {
      filter.writeAllowed(buffer, size, output);
      return *this;
    }

    // if configured as `no_logs`, the output is effectively disabled
    explicit operator bool() const { return level < Level::no_logs; }
  };

  using LevelRule = std::pair<std::regex, Level>;
  using LevelRules = std::vector<LevelRule>;

  static constexpr const char* format = "%u %S [%n] %m (%G:%L)\n";

  binlog::Session session;
  std::ofstream textFile;
  FilteredOutput<std::ofstream> binary{Level::no_logs};
  FilteredOutput<binlog::TextOutputStream> text{Level::info, textFile, format};
  FilteredOutput<binlog::TextOutputStream> console{Level::warning, std::cerr, format};
  LevelRules sourceRules;
  std::string rootName;

  Log() = default;

  static Log& instance() {
    static Log ret;
    return ret;
  }

  friend class Logger;
  friend binlog::Session;

  Level getLevelForSource(std::string_view name) const;
  Log& write(const char* buffer, std::streamsize size);
  static class Logger& logger();

 public:
  // Configure logging. This consists in
  // * setting up a default logger with `root` as name
  // * using environment variable `CODEQL_EXTRACTOR_SWIFT_LOG_DIR` to choose where to dump the log
  //   file(s). Log files will go to a subdirectory thereof named after `root`
  // * using environment variable `CODEQL_EXTRACTOR_SWIFT_LOG_LEVELS` to configure levels for
  //   loggers and outputs. This must have the form of a comma separated `spec:level` list, where
  //   `spec` is either a glob pattern (made up of alphanumeric, `/`, `*` and `.` characters) for
  //   matching logger names or one of `out:bin`, `out:text` or `out:console`.
  //   Output default levels can be seen in the corresponding initializers above. By default, all
  //   loggers are configured with the lowest output level
  static void configure(std::string_view root);

  // Flush logs to the designated outputs
  static void flush();
};

// This class represent a named domain-specific logger, responsible for pushing logs using the
// underlying `binlog::SessionWriter` class. This has a configured log level, so that logs on this
// `Logger` with a level lower than the configured one are no-ops.
class Logger {
  binlog::SessionWriter w{Log::instance().session};
  Log::Level level_{Log::Level::no_logs};

  void setName(std::string name);

  friend Logger& logger();
  // constructor for the default `Logger`
  explicit Logger() { setName(Log::instance().rootName); }

 public:
  explicit Logger(const std::string& name) { setName(Log::instance().rootName + '/' + name); }

  binlog::SessionWriter& writer() { return w; }
  Log::Level level() const { return level_; }

  // make defining a `Logger logger` field be equivalent to providing a `Logger& logger()` function
  // in order to be picked up by logging macros
  Logger& operator()() { return *this; }
};

// default logger
Logger& logger();

}  // namespace codeql
