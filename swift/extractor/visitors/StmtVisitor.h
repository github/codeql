#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class StmtVisitor : public AstVisitorBase<StmtVisitor> {
 public:
  using AstVisitorBase<StmtVisitor>::AstVisitorBase;
};

}  // namespace codeql
