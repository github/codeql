#pragma once

#include <memory>
#include <sstream>
#include "absl/strings/str_cat.h"

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/logging/SwiftLogging.h"
#include "swift/extractor/infra/SwiftMangledName.h"

namespace codeql {

// Abstracts a given trap output file, with its own universe of trap labels
class TrapDomain {
  TargetFile out;
  Logger logger{getLoggerName()};

 public:
  explicit TrapDomain(TargetFile&& out) : out{std::move(out)} {
    LOG_DEBUG("writing trap file with target {}", this->out.target());
  }

  template <typename Entry>
  void emit(const Entry& e, bool check = true) {
    LOG_TRACE("{}", e);
    if (check) {
      e.forEachLabel([&e, this](const char* field, int index, auto& label) {
        if (!label.valid()) {
          LOG_ERROR("{} has undefined field {}{}", e.NAME, field,
                    index >= 0 ? absl::StrCat("[", index, "]") : "");
        }
      });
    }
    out << e << '\n';
  }

  template <typename... Args>
  void emitComment(const Args&... args) {
    out << "/* ";
    (out << ... << args);
    out << " */\n";
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
    LOG_TRACE("^^^ .implementation {}", implementationId);
    out << " .implementation " << trapQuoted(implementationId) << '\n';
    return TrapLabel<Tag>::unsafeCreateFromUntyped(untyped);
  }

 private:
  uint64_t id_{0};

  UntypedTrapLabel allocateLabel() { return UntypedTrapLabel{id_++}; }

  void assignStar(UntypedTrapLabel label) {
    LOG_TRACE("{}=*", label);
    out << label << "=*";
  }

  void assignKey(UntypedTrapLabel label, const SwiftMangledName& name) {
    auto key = name.str();
    LOG_TRACE("{}=@{}", label, key);
    out << label << "=@" << trapQuoted(key);
  }

  std::string getLoggerName() {
    // packaged swift modules are typically structured as
    // `Module.swiftmodule/<arch_triple>.swiftmodule`, so the parent is more informative
    // We use `Module.swiftmodule/.trap` then
    if (auto parent = out.target().parent_path(); parent.extension() == ".swiftmodule") {
      return parent.filename() / ".trap";
    } else {
      return out.target().filename();
    }
  }
};

}  // namespace codeql
