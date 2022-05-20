#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class DeclVisitor : public AstVisitorBase<DeclVisitor> {
 public:
  using AstVisitorBase<DeclVisitor>::AstVisitorBase;
};

}  // namespace codeql
