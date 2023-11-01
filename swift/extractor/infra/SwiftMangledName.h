#pragma once

#include <iostream>
#include <vector>
#include <variant>
#include <string>

#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

class SwiftMangledName {
 public:
  using Part = std::variant<UntypedTrapLabel, std::string, unsigned>;

  explicit operator bool() const { return !value.empty(); }

  const std::string& str() const { return value; }
  operator std::string_view() const { return value; }

  std::string hash() const;

  // let's avoid copying as long as we don't need it
  SwiftMangledName() = default;
  SwiftMangledName(const SwiftMangledName&) = delete;
  SwiftMangledName& operator=(const SwiftMangledName&) = delete;
  SwiftMangledName(SwiftMangledName&&) = default;
  SwiftMangledName& operator=(SwiftMangledName&&) = default;

  template <typename... Args>
  SwiftMangledName(Args&&... args) {
    (operator<<(std::forward<Args>(args)), ...);
  }

  SwiftMangledName& operator<<(UntypedTrapLabel label) &;
  SwiftMangledName& operator<<(unsigned i) &;

  template <typename Tag>
  SwiftMangledName& operator<<(TrapLabel<Tag> label) & {
    return operator<<(static_cast<UntypedTrapLabel>(label));
  }

  // streaming string-like stuff will add a new part it only if strictly required, otherwise it will
  // append to the last part if it is a string
  template <typename T>
  SwiftMangledName& operator<<(T&& arg) & {
    value += arg;
    return *this;
  }

  template <typename T>
  SwiftMangledName&& operator<<(T&& arg) && {
    return std::move(operator<<(std::forward<T>(arg)));
  }

 private:
  std::string value;
};

}  // namespace codeql
