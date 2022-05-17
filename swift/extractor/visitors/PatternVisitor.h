#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class PatternVisitor : public AstVisitorBase<PatternVisitor> {
 public:
  using AstVisitorBase<PatternVisitor>::AstVisitorBase;
};

}  // namespace codeql
