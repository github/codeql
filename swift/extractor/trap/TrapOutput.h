#pragma once

#include <memory>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/SwiftExtractorConfiguration.h"
#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

// Sink for trap emissions and label assignments. This abstracts away `ofstream` operations
// like `ofstream`, an explicit bool operator is provided, that return false if something
// went wrong
class TrapOutput {
  std::ofstream out_{};
  std::string target_;

 public:
  // open a output stream. Internally a temporary file is created which is then moved into place
  // on `close()` or destruction
  TrapOutput(const SwiftExtractorConfiguration& config, const std::string& target) {
    // TODO: Pick a better name to avoid collisions
    llvm::SmallString<PATH_MAX> trapPath(config.trapDir);
    llvm::sys::path::append(trapPath, target);
    target_ = trapPath.str().str();

    auto trapDir = llvm::sys::path::parent_path(trapPath);
    if (std::error_code ec = llvm::sys::fs::create_directories(trapDir)) {
      std::cerr << "Cannot create trap directory '" << trapDir.str() << "': " << ec.message()
                << "\n";
      return;
    }

    auto tempFile = getTempFile();
    out_ = std::ofstream{tempFile};
    if (!out_) {
      std::error_code ec;
      ec.assign(errno, std::generic_category());
      std::cerr << "Cannot create temp trap file '" << tempFile << "': " << ec.message() << "\n";
      return;
    }
    out_ << "// extractor-args: ";
    for (auto opt : config.frontendOptions) {
      out_ << std::quoted(opt) << " ";
    }
    out_ << "\n\n";
  }

  ~TrapOutput() { close(); }

  TrapOutput(const TrapOutput& other) = delete;
  TrapOutput& operator=(const TrapOutput& other) = delete;

  TrapOutput(TrapOutput&& other) : out_{std::move(other.out_)}, target_{std::move(other.target_)} {
    assert(!other.out_.is_open());
  }

  TrapOutput& operator=(TrapOutput&& other) {
    close();
    out_ = std::move(other.out_);
    target_ = std::move(other.target_);
    return *this;
  }

  explicit operator bool() const { return bool{out_}; }

  void close() {
    // TODO: The last process wins. Should we do better than that?
    if (out_.is_open()) {
      out_.close();
      auto tempFile = getTempFile();
      auto targetFile = getTargetFile();
      if (std::error_code ec = llvm::sys::fs::rename(tempFile, targetFile)) {
        std::cerr << "Cannot rename temp trap file '" << tempFile << "' -> '" << targetFile
                  << "': " << ec.message() << "\n";
      }
    }
  }

  template <typename Tag>
  void assignStar(TrapLabel<Tag> label) {
    print(label, "=*");
  }

  template <typename Tag>
  void assignKey(TrapLabel<Tag> label, const std::string& key) {
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    auto prefixed = std::string(Tag::prefix) + '_' + key;
    print(label, "=@", trapQuoted(prefixed));
  }

  template <typename Tag, typename... Args>
  void assignKey(TrapLabel<Tag> label, const Args&... keyParts) {
    std::ostringstream oss;
    (oss << ... << keyParts);
    assignKey(label, oss.str());
  }

  template <typename Entry>
  void emit(const Entry& e) {
    print(e);
  }

 private:
  std::string getTargetFile() { return target_ + ".trap"; }
  std::string getTempFile() {
    // TODO: find a more robust approach to avoid collisions?
    return target_ + '.' + std::to_string(getpid()) + ".trap";
  }

  template <typename... Args>
  void print(const Args&... args) {
    (out_ << ... << args) << '\n';
  }
};

}  // namespace codeql
