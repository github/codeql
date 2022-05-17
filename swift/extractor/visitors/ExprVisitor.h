#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class ExprVisitor : public AstVisitorBase<ExprVisitor> {
 public:
  using AstVisitorBase<ExprVisitor>::AstVisitorBase;
};

}  // namespace codeql
