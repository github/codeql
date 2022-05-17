#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
namespace codeql {
class TypeVisitor : public TypeVisitorBase<TypeVisitor> {
 public:
  using TypeVisitorBase<TypeVisitor>::TypeVisitorBase;
};

}  // namespace codeql
