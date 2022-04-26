#ifndef SWIFT_EXTRACTOR_H_
#define SWIFT_EXTRACTOR_H_

#include "SwiftExtractorConfiguration.h"
#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>
#include <memory>

namespace codeql {

// TODO: add documentation for the class and its public methods
class SwiftExtractor {
 public:
  explicit SwiftExtractor(const SwiftExtractorConfiguration& config,
                          swift::CompilerInstance& instance);
  void extract();

 private:
  void extractFile(swift::SourceFile& file);

  const SwiftExtractorConfiguration& config;
  swift::CompilerInstance& compiler;
};
}  // namespace codeql

#endif  // SWIFT_EXTRACTOR_H_
