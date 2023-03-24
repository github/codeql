#pragma once

#include <iostream>
#include <vector>
#include <variant>
#include <string>

#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

struct SwiftMangledName {
  using Part = std::variant<UntypedTrapLabel, std::string, unsigned>;

  std::vector<Part> parts;

  explicit operator bool() const { return !parts.empty(); }

  std::string str() const;

  // let's avoid copying as long as we don't need it
  SwiftMangledName() = default;
  SwiftMangledName(const SwiftMangledName&) = delete;
  SwiftMangledName& operator=(const SwiftMangledName&) = delete;
  SwiftMangledName(SwiftMangledName&&) = default;
  SwiftMangledName& operator=(SwiftMangledName&&) = default;

  // streaming labels or ints into a SwiftMangledName just appends them
  SwiftMangledName& operator<<(UntypedTrapLabel label) &;
  SwiftMangledName& operator<<(unsigned i) &;

  // streaming string-like stuff will add a new part it only if strictly required, otherwise it will
  // append to the last part if it is a string
  template <typename T>
  SwiftMangledName& operator<<(T&& arg) & {
    if (parts.empty() || !std::holds_alternative<std::string>(parts.back())) {
      parts.emplace_back("");
    }
    std::get<std::string>(parts.back()) += std::forward<T>(arg);
    return *this;
  }

  SwiftMangledName& operator<<(SwiftMangledName&& other) &;
  SwiftMangledName& operator<<(const SwiftMangledName& other) &;

  template <typename T>
  SwiftMangledName&& operator<<(T&& arg) && {
    return std::move(operator<<(std::forward<T>(arg)));
  }
};

}  // namespace codeql
