#pragma once

#include <memory>
#include <sstream>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/file/TargetFile.h"

namespace codeql {

// Abstracts a given trap output file, with its own universe of trap labels
class TrapDomain {
  TargetFile& out;

 public:
  explicit TrapDomain(TargetFile& out) : out{out} {}

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

  template <typename Tag>
  TrapLabel<Tag> createLabel() {
    auto ret = allocateLabel<Tag>();
    assignStar(ret);
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabel(Args&&... args) {
    auto ret = allocateLabel<Tag>();
    assignKey(ret, std::forward<Args>(args)...);
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabelWithImplementationId(const std::string& id, Args&&... args) {
    auto ret = allocateLabel<Tag>();
    assignKeyWithImplementationId(ret, id, std::forward<Args>(args)...);
    return ret;
  }

 private:
  uint64_t id{0};

  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return TrapLabel<Tag>::unsafeCreateFromExplicitId(id++);
  }

  template <typename Tag>
  void assignStar(TrapLabel<Tag> label) {
    out << label << "=*\n";
  }

  template <typename Tag, typename... Args>
  void assignKeyNoReturn(TrapLabel<Tag> label, const Args&... keyParts) {
    std::ostringstream oss;
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    oss << Tag::prefix << '_';
    (oss << ... << keyParts);
    out << label << "=@" << trapQuoted(oss.str());
  }

  template <typename Tag, typename... Args>
  void assignKey(TrapLabel<Tag> label, const Args&... keyParts) {
    assignKeyNoReturn(label, keyParts...);
    out << '\n';
  }

  template <typename Tag, typename... Args>
  void assignKeyWithImplementationId(TrapLabel<Tag> label,
                                     const std::string& id,
                                     const Args&... keyParts) {
    assignKeyNoReturn(label, keyParts...);
    out << " .implementation " << trapQuoted(id) << '\n';
  }
};

}  // namespace codeql
