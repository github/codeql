#include <iostream>
#include <vector>
#include <map>

#include "swift/extractor/translators/DeclTranslator.h"
#include "swift/extractor/translators/ExprTranslator.h"
#include "swift/extractor/translators/StmtTranslator.h"
#include "swift/extractor/translators/TypeTranslator.h"
#include "swift/extractor/translators/PatternTranslator.h"

using namespace codeql;

int main() {
  std::map<const char*, std::vector<const char*>> unextracted;

#define CHECK_CLASS(KIND, CLASS, PARENT)                                                          \
  if constexpr (KIND##Translator::getPolicyFor##CLASS##KIND() == TranslatorPolicy::emitUnknown) { \
    unextracted[#KIND].push_back(#CLASS #KIND);                                                   \
  }

#define DECL(CLASS, PARENT) CHECK_CLASS(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

#define STMT(CLASS, PARENT) CHECK_CLASS(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

#define EXPR(CLASS, PARENT) CHECK_CLASS(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

#define PATTERN(CLASS, PARENT) CHECK_CLASS(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"

#define TYPE(CLASS, PARENT) CHECK_CLASS(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"

  for (const auto& [kind, classes] : unextracted) {
    std::cout << "Unextracted " << kind << " subclasses:\n";
    for (auto cls : classes) {
      std::cout << "  " << cls << '\n';
    }
    std::cout << '\n';
  }
  return 0;
}
