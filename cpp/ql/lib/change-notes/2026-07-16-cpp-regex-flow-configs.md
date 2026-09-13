---
category: minorAnalysis
---
* Added internal C++ regex usage and flow modeling (`semmle.code.cpp.regex.RegexFlowConfigs`). The `RegexTreeView` `RegExp` class now only matches `StringLiteral`s that flow to a `std::basic_regex` construction/assignment or a `std::regex_match`/`std::regex_search`/`std::regex_replace`/`std::regex_iterator`/`std::regex_token_iterator` call. Construction-site flags in `std::regex_constants` are detected (`icase`, `multiline`, and the grammar flags), including bitwise-`|` combinations. Literals constructed with an explicit non-ECMAScript grammar flag (`basic`, `extended`, `awk`, `grep`, `egrep`) are excluded from the ECMAScript-only parser. No new queries are added in this release.
