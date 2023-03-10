#pragma once

#include <memory>
#include <sstream>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/infra/SwiftMangledName.h"

namespace codeql {

// Abstracts a given trap output file, with its own universe of trap labels
class TrapDomain {
  TargetFile out;

 public:
  explicit TrapDomain(TargetFile&& out) : out{std::move(out)} {}

  template <typename Entry>
  void emit(const Entry& e) {
    out << e << '\n';
  }

  template <typename... Args>
  void debug(const Args&... args) {
    out << "/* DEBUG:\n";
    (out << ... << args);
    out << "\n*/\n";
  }

  UntypedTrapLabel createLabel() {
    auto ret = allocateLabel();
    assignStar(ret);
    out << '\n';
    return ret;
  }

  template <typename Tag>
  TrapLabel<Tag> createTypedLabel() {
    auto untyped = createLabel();
    return TrapLabel<Tag>::unsafeCreateFromUntyped(untyped);
  }

  UntypedTrapLabel createLabel(const SwiftMangledName& name) {
    auto ret = allocateLabel();
    assignKey(ret, name);
    out << '\n';
    return ret;
  }

  template <typename Tag>
  TrapLabel<Tag> createTypedLabel(const SwiftMangledName& name) {
    auto untyped = createLabel(name);
    return TrapLabel<Tag>::unsafeCreateFromUntyped(untyped);
  }

  template <typename Tag>
  TrapLabel<Tag> createTypedLabelWithImplementationId(const SwiftMangledName& name,
                                                      const std::string_view& implementationId) {
    auto untyped = allocateLabel();
    assignKey(untyped, name);
    out << " .implementation " << trapQuoted(implementationId) << '\n';
    return TrapLabel<Tag>::unsafeCreateFromUntyped(untyped);
  }

 private:
  uint64_t id_{0};

  UntypedTrapLabel allocateLabel() { return UntypedTrapLabel{id_++}; }

  void assignStar(UntypedTrapLabel label) { out << label << "=*"; }

  void assignKey(UntypedTrapLabel label, const SwiftMangledName& name) {
    out << label << "=@" << trapQuoted(name.str());
  }
};

}  // namespace codeql
