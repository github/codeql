---
category: newQuery
---
* Added a new query, `cpp/polynomial-redos`, for detecting polynomial-time regular expression denial-of-service (ReDoS) vulnerabilities where user-controlled data is matched against a `std::regex` whose pattern can exhibit super-linear worst-case matching behavior. This is the C++ analogue of `java/polynomial-redos` and is based on the shared `SuperlinearBackTracking` analysis wired to the C++ regex parse tree (`semmle.code.cpp.regex.RegexTreeView`) and the C++ regex flow modeling (`semmle.code.cpp.regex.RegexFlowConfigs`).
