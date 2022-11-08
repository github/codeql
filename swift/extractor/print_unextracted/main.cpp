#include <iostream>

#include "swift/extractor/translators/DeclTranslator.h"
#include "swift/extractor/translators/ExprTranslator.h"
#include "swift/extractor/translators/StmtTranslator.h"
#include "swift/extractor/translators/TypeTranslator.h"
#include "swift/extractor/translators/PatternTranslator.h"

using namespace codeql;

#define CHECK_CLASS(KIND, CLASS, PARENT)                             \
  if (!detail::HasTranslate##CLASS##KIND<KIND##Translator>::value && \
      !detail::HasTranslate##PARENT<KIND##Translator>::value) {      \
    std::cout << "  " #CLASS #KIND "\n";                             \
  }

int main() {
  std::cout << "Unextracted Decls:\n";

#define DECL(CLASS, PARENT) CHECK_CLASS(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

  std::cout << "\nUnextracted Stmts:\n";

#define STMT(CLASS, PARENT) CHECK_CLASS(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

  std::cout << "\nUnextracted Exprs:\n";

#define EXPR(CLASS, PARENT) CHECK_CLASS(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

  std::cout << "\nUnextracted Patterns:\n";

#define PATTERN(CLASS, PARENT) CHECK_CLASS(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"

  std::cout << "\nUnextracted Types:\n";

#define TYPE(CLASS, PARENT) CHECK_CLASS(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"

  return 0;
}
