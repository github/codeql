// semmle-extractor-options: --microsoft -std=c99
struct AppleCompatible { // Definitions of Apple are exactly the same in b1.c and b2.c
  int apple_x;
};

// Definitions of Banana are compatible but this copy uses int for the field type
struct BananaCompatible {
  int banana_x;
};

// Definitions of Cherry are not compatible - the field types differ
struct Cherry {
  int cherry_x;
};

// Definitions of Damson are not compatible - the field names differ
struct Damson {
  int damson_x;
};

// Definitions of Elderberry are exactly the same and use a custom typedef
typedef int AnInt;
struct ElderberryCompatible {
  AnInt elderberry_x;
};

// Definitions of Fig are not compatible - one uses float, the other double
struct Fig {
  float fig_x;
};

// Definitions of Grape are not compatible - one uses _Imaginary float, the other _Imaginary double
struct Grape {
  _Imaginary float grape_x;
};

// Definitions of Huckleberry are not compatible - one uses _Complex float, the other _Complex
// double
struct Huckleberry {
  _Complex float huckleberry_x;
};

// Definitions of IndonesianLime are not compatible - they have different array sizes
struct IndonesianLime {
  int indonesian_lime_x[7];
};

// Definitions of Jujube are not compatible - the arrays have different base types
struct Jujube {
  signed int jujube_x[4];
};

// see c1.c and c2.c for Kiwi and Lemon

// Definitions of Mango are not compatible - the enums differ in number of members
// N.B. you'll see two locations for the enum types - we don't currently add a
// compatibility hash to the trap labels for enums like we do for structs, so
// they get merged.
enum MangoEnum { MANGO_ENUM_A, MANGO_ENUM_B };
struct Mango {
  enum MangoEnum mango_x;
};

// Definitions of Nectarine are not compatible - the enum members have different values
enum NectarineEnum { NECTARINE_ENUM_A = 7, NECTARINE_ENUM_B };
struct Nectarine {
  enum NectarineEnum nectarine_x;
};

// Definitions of Orange are not compatible - the enum members have different names
enum OrangeEnum { ORANGE_ENUM_A, ORANGE_ENUM_B };
struct Orange {
  enum OrangeEnum orange_x;
};

// Definitions of Papaya are not compatible - they have pointers pointing to different types
struct Papaya {
  int *papaya_x;
};

// Definitions of Quince are not compatible - the function pointers have different signatures
struct Quince {
  int (*quince_fp)(int,int);
};
