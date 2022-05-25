#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class TypeReprVisitor : public AstVisitorBase<TypeReprVisitor> {
 public:
  using AstVisitorBase<TypeReprVisitor>::AstVisitorBase;
};

}  // namespace codeql
