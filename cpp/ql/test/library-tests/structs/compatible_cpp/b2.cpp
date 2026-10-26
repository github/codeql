// Definitions of Apple are exactly the same in b1.c and b2.c
class AppleCompatible {
  int apple_x;
};

// Definitions of Banana are compatible but this copy uses a typedef
typedef int MyInt;
typedef MyInt IntType;
class BananaCompatible {
  IntType banana_x;
};

// Definitions of Cherry are not compatible - the field types differ
class Cherry {
  short cherry_x;
};

// This shows that we currently only consider member variables, and ignore
// functions when deciding on class compatibility. In this file there is a
// member function called `bar`, in b1.cpp there is one called `foo`.
class Damson {
  int damson_x;
  void bar();
};
