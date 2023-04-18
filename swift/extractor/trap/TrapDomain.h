#pragma once

#include <memory>
#include <sstream>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/infra/log/SwiftLogging.h"

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
  void emit(const Entry& e) {
    LOG_TRACE("{}", e);
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
    emitComment("DEBUG:\n", args..., '\n');
  }

  template <typename Tag>
  TrapLabel<Tag> createLabel() {
    auto ret = allocateLabel<Tag>();
    assignStar(ret);
    out << '\n';
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabel(Args&&... args) {
    auto ret = allocateLabel<Tag>();
    assignKey(ret, std::forward<Args>(args)...);
    out << '\n';
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabelWithImplementationId(const std::string_view& implementationId,
                                                 Args&&... args) {
    auto ret = allocateLabel<Tag>();
    assignKey(ret, std::forward<Args>(args)...);
    LOG_TRACE("^^^ .implementation {}", implementationId);
    out << " .implementation " << trapQuoted(implementationId) << '\n';
    return ret;
  }

 private:
  uint64_t id_{0};

  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return TrapLabel<Tag>::unsafeCreateFromExplicitId(id_++);
  }

  template <typename Tag>
  void assignStar(TrapLabel<Tag> label) {
    LOG_TRACE("{}=*", label);
    out << label << "=*";
  }

  template <typename Tag>
  void assignKey(TrapLabel<Tag> label, const std::string& key) {
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    auto prefixed = std::string(Tag::prefix) + '_' + key;
    LOG_TRACE("{}=@{}", label, prefixed);
    out << label << "=@" << trapQuoted(prefixed);
  }

  template <typename Tag, typename... Args>
  void assignKey(TrapLabel<Tag> label, const Args&... keyParts) {
    std::ostringstream oss;
    (oss << ... << keyParts);
    assignKey(label, oss.str());
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
