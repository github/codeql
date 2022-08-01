#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/typerepr/TrapClasses.h"

namespace codeql {

class TypeReprVisitor : public AstVisitorBase<TypeReprVisitor> {
 public:
  using AstVisitorBase<TypeReprVisitor>::AstVisitorBase;
};

}  // namespace codeql
