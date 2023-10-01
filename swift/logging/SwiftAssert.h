#pragma once

#include <cstdlib>

#include "swift/logging/SwiftLogging.h"

// Assert CONDITION, which is always evaluated (once) regardless of the build type. If
// CONDITION is not satisfied, emit a critical log and diagnostic optionally using provided format
// and arguments, and then abort the program.
#define CODEQL_ASSERT(CONDITION, ...) \
  CODEQL_ASSERT_IMPL(critical, std::abort(), CONDITION, __VA_ARGS__)

// If CONDITION is not satisfied, emit an error log and diagnostic optionally using provided format
// and arguments, but continue execution
#define CODEQL_EXPECT(CONDITION, ...) CODEQL_EXPECT_OR(void(), CONDITION, __VA_ARGS__)

// If CONDITION is not satisfied, emit an error log and diagnostic optionally using provided format
// and arguments, and execute ACTION (for example return)
#define CODEQL_EXPECT_OR(ACTION, CONDITION, ...) \
  CODEQL_ASSERT_IMPL(error, ACTION, CONDITION, __VA_ARGS__)

#define CODEQL_ASSERT_IMPL(LEVEL, ACTION, CONDITION, ...)                                          \
  do {                                                                                             \
    if (!(CONDITION)) {                                                                            \
      [[unlikely]] DIAGNOSE_WITH_LEVEL(LEVEL, codeql::internalError,                               \
                                       "CodeQL encountered an unexpected internal error with the " \
                                       "following message:\n> Assertion failed: `" #CONDITION      \
                                       "`. " __VA_ARGS__);                                         \
      ACTION;                                                                                      \
    }                                                                                              \
  } while (false)
