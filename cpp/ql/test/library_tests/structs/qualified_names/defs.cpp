namespace foo {
  class C {
  };
}

namespace bar {
  class C {
  };
}

class DefinedAndDeclared {
};

// Despite this declaration being present, the variable below is associated
// with the definition above rather than this declaration.
class DefinedAndDeclared;

DefinedAndDeclared *definedAndDeclared;

#include "header.h"

// Because there are multiple definitions of `MultipleDefsButSameHeader`, the
// type of this variable will refer to the declaration in `header.h` rather
// than any of the definitions.
MultipleDefsButSameHeader *mdbsh;

// Because there is only one definition of `OneDefInDifferentFile`, the type of
// this variable will refer to that definition.
OneDefInDifferentFile *odidf;
