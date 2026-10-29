// This is a small C++ addition to the compatible_c test.
// Note that we decided to follow the C compatibility rules for merging types,
// not the C++ ODR rules.

// Definitions of Apple are exactly the same in b1.c and b2.c
class AppleCompatible {
  int apple_x;
};

// Definitions of Banana are compatible but this copy uses int for the field type
class BananaCompatible {
  int banana_x;
};

// Definitions of Cherry are not compatible - the field types differ
class Cherry {
  int cherry_x;
};

// This shows that we currently only consider member variables, and ignore
// functions when deciding on class compatibility. In this file there is a
// member function called `foo`, in b2.cpp there is one called `bar`.
class Damson {
  int damson_x;
  void foo();
};

namespace unrelated {
  class AppleCompatible {
    long apple_x;
  };
}
