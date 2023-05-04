#pragma once

#include <cstdlib>

#include "swift/extractor/infra/log/SwiftLogging.h"

// assert CONDITION, which is always evaluated (once) regardless of the build type. If
// CONDITION is not satisfied, emit a critical log optionally using provided format and arguments,
// abort the program
#define CODEQL_ASSERT(CONDITION, ...) \
  CODEQL_ASSERT_IMPL(CRITICAL, std::abort(), CONDITION, __VA_ARGS__)

// If CONDITION is not satisfied, emit an error log optionally using provided format and arguments,
// but continue execution
#define CODEQL_EXPECT(CONDITION, ...) CODEQL_EXPECT_OR(void(), CONDITION, __VA_ARGS__)

// If CONDITION is not satisfied, emit an error log optionally using provided format and arguments,
// and execute ACTION (for example return)
#define CODEQL_EXPECT_OR(ACTION, CONDITION, ...) \
  CODEQL_ASSERT_IMPL(ERROR, ACTION, CONDITION, __VA_ARGS__)

#define CODEQL_ASSERT_IMPL(LEVEL, ACTION, CONDITION, ...)                           \
  do {                                                                              \
    if (!(CONDITION)) {                                                             \
      [[unlikely]] LOG_##LEVEL("assertion failed on " #CONDITION ". " __VA_ARGS__); \
      codeql::Log::flush();                                                         \
      ACTION;                                                                       \
    }                                                                               \
  } while (false)
