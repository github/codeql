---
category: minorAnalysis
---
* The C++ ReDoS queries (`cpp/redos` and `cpp/polynomial-redos`) now treat regexes constructed with the `std::regex_constants::awk`, `grep`, or `egrep` grammar flags as non-backtracking, and exclude them from analysis. These POSIX tool-style grammars correspond to traditionally linear-time (DFA-based) matching semantics, so super-linear-backtracking ReDoS does not apply. The `basic` (BRE) and `extended` (ERE) grammars remain backtracking-eligible. Grammar selection and ReDoS-eligibility are exposed as independent axes via the new `isBacktrackingEngine` predicate in `semmle.code.cpp.regex.RegexFlowConfigs`.
