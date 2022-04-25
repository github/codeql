#ifndef SWIFT_EXTRACTOR_H_
#define SWIFT_EXTRACTOR_H_

#include "Configuration.h"
#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>
#include <memory>

namespace codeql {

// TODO: add documentation for the class and its public methods
class Extractor {
 public:
  explicit Extractor(const Configuration& config, swift::CompilerInstance& instance);
  void extract();

 private:
  void extractFile(swift::SourceFile& file);

  const Configuration& config;
  swift::CompilerInstance& compiler;
};
}  // namespace codeql

#endif  // SWIFT_EXTRACTOR_H_
